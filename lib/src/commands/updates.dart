import 'package:args/command_runner.dart';
import 'package:dolumns/dolumns.dart';
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

    final packageNames = dependencies.keys.cast<String>();

    final data = <List<String>>[];
    for (final packageName in packageNames) {
      bool isSDK = false;
      String pkgType;
      if (dependencies[packageName] is YamlMap) {
        isSDK = _isSdkPackage(dependencies[packageName]);
        pkgType = _packageType(dependencies[packageName]);
      }
      if (!isSDK) {
        try {
          final pkgInfo = await fetchPackageInfo(packageName);

          String currentVersion = dependencies[packageName].toString();
          currentVersion = pkgType ?? currentVersion;
          data.add(
              [pkgInfo.name, currentVersion, 'latest: ${pkgInfo.version}']);
        } catch (e) {
          print(
              'There was a problem fetching dependency information for your project');
        }
      }
    }
    print(dolumnify(data));
  }

  bool _isSdkPackage(YamlMap package) => package['sdk'] != null;

  String _packageType(YamlMap package) {
    if (package['path'] != null) {
      return 'path pkg';
    }
    if (package['git'] != null) {
      return 'git pkg';
    }
    return 'unknown';
  }
}
