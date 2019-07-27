import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pubx/pubx.dart';

void main(List<String> arguments) async {
  final runner = CommandRunner('pubx', 'The missing pub commands.')
    ..addCommand(SearchCommand())
    ..addCommand(ViewCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e);
    exit(64);
  } catch(e) {
    print('An unknown error has occured.');
    print(runner.usage);
    rethrow;
  }
}
