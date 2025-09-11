import 'package:edwall_admin/core/models/settings_model.dart';
import 'package:edwall_admin/core/providers/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_login.g.dart';

@Riverpod(keepAlive: true)
class SelectedLogin extends _$SelectedLogin {
  SavedLogin? _selected;

  @override
  SavedLogin? build() => _selected;

  Future<void> selectLogin(SavedLogin? login) async {
    if (_selected != login) {
      _selected = login;
      if (login != null) {
        await ref.read(settingsProvider.notifier).addSavedLogin(login);
      }
      ref.invalidateSelf();
    }
  }
}
