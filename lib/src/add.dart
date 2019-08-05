import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

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
      final package = await fetchPackageInfo(packageName);

      // Load and parse pubspec.yaml
      final pubContents = pub.readAsStringSync();
      final pubYaml = loadYaml(
        pub.readAsStringSync(),
        sourceUrl: pub.uri,
      ) as YamlMap;

      // TODO(https://github.com/shyndman/pubx/issues/7): Add the section if
      // missing.
      final dependenciesKey =
          devDependency ? 'dev_dependencies' : 'dependencies';
      final dependenciesMap = pubYaml.nodes[dependenciesKey] as YamlMap;

      final versionConstraints = '${lockVersion ? '' : '^'}${package.version}';
      String newPubContents;
      // If the dependency is already present, replace its constraints with
      // the latest.
      if (dependenciesMap.containsKey(package.name)) {
        final currentVersionNode =
            dependenciesMap.nodes[package.name] as YamlScalar;
        final span = currentVersionNode.span;

        // If a dependency entry has been defined without an explicit version,
        // (eg. `build_runner:`) the node's span sits on the entry's :
        // character. This requires some special handling to avoid overwriting.
        if (currentVersionNode.value == null) {
          newPubContents = pubContents.replaceRange(
            span.start.offset + 1,
            span.end.offset + 1,
            ' $versionConstraints',
          );
        } else {
          newPubContents = pubContents.replaceRange(
            span.start.offset,
            span.end.offset,
            versionConstraints,
          );
        }
      }
      // Otherwise we prepend the new dependency entry to the relevant map.
      else {
        final span = dependenciesMap.span;
        // TODO(https://github.com/shyndman/pubx/issues/8): Attempt to add
        // package in the correct order if the list is already sorted.
        newPubContents = pubContents.replaceRange(span.start.offset,
            span.start.offset, '${package.name}: $versionConstraints\n  ');
      }

      pub.writeAsStringSync(newPubContents);

      // TODO(https://github.com/shyndman/pubx/issues/9): Fetch packages
      // automatically.

      stderr.writeln('+ ${package.name}: $versionConstraints');
    } catch (e) {
      print('There was a problem adding the dependency to your project');
      rethrow;
    }
  }

  File _getPubspec() {
    final current = Directory.current;
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
