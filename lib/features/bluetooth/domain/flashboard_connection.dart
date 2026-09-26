import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/features/bluetooth/domain/bluetooth_device.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_ble/universal_ble.dart';

part 'flashboard_connection.g.dart';

const _flashboardServiceUuid = '00000000-0000-0000-0000-000000000000';
const _applyUuid = '00000000-0000-0000-0000-000000000000';
const _clearUuid = '00000000-0000-0000-0000-000000000001';
const _setLedsUuid = '00000000-0000-0000-0000-000000000004';
const _fillIntervalUuid = '00000000-0000-0000-0000-000000000006';
const _clearAndApplyUuid = '00000000-0000-0000-0001-000000000001';
const _setLedAndApplyUuid = '00000000-0000-0000-0001-000000000003';
const _fillIntervalAndApplyUuid = '00000000-0000-0000-0001-000000000006';

const _setLedCommandSize = 4;

List<int> _setLedCommand(int bank, int ledNumber, int color) => [
  bank,
  ledNumber % 256,
  ledNumber ~/ 256,
  color,
];

List<int> _fillIntervalCommand(int bank, int ledFrom, int ledTo, int color) => [
  bank,
  ledFrom % 256,
  ledFrom ~/ 256,
  ledTo % 256,
  ledTo ~/ 256,
  color,
];

class BleConnection {
  final BluetoothDevice device;
  final int mtu;
  final BleCharacteristic applyCharacteristic;
  final BleCharacteristic clearCharacteristic;
  final BleCharacteristic setLedsCharacteristic;
  final BleCharacteristic fillIntervalCharacteristic;
  final BleCharacteristic clearAndApplyCharacteristic;
  final BleCharacteristic setLedAndApplyCharacteristic;
  final BleCharacteristic fillIntervalAndApplyCharacteristic;

  const BleConnection({
    required this.device,
    required this.mtu,
    required this.applyCharacteristic,
    required this.clearCharacteristic,
    required this.setLedsCharacteristic,
    required this.fillIntervalCharacteristic,
    required this.clearAndApplyCharacteristic,
    required this.setLedAndApplyCharacteristic,
    required this.fillIntervalAndApplyCharacteristic,
  });
}

@Riverpod(keepAlive: true)
class FlashboardConnection extends _$FlashboardConnection {
  @override
  Future<BleConnection?> build() async => null;

  Future<void> connectToDevice(BluetoothDevice device) async {
    state = const AsyncLoading();
    try {
      await UniversalBle.stopScan();
      await UniversalBle.connect(device.address);
      final mtu = await UniversalBle.requestMtu(device.address, 517);
      final services = await UniversalBle.discoverServices(device.address);
      final service = services
          .where(
            (service) => service.uuid.toLowerCase() == _flashboardServiceUuid,
          )
          .firstOrNull;
      if (service == null) {
        throw StateError('Устройство не поддерживает протокол Flashboard BLE');
      }

      BleCharacteristic characteristic(String uuid) {
        return service.characteristics.firstWhere(
          (characteristic) => characteristic.uuid.toLowerCase() == uuid,
          orElse: () => throw StateError(
            'В BLE-сервисе отсутствует характеристика $uuid',
          ),
        );
      }

      state = AsyncData(
        BleConnection(
          device: device,
          mtu: mtu,
          applyCharacteristic: characteristic(_applyUuid),
          clearCharacteristic: characteristic(_clearUuid),
          setLedsCharacteristic: characteristic(_setLedsUuid),
          fillIntervalCharacteristic: characteristic(_fillIntervalUuid),
          clearAndApplyCharacteristic: characteristic(_clearAndApplyUuid),
          setLedAndApplyCharacteristic: characteristic(_setLedAndApplyUuid),
          fillIntervalAndApplyCharacteristic: characteristic(
            _fillIntervalAndApplyUuid,
          ),
        ),
      );
    } catch (error, stackTrace) {
      try {
        await UniversalBle.disconnect(device.address);
      } catch (_) {
        // The connection may not have been established yet.
      }
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> _writeLeds(
    BleConnection connection,
    List<(int bank, int ledNumber, Color color)> leds,
  ) async {
    final batch = <int>[];
    for (final (bank, led, color) in leds) {
      final colorNumber = colorToLEColorNumber[color];
      if (colorNumber == null) {
        throw ArgumentError.value(color, 'color', 'Unsupported LED color');
      }
      batch.addAll(_setLedCommand(bank, led, colorNumber));
    }

    final maxPayload =
        (connection.mtu - 3).clamp(0, 512) ~/
        _setLedCommandSize *
        _setLedCommandSize;
    if (batch.isNotEmpty && maxPayload < _setLedCommandSize) {
      throw StateError(
        'MTU ${connection.mtu} не вмещает одну команду SET_LEDS',
      );
    }

    for (var offset = 0; offset < batch.length; offset += maxPayload) {
      final end = (offset + maxPayload).clamp(0, batch.length);
      await connection.setLedsCharacteristic.write(
        batch.sublist(offset, end),
        withResponse: true,
      );
    }
  }

  Future<void> setLeds(List<(int, int)> leds, int ledState) async {
    final color = holdTypeToColor[ledState]!;
    final connection = await _requireConnection();
    await _writeLeds(connection, [
      for (final (bank, led) in leds) (bank, led, color),
    ]);
    await connection.applyCharacteristic.write([0], withResponse: true);
  }

  Future<void> showRoute(RouteRead route) async {
    final connection = await _requireConnection();
    await connection.clearCharacteristic.write([0], withResponse: true);
    await _writeLeds(connection, [
      for (final hold in route.holds)
        (hold.wallhold.bank, hold.wallhold.$num, holdTypeToColor[hold.type]!),
    ]);
    await connection.applyCharacteristic.write([0], withResponse: true);
  }

  Future<void> setLed(int bank, int ledNumber, int ledState) async {
    final connection = await _requireConnection();
    final color = holdTypeToColor[ledState]!;
    final colorNumber = colorToLEColorNumber[color]!;
    await connection.setLedAndApplyCharacteristic.write(
      _setLedCommand(bank, ledNumber, colorNumber),
      withResponse: false,
    );
  }

  Future<void> fillInterval(
    int bank,
    int ledFrom,
    int ledTo,
    int ledState,
  ) async {
    final connection = await _requireConnection();
    final color = holdTypeToColor[ledState]!;
    await connection.fillIntervalAndApplyCharacteristic.write(
      _fillIntervalCommand(bank, ledFrom, ledTo, colorToLEColorNumber[color]!),
      withResponse: true,
    );
  }

  Future<void> clear() async {
    final connection = await _requireConnection();
    await connection.clearAndApplyCharacteristic.write([
      0,
    ], withResponse: false);
  }

  Future<BleConnection> _requireConnection() async {
    final connection = state.value;
    if (connection == null ||
        await UniversalBle.getConnectionState(connection.device.address) !=
            BleConnectionState.connected) {
      ref.invalidateSelf();
      throw StateError('Нет подключения к скалодрому');
    }
    return connection;
  }

  Future<void> disconnect() async {
    final connection = state.value;
    if (connection != null) {
      try {
        await UniversalBle.disconnect(connection.device.address);
      } catch (error, stackTrace) {
        Logger().w(
          'Failed to disconnect BLE device',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
    state = const AsyncData(null);
    Logger().d('BLE device disconnected');
  }
}
