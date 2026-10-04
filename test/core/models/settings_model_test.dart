import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('enables Bluetooth auto-connect for existing settings', () {
    final settings = SettingsModel.fromJson({'wallId': 1});

    expect(settings.bluetoothAutoConnect, isTrue);
  });

  test('persists disabled Bluetooth auto-connect', () {
    const settings = SettingsModel(wallId: 1, bluetoothAutoConnect: false);

    expect(
      SettingsModel.fromJson(settings.toJson()).bluetoothAutoConnect,
      isFalse,
    );
  });
}
