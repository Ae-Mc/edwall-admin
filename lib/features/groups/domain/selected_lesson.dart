import 'package:edwall_admin/features/groups/domain/lesson.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'selected_lesson.g.dart';

@Riverpod(keepAlive: true)
class SelectedLesson extends _$SelectedLesson {
  LessonRead? _selected;

  @override
  LessonRead? build() => _selected;

  void setLesson(LessonRead? lesson) {
    if (lesson != _selected) {
      _selected = lesson;
      ref.invalidateSelf();
    }
  }

  Future<LessonRead> loadLesson(int lessonId) async {
    if (_selected?.id != lessonId) {
      final lesson = await ref.read(lessonProvider(lessonId).future);
      setLesson(lesson);
    }
    return _selected!;
  }
}
