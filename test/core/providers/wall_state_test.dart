import 'dart:async';

import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:edwall_admin/core/providers/active_holds.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:edwall_admin/core/providers/wall.dart';
import 'package:edwall_admin/core/providers/wall_state.dart';
import 'package:edwall_admin/features/bluetooth/domain/flashboard_connection.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Settings extends Settings {
  @override
  Future<SettingsModel> build() async => const SettingsModel(wallId: 1);
}

class _DelayedSettings extends Settings {
  _DelayedSettings(this.completer);

  final Completer<SettingsModel> completer;

  @override
  Future<SettingsModel> build() => completer.future;
}

void main() {
  final wallHold = WallHoldReadWithHold(
    angle: 0,
    bank: 1,
    $num: 7,
    numberInWall: 0,
    wallId: 1,
    holdId: 1,
    id: 1,
    hold: const Hold(id: 1, name: 'Test hold'),
  );
  final wall = WallRead(
    description: 'Test wall',
    width: 1,
    height: 1,
    numberOfModules: 1,
    id: 1,
    holds: [wallHold],
  );
  final route = RouteRead(
    description: 'Test route',
    name: 'Test route',
    difficult: '',
    numberOfModules: 1,
    userId: 1,
    id: 1,
    hardness: null,
    holds: [RouteHoldReadWithWallHold(type: 2, wallhold: wallHold)],
    programmes: const [],
  );

  late ProviderContainer container;

  setUp(() async {
    container = ProviderContainer(
      overrides: [
        settingsProvider.overrideWith(_Settings.new),
        wallProvider(1).overrideWith((ref) async => wall),
      ],
    );
    await container.read(settingsProvider.future);
    await container.read(flashboardConnectionProvider.future);
    await container.read(wallStateProvider(0, 0).future);
  });

  tearDown(() => container.dispose());

  test('showRoute updates hold state without a BLE connection', () async {
    await container.read(wallStateProvider(0, 0).notifier).showRoute(route, 0);

    expect(await container.read(wallStateProvider(1, 7).future), 2);
  });

  test('clear updates hold state without a BLE connection', () async {
    final controller = container.read(wallStateProvider(0, 0).notifier);
    await controller.showRoute(route, 0);
    await controller.clear(wall);

    expect(await container.read(wallStateProvider(1, 7).future), 0);
  });

  test('active holds survives an async settings load', () async {
    final settingsCompleter = Completer<SettingsModel>();
    final delayedContainer = ProviderContainer(
      overrides: [
        settingsProvider.overrideWith(
          () => _DelayedSettings(settingsCompleter),
        ),
        wallProvider(1).overrideWith((ref) async => wall),
      ],
    );
    addTearDown(delayedContainer.dispose);

    final activeHolds = delayedContainer.read(activeHoldsProvider.future);
    await Future<void>.delayed(Duration.zero);
    settingsCompleter.complete(const SettingsModel(wallId: 1));

    expect(await activeHolds, isEmpty);
  });
}
