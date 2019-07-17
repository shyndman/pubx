import 'dart:io';

import 'package:args/command_runner.dart';

import 'api.dart';

class ViewCommand extends Command {
  ViewCommand() {
    argParser.addFlag('versions', help: 'Display package versions');
  }

  @override
  final String name = 'view';

  @override
  final List<String> aliases = ['info', 'show', 'v'];

  @override
  final String description = 'View information about a pub.dev package';

  @override
  final String invocation = 'pubx info {packageName}';

  Future<void> run() async {
    final packageName = argResults.rest.join(' ');
    bool printVersions = argResults['versions'];

    try {
      PackageInfo package = await view(packageName, fullParse: printVersions);
      _printPackage(package, printVersions: printVersions);
    } on PackageNotFoundException catch (e) {
      stderr.writeln('${e.packageName} not found');
    }
  }

  void _printPackage(
    PackageInfo package, {
    bool printVersions,
  }) {
    print('${package.name}: ${package.version}');
    print(package.description);
    print(package.url);
    if (printVersions) {
      print('\nAll versions:');
      print(package.versionedPubspecs
          .map((pubspec) => pubspec.version)
          .toList()
          .reversed
          .join('\n'));
    }
  }
}
