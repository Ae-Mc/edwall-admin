import 'package:bluetooth_classic_multiplatform/bluetooth_classic_multiplatform.dart';
import 'package:edwall_admin/core/exceptions/exception_with_message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'available_devices.g.dart';

@riverpod
Future<Raw<Stream<BluetoothDevice>>> availableDevices(Ref ref) async {
  final bluetooth = BluetoothClassicMultiplatform();
  if (await bluetooth.isEnabled == false) {
    bluetooth.requestEnable();
    final enabled = await bluetooth.isEnabled;
    Logger().d('Enabled: $enabled');
    if (enabled != true) {
      throw ExceptionWithMessage("Bluetooth не включен");
    }
  }
  bluetooth.startScan();
  return bluetooth.scanResults;
}
