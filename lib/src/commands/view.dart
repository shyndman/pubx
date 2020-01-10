import 'dart:io';

import 'package:args/command_runner.dart';

import '../api.dart';
import '../except.dart';

class ViewCommand extends Command {
  ViewCommand() {
    argParser.addFlag(
      'version-only',
      help: 'Print only the version(s) to standard out',
    );
    argParser.addFlag(
      'versions',
      help: 'Display all package versions',
    );
  }

  @override
  final String name = 'view';

  @override
  final List<String> aliases = ['info', 'show', 'v'];

  @override
  final String description = 'View information about a pub.dev package';

  @override
  final String invocation = 'pubx info {packageName}';

  @override
  Future<void> run() async {
    final packageName = argResults.rest.join(' ');
    final printVersions = argResults['versions'] as bool;
    final printOnlyVersion = argResults['version-only'] as bool;

    try {
      final package =
          await fetchPackageInfo(packageName, fullParse: printVersions);
      _printPackage(
        package,
        printAllVersions: printVersions,
        printOnlyVersion: printOnlyVersion,
      );
    } on PackageNotFoundException catch (e) {
      stderr.writeln('${e.packageName} not found');
    }
  }

  void _printPackage(
    PackageInfo package, {
    bool printAllVersions,
    bool printOnlyVersion,
  }) {
    if (printOnlyVersion) {
      if (printAllVersions) {
        _printVersions(package);
      } else {
        print(package.version);
      }
    } else {
      print('${package.name}: ${package.version}');
      if (package.currentPubspec.author != null) {
        print('Author: ${package.currentPubspec.author}');
      } else if (package.currentPubspec.authors != null) {
        print('Authors: ${package.currentPubspec.authors.join(", ")}');
      }
      print(package.description);
      print(package.url);
      if (printAllVersions) {
        print('\nAll versions:');
        _printVersions(package);
      }
    }
  }

  void _printVersions(PackageInfo package) {
    print(package.versionedPubspecs
        .map((pubspec) => pubspec.version)
        .toList()
        .reversed
        .join('\n'));
  }
}
