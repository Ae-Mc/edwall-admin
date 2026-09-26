import 'dart:convert';
import 'dart:io';

/// Rewrites nullable OpenAPI 3.1 arrays into the equivalent type-union form.
///
/// swagger_dart_code_generator 4.1.1 otherwise turns an `anyOf` containing an
/// array and null into a non-existent `ListModel` type. Run this after replacing
/// the schema and before running build_runner.
void main() {
  final file = File('lib/swaggers/schema.json');
  final document = jsonDecode(file.readAsStringSync());
  var replacements = 0;

  void normalize(Object? node) {
    if (node is List<Object?>) {
      for (final value in node) {
        normalize(value);
      }
      return;
    }
    if (node is! Map<String, Object?>) return;

    final anyOf = node['anyOf'];
    if (anyOf is List<Object?> && anyOf.length == 2) {
      Map<String, Object?>? arraySchema;
      var containsNull = false;
      for (final option in anyOf) {
        if (option is Map<String, Object?> && option['type'] == 'array') {
          arraySchema = option;
        } else if (option is Map<String, Object?> && option['type'] == 'null') {
          containsNull = true;
        }
      }

      if (arraySchema != null && containsNull) {
        node
          ..remove('anyOf')
          ..addAll(arraySchema)
          ..['type'] = <String>['array', 'null'];
        replacements++;
      }
    }

    for (final value in node.values.toList()) {
      normalize(value);
    }
  }

  normalize(document);
  if (replacements == 0) {
    stdout.writeln('OpenAPI schema is already normalized.');
    return;
  }

  file.writeAsStringSync(jsonEncode(document));
  stdout.writeln('Normalized $replacements nullable array definition(s).');
}
