import 'package:args/command_runner.dart';

import '../api.dart';

class SearchCommand extends Command {
  @override
  final String name = 'search';

  @override
  final List<String> aliases = ['s', 'se', 'find'];

  @override
  final String description = 'Searches pub.dev for packages';

  @override
  final String invocation = 'pubx search {query}';

  Future<void> run() async {
    final result = await searchPackages(argResults.rest.join(' '));
    for (final package in result.packages) {
      print(package.name);
    }
  }
}
