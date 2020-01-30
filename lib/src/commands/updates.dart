import 'package:args/command_runner.dart';
import 'package:yaml/yaml.dart';

import '../api.dart';
import '../pubspec.dart';

class UpdatesCommand extends Command {
  @override
  final String name = 'updates';

  @override
  final List<String> aliases = ['u'];

  @override
  final String description =
      'Checks pub.dev for packages in your pubspec that have updated versions';

  @override
  final String invocation = 'pubx updates';

  Future<void> run() async {
    final pub = findPubspec();

    // Load and parse pubspec.yaml
    final pubContents = await pub.readAsStringSync();
    final pubYaml = loadYaml(
      pubContents,
      sourceUrl: pub.uri,
    ) as YamlMap;

    final YamlMap dependencies = pubYaml['dependencies'];

    for (final packageName in dependencies.keys) {
      if (!dependencies[packageName].toString().startsWith('{sdk:')) {
        try {
          final pkgInfo = await fetchPackageInfo(packageName);
          print(
              '${pkgInfo.name} \t [${dependencies[packageName]}] \t latest: ${pkgInfo.version}');
        } catch (e) {
          //NA
        }
      }
    }
  }
}
