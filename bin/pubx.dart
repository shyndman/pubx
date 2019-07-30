import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:pubx/pubx.dart';
import 'package:pubx/src/add.dart';
import 'package:pubx/src/api.dart';


main(List<String> arguments) async {
  final runner = CommandRunner("pubx", "The missing pub commands.")
    ..addCommand(AddCommand())
    ..addCommand(SearchCommand())
    ..addCommand(ViewCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    print(e);
    exit(64);
  } on FileNotFoundException catch (e) {
    print("No pubspec.yaml file found, please run this command in the root folder of a Dart project");
    exit(64);
  } on PackageNotFoundException catch (e) {
    print('${e.packageName} not found');
    exit(64);
  } catch(e) {
    print("An unknown error has occured.");
    print(runner.usage);
    rethrow;
  }
}
