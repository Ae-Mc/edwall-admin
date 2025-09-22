import 'dart:convert';

import 'package:edwall_admin/core/const.dart';
import 'package:edwall_admin/core/infrastructure/local_storage.dart';
import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:logger/web.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'settings.g.dart';

@Riverpod(keepAlive: true)
class Settings extends _$Settings {
  SettingsModel? loadedModel;

  @override
  Future<SettingsModel> build() async {
    Logger().d('Settings build');
    if (loadedModel == null) {
      final storage = await ref.watch(localStorageProvider.future);
      final settingsStr = storage.getString(settingsKey);

      if (settingsStr != null) {
        final json = jsonDecode(settingsStr);
        loadedModel = SettingsModel.fromJson(json);
      } else {
        loadedModel = SettingsModel(wallId: 1);
      }
    }
    return loadedModel!;
  }

  Future<void> save(SettingsModel newSettings) async {
    final storage = await ref.read(localStorageProvider.future);
    loadedModel = newSettings;
    await storage.setString(settingsKey, jsonEncode(loadedModel?.toJson()));
    ref.invalidateSelf();
  }

  Future<void> addSavedLogin(SavedLogin login) {
    final settings = state.valueOrNull;
    final newLogins = List<SavedLogin>.from(settings?.savedLogins ?? []);
    final newLogin = login;
    final existingLoginIndex = newLogins.indexWhere(
      (element) => element.username == login.username,
    );
    if (existingLoginIndex != -1) {
      newLogins.removeAt(existingLoginIndex);
    }
    newLogins.insert(0, newLogin);
    return save(
      SettingsModel(wallId: settings?.wallId ?? 1, savedLogins: newLogins),
    );
  }

  Future<void> removeSavedLogin(SavedLogin login) {
    final settings = state.valueOrNull;
    final newLogins = List<SavedLogin>.from(settings?.savedLogins ?? []);
    newLogins.remove(login);
    return save(
      SettingsModel(wallId: settings?.wallId ?? 1, savedLogins: newLogins),
    );
  }
}
