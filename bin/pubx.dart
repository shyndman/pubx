import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pubx/pubx.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('pubx', 'The missing pub commands.')
    ..addCommand(AddCommand())
    ..addCommand(SearchCommand())
    ..addCommand(ViewCommand())
    ..addCommand(UpdatesCommand())
    ..addCommand(WhichCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  } on FileNotFoundException {
    print('No pubspec.yaml file found, please run this command in the root '
        'folder of a Dart project');
    exit(64);
  } on PackageNotFoundException catch (e) {
    print('${e.packageName} not found');
    exit(64);
  } catch (e) {
    stderr.writeln('An unknown error has occured.');
    stderr.writeln(runner.usage);
    rethrow;
  }
}
