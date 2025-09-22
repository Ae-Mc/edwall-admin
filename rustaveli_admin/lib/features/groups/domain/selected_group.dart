import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_group.g.dart';

@Riverpod(keepAlive: true)
class SelectedGroup extends _$SelectedGroup {
  @override
  StudyGroupRead? build() => state;

  void setGroup(StudyGroupRead? group) {
    state = group;
  }
}
