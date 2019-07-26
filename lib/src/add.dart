import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';

import 'api.dart';

class AddCommand extends Command {
  AddCommand() {
    argParser.addFlag(
      'dev',
      help: 'Add dev dependency',
    );
    argParser.addFlag(
      'lock',
      help: 'Lock the package version',
    );
  }

  @override
  final String name = 'add';

  @override
  final List<String> aliases = ['a'];

  @override
  final String description = 'Add a package to your pubspec.yaml file';

  @override
  final String invocation = 'pubx add {packageName}';

  Future<void> run() async {
    final packageName = argResults.rest.join(' ');
    final devDependency = argResults['dev'] as bool;
    final lockVersion = argResults['lock'] as bool;

    final pub = _getPubspec();
    if (pub == null) {
      throw FileNotFoundException('No pubspec.yaml file found');
    }

    try {
      // Check if current directory has a pubspec.yaml file
      PackageInfo package = await fetchPackageInfo(packageName);

      // Read file
      var contents = StringBuffer();
      var contentStream = pub.openRead();

      contentStream.transform(Utf8Decoder()).transform(LineSplitter()).listen(
        (String line) {
          var match = devDependency ? 'dev_dependencies:' : 'dependencies:';
          if (line == match) {
            line += '\n  ${package.name}: '
                '${lockVersion ? '' : '^'}${package.version}';
          }
          contents.write(line + '\n');
        }, // Add line to our StringBuffer object
        onDone: () => pub.writeAsStringSync(contents.toString()),
      );
    } catch (e) {
      print('There was a problem adding the dependency to your project');
      rethrow;
    }
  }

  File _getPubspec() {
    Directory current = Directory.current;
    final file = File(join(current.path, 'pubspec.yaml'));
    if (file.existsSync()) {
      return file;
    }
    return null;
  }
}

class FileNotFoundException implements Exception {
  FileNotFoundException(this.message);
  final String message;
  String toString() => 'FileNotFoundException: $message';
}
