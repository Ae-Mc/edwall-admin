import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_model.freezed.dart';
part 'settings_model.g.dart';

@freezed
sealed class SavedLogin with _$SavedLogin {
  const factory SavedLogin({
    required BearerResponseRefresh token,
    required String username,
  }) = SavedLoginConstructor;

  factory SavedLogin.fromJson(Map<String, dynamic> json) =>
      _$SavedLoginFromJson(json);
}

@freezed
sealed class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    @Default([]) List<SavedLogin> savedLogins,
    required int wallId,
  }) = SettingsModelConstructor;

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);
}
