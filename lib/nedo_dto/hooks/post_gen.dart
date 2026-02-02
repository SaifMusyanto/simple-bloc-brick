import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final models = context.vars['models'] as List;
  final progress =
      context.logger.progress('Generating ${models.length} model files...');

  for (final model in models) {
    final modelMap = model as Map<String, dynamic>;
    final fileName = modelMap['fileName'] as String;
    final fileContent = _generateContent(modelMap);

    final file = File('$fileName.dart');
    await file.writeAsString(fileContent);
  }
  progress.complete('Generated ${models.length} files.');
}

String _generateContent(Map<String, dynamic> model) {
  final name = model['name'] as String;
  final fields = model['fields'] as List;
  final usesCollection = model['usesCollection'] as bool;

  final buffer = StringBuffer();

  final customFields = fields.where((f) => f['isCustom'] == true).toList();
  buffer.writeln("// ignore_for_file: prefer_expression_function_bodies");
  buffer.writeln();
  buffer.writeln("import 'dart:convert';");
  if (usesCollection) {
    buffer.writeln("import 'package:collection/collection.dart';");
  }
  for (final field in customFields) {
    final innerType = field['innerType'] as String;
    buffer.writeln("import '${innerType.snakeCase}.dart';");
  }
  buffer.writeln();

  buffer.writeln('class $name {');

  for (final f in fields) {
    final type = f['type'];
    final fname = f['name'];
    buffer.writeln('  final $type $fname;');
  }
  buffer.writeln();
  buffer.writeln('  const $name({');
  for (final f in fields) {
    final fname = f['name'];
    final isReq = f['isRequired'] as bool;
    buffer.writeln('    ${isReq ? 'required ' : ''}this.$fname,');
  }
  buffer.writeln('  });');
  buffer.writeln();

  buffer.writeln('  $name copyWith({');
  for (final f in fields) {
    final type = f['type'];
    final fname = f['name'];
    final isReq = f['isRequired'] as bool;
    buffer.writeln('    ${!isReq ? type : type + '?'} $fname,');
  }
  buffer.writeln('  }) {');
  buffer.writeln('    return $name(');
  for (final f in fields) {
    final fname = f['name'];
    buffer.writeln('      $fname: $fname ?? this.$fname,');
  }
  buffer.writeln('    );');
  buffer.writeln('  }');
  buffer.writeln();

  // fromMap
  buffer.writeln('  factory $name.fromMap(Map<String, dynamic> map) {');
  buffer.writeln('    return $name(');
  for (final f in fields) {
    final fname = f['name'];
    final originalName = f['originalName'];
    final type = f['type'];
    final innerType = f['innerType'];
    final isList = f['isList'] as bool;
    final isCustom = f['isCustom'] as bool;
    final isRequired = f['isRequired'] as bool;

    buffer.write('      $fname: ');

    if (isCustom) {
      if (isList) {
        buffer.write(
            "map['$originalName'] != null ? List<$innerType>.from((map['$originalName'] as List<dynamic>).map((x) => $innerType.fromMap(x as Map<String, dynamic>))) : ${isRequired ? '[]' : 'null'},");
      } else {
        buffer.write(
            "map['$originalName'] != null ? $type.fromMap(map['$originalName'] as Map<String, dynamic>) : ${isRequired ? "throw Exception('$originalName is required')" : 'null'},");
      }
    } else {
      if (isList) {
        buffer.write(
            "map['$originalName'] != null ? List<$innerType>.from(map['$originalName'] as List<dynamic>) : ${isRequired ? '[]' : 'null'},");
      } else {
        buffer.write("map['$originalName'] as $type,");
      }
    }
    buffer.writeln();
  }
  buffer.writeln('    );');
  buffer.writeln('  }');
  buffer.writeln();

  // toMap
  buffer.writeln('  Map<String, dynamic> toMap() {');
  buffer.writeln('    return <String, dynamic>{');
  for (final f in fields) {
    final fname = f['name'];
    final originalName = f['originalName'];
    final isList = f['isList'] as bool;
    final isCustom = f['isCustom'] as bool;
    final isReq = f['isRequired'] as bool;

    buffer.write("      '$originalName': ");
    if (isCustom) {
      if (isList) {
        buffer
            .write("$fname${isReq ? '' : '?'}.map((x) => x.toMap()).toList(),");
      } else {
        buffer.write("$fname${isReq ? '' : '?'}.toMap(),");
      }
    } else {
      buffer.write("$fname,");
    }
    buffer.writeln();
  }
  buffer.writeln('    };');
  buffer.writeln('  }');
  buffer.writeln();

  // toJson/fromJson
  buffer.writeln('  String toJson() => json.encode(toMap());');
  buffer.writeln();
  buffer.writeln(
      '  factory $name.fromJson(String source) => $name.fromMap(json.decode(source) as Map<String, dynamic>);');
  buffer.writeln();

  // toString
  buffer.writeln('  @override');
  buffer.writeln('  String toString() {');
  buffer.write("    return '$name(");
  for (final f in fields) {
    final fname = f['name'];
    buffer.write("$fname: \$$fname, ");
  }
  buffer.writeln(")';");
  buffer.writeln('  }');
  buffer.writeln();

  buffer.writeln('  @override');
  buffer.writeln('  bool operator ==(Object other) {');
  buffer.writeln('    if (identical(this, other)) return true;');
  buffer.writeln('    return other is $name &&');
  for (final f in fields) {
    final fname = f['name'];
    final isList = f['isList'] as bool;
    if (isList) {
      buffer.writeln(
          '      const DeepCollectionEquality().equals(other.$fname, $fname) &&');
    } else {
      buffer.writeln('      other.$fname == $fname &&');
    }
  }
  buffer.writeln('      true;');
  buffer.writeln('  }');
  buffer.writeln();

  buffer.writeln('  @override');
  buffer.writeln('  int get hashCode {');
  buffer.writeln('    return ');
  for (final f in fields) {
    final fname = f['name'];
    final isList = f['isList'] as bool;
    if (isList) {
      buffer.writeln('      const DeepCollectionEquality().hash($fname) ^');
    } else {
      buffer.writeln('      $fname.hashCode ^');
    }
  }
  buffer.writeln('      0;');
  buffer.writeln('  }');

  buffer.writeln('}');

  return buffer.toString();
}
