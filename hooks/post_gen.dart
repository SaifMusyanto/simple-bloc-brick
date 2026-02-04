import 'dart:io';
import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final progress = context.logger.progress('Running post-generation hooks...');

  try {
    // Run dart format
    await Process.run('dart', ['format', '.']);
    
    // Run dart fix --apply
    await Process.run('dart', ['fix', '--apply']);

    progress.complete('Post-generation hooks completed!');
  } catch (e) {
    progress.fail('Post-generation hooks failed: $e');
  }
}
