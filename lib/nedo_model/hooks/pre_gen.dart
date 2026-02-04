import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  String path = context.vars['schema_url'] as String;
  final rawTarget = context.vars['target_component'];

  final List<String> targetComponents = [];

  final Iterable<String> inputs = rawTarget is List
      ? rawTarget.map((e) => e.toString())
      : (rawTarget is String && rawTarget.isNotEmpty ? [rawTarget] : const []);

  for (final rawName in inputs) {
    if (rawName.endsWith('BaseRequest')) {
      final baseName =
          rawName.substring(0, rawName.length - 'BaseRequest'.length);

      context.logger.info(
          "Detected 'BaseRequest' suffix in '$rawName'; resolving to '$baseName'.");

      targetComponents.add(baseName);
    } else {
      targetComponents.add(rawName);
    }
  }

  if (!path.startsWith('http')) {
    path = 'https://$path';
  }

  final uri = Uri.parse(path);
  final progress = context.logger.progress('Fetching schema from $uri...');

  Map<String, dynamic> schemaJson;
  try {
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      progress.fail('Failed to fetch schema. Status: ${response.statusCode}');
      return;
    }
    schemaJson = jsonDecode(response.body) as Map<String, dynamic>;
    progress.complete('Schema downloaded!');
  } catch (e) {
    progress.fail('Error fetching schema: $e');
    return;
  }

  final components = schemaJson['components'] as Map<String, dynamic>?;
  final schemas = components?['schemas'] as Map<String, dynamic>?;

  if (schemas == null) {
    context.logger.warn('No components/schemas found in schema.');
    context.vars['models'] = [];
    return;
  }

  final models = <Map<String, dynamic>>[];
  final processedModels = <String>{};
  final queue = <String>[];

  if (targetComponents.isNotEmpty) {
    for (final target in targetComponents) {
      if (schemas.containsKey(target)) {
        queue.add(target);
      } else {
        context.logger.warn('Target component "$target" not found in schemas.');
      }
    }
    if (queue.isEmpty) {
      context.logger.err('No valid target components found.');
      return;
    }
  } else {
    queue.addAll(schemas.keys);
  }

  context.logger.info('Starting dependency analysis...');

  while (queue.isNotEmpty) {
    final modelName = queue.removeAt(0);

    if (processedModels.contains(modelName)) continue;
    processedModels.add(modelName);

    if (!schemas.containsKey(modelName)) continue;

    final schemaBody = schemas[modelName] as Map<String, dynamic>;
    final properties = schemaBody['properties'] as Map<String, dynamic>? ?? {};
    final requiredFields =
        (schemaBody['required'] as List?)?.map((e) => e.toString()).toSet() ??
            {};

    final fields = <Map<String, dynamic>>[];
    bool usesCollection = false;

    for (final entry in properties.entries) {
      final propName = entry.key;
      final propData = entry.value as Map<String, dynamic>;
      bool isCustom = false;
      bool isList = false;

      String dartType = 'dynamic';
      String innerType = dartType;

      if (propData.containsKey(r'$ref')) {
        final refName = _getRefName(propData[r'$ref']);
        dartType = refName;
        isCustom = true;
        innerType = refName;

        _addToQueue(refName, processedModels, queue, context);
      } else if (propData['type'] == 'array') {
        isList = true;
        usesCollection = true;
        final items = propData['items'] as Map<String, dynamic>?;
        String itemType = 'dynamic';

        if (items != null) {
          if (items.containsKey(r'$ref')) {
            final refName = _getRefName(items[r'$ref']);
            itemType = refName;
            isCustom = true;

            _addToQueue(refName, processedModels, queue, context);
          } else {
            itemType = _mapPrimitiveType(
                items['type'] as String?, items['format'] as String?);
          }
        }
        dartType = 'List<$itemType>';
        innerType = itemType;
      } else {
        dartType = _mapPrimitiveType(
            propData['type'] as String?, propData['format'] as String?);
      }

      bool isNullable = !requiredFields.contains(propName);

      if (isNullable) {
        isNullable = (propData['nullable'] == true);
      }

      if (isNullable && dartType != 'dynamic') {
        dartType += '?';
      }

      fields.add({
        'originalName': propName,
        'name': propName.camelCase,
        'type': dartType,
        'innerType': innerType,
        'isRequired': !isNullable,
        'isCustom': isCustom,
        'isList': isList,
      });
    }

    models.add({
      'name': modelName,
      'fileName': modelName.snakeCase,
      'fields': fields,
      'usesCollection': usesCollection,
    });
  }

  context.vars['models'] = models;
  context.logger.success(
      'Successfully parsed ${models.length} models using iterative logic.');
}

String _getRefName(dynamic ref) {
  if (ref is! String) return 'dynamic';
  return ref.split('/').last;
}

void _addToQueue(String name, Set<String> processed, List<String> queue,
    HookContext context) {
  const blackList = ['Value', 'Any', 'ListValue', 'NullValue'];
  if (blackList.contains(name)) {
    context.logger.info('Skipping $name because it is a protobuf type');
    return;
  }

  if (!processed.contains(name) && !queue.contains(name)) {
    queue.add(name);
  }
}

String _mapPrimitiveType(String? type, String? format) {
  if (type == null) return 'dynamic';
  switch (type) {
    case 'integer':
      return (format == 'int64') ? 'int' : 'int';
    case 'number':
      return (format == 'float' || format == 'double') ? 'double' : 'num';
    case 'string':
      if (format == 'date-time' || format == 'date') return 'DateTime';
      return 'String';
    case 'boolean':
      return 'bool';
    default:
      return type;
  }
}
