import 'package:edwall_admin/core/functions/exception_handlers/client_exception_handler.dart';
import 'package:edwall_admin/core/functions/force_get_body.dart';
import 'package:edwall_admin/core/infrastructure/api_client.dart';
import 'package:edwall_admin/core/util/keepalive.dart';
import 'package:edwall_admin/generated/schema.swagger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'lesson.g.dart';

@riverpod
Future<LessonRead> lesson(Ref ref, int lessonId) {
  return keepAlive(ref, () async {
    final response = (await ref.read(
      apiClientProvider.future,
    )).apiV1LessonsLessonIdGet(lessonId: lessonId);
    return forceGetBody(await clientExceptionHandler(response));
  });
}
