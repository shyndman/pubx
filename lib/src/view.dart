import 'dart:io';

import 'package:args/command_runner.dart';

import 'api.dart';

class ViewCommand extends Command {
  @override
  final String name = 'view';

  @override
  final List<String> aliases = ['info', 'show', 'v'];

  @override
  final String description = 'View information about a pub.dev package';

  @override
  final String invocation = 'pubx info {packageName}';

  Future<void> run() async {
    try {
      PackageInfo package = await view(argResults.rest.join(' '));
      _printPackage(package);
    } on PackageNotFoundException catch (e) {
      stderr.writeln('${e.packageName} not found');
    }
  }

  void _printPackage(PackageInfo package) {
    print('${package.name}: ${package.version}');
    print(package.description);
    print(package.url);
  }
}
