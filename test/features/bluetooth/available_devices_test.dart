import 'package:edwall_admin/features/bluetooth/domain/available_devices.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('accepts device names containing School and Flashboard', () {
    expect(isFlashboardDeviceName('School Flashboard'), isTrue);
    expect(isFlashboardDeviceName('EDWall SCHOOL flashboard 01'), isTrue);
  });

  test('rejects device names missing either required word', () {
    expect(isFlashboardDeviceName('School'), isFalse);
    expect(isFlashboardDeviceName('Flashboard'), isFalse);
    expect(isFlashboardDeviceName('Other device'), isFalse);
    expect(isFlashboardDeviceName(null), isFalse);
  });
}
