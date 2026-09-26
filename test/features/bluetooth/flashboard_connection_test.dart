import 'dart:typed_data';

import 'package:edwall_admin/features/bluetooth/domain/bluetooth_device.dart';
import 'package:edwall_admin/features/bluetooth/domain/flashboard_connection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_ble/universal_ble.dart';

const _serviceUuid = '00000000-0000-0000-0000-000000000000';
String _uuid(int command) => '00000000-0000-0000-0000-00000000000$command';
String _applyUuid(int command) => '00000000-0000-0000-0001-00000000000$command';

BleCharacteristic _characteristic(int command, {bool apply = false}) =>
    BleCharacteristic.withMetaData(
      deviceId: 'wall',
      serviceId: _serviceUuid,
      uuid: apply ? _applyUuid(command) : _uuid(command),
      properties: [
        CharacteristicProperty.write,
        CharacteristicProperty.writeWithoutResponse,
      ],
      descriptors: [],
    );

class _BlePlatform extends UniversalBlePlatform {
  final writes = <(String, List<int>, BleOutputProperty)>[];

  @override
  Future<BleConnectionState> getConnectionState(String deviceId) async =>
      BleConnectionState.connected;

  @override
  Future<void> writeValue(
    String deviceId,
    String service,
    String characteristic,
    Uint8List value,
    BleOutputProperty property,
  ) async {
    writes.add((characteristic, value.toList(), property));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected BLE call: ${invocation.memberName}');
}

class _Connection extends FlashboardConnection {
  @override
  Future<BleConnection?> build() async => BleConnection(
    device: const BluetoothDevice(name: 'Wall', address: 'wall'),
    mtu: connectionMtu,
    applyCharacteristic: _characteristic(0),
    clearCharacteristic: _characteristic(1),
    setLedsCharacteristic: _characteristic(4),
    fillIntervalCharacteristic: _characteristic(6),
    clearAndApplyCharacteristic: _characteristic(1, apply: true),
    setLedAndApplyCharacteristic: _characteristic(3, apply: true),
    fillIntervalAndApplyCharacteristic: _characteristic(6, apply: true),
  );
}

var connectionMtu = 517;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _BlePlatform platform;
  late ProviderContainer container;
  late FlashboardConnection connection;

  setUp(() async {
    connectionMtu = 517;
    platform = _BlePlatform();
    UniversalBle.setInstance(platform);
    container = ProviderContainer(
      overrides: [flashboardConnectionProvider.overrideWith(_Connection.new)],
    );
    await container.read(flashboardConnectionProvider.future);
    connection = container.read(flashboardConnectionProvider.notifier);
  });

  tearDown(() => container.dispose());

  test('setLeds encodes LED numbers and applies the batch', () async {
    await connection.setLeds([(2, 256), (3, 513)], 3);

    expect(platform.writes, hasLength(2));
    expect(platform.writes.first.$1, _uuid(4));
    expect(platform.writes.first.$2, [2, 0, 1, 3, 3, 1, 2, 3]);
    expect(platform.writes.first.$3, BleOutputProperty.withResponse);
    expect(platform.writes.last.$1, _uuid(0));
    expect(platform.writes.last.$2, [0]);
  });

  test('setLeds splits commands at the negotiated MTU boundary', () async {
    connectionMtu = 23;
    container.invalidate(flashboardConnectionProvider);
    await container.read(flashboardConnectionProvider.future);

    await connection.setLeds([for (var i = 0; i < 6; i++) (0, i)], 2);

    expect(platform.writes.map((write) => write.$1), [
      _uuid(4),
      _uuid(4),
      _uuid(0),
    ]);
    expect(platform.writes.first.$2, hasLength(20));
    expect(platform.writes[1].$2, hasLength(4));
  });
}
