import 'package:edwall_admin/features/bluetooth/domain/bluetooth_device.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_ble/universal_ble.dart';
part 'available_devices.g.dart';

bool isFlashboardDeviceName(String? name) {
  final normalizedName = name?.toLowerCase();
  return normalizedName?.contains('school') == true &&
      normalizedName?.contains('flashboard') == true;
}

@riverpod
Stream<BluetoothDevice> availableDevices(Ref ref) async* {
  ref.onDispose(() async {
    await UniversalBle.stopScan();
    Logger().d('BLE scan stopped');
  });

  await UniversalBle.startScan();
  Logger().d('BLE scan started');
  await for (final device in UniversalBle.scanStream) {
    if (!isFlashboardDeviceName(device.name)) continue;
    yield BluetoothDevice(name: device.name, address: device.deviceId);
    if (!await UniversalBle.isScanning()) break;
  }
}
