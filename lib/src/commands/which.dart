import 'package:args/command_runner.dart';
import 'package:path/path.dart';
import 'package:pubx/src/except.dart';
import 'package:pubx/src/packages_file.dart';

class WhichCommand extends Command {
  @override
  final String name = 'which';

  @override
  final List<String> aliases = ['w'];

  @override
  final String description = 'Locate a dependency';

  @override
  final String invocation = 'pubx which {package-name}';

  @override
  Future<void> run() async {
    final packagesFile = findPackagesFile();
    final packageUris = <Uri>[];

    // Collect the package URIs, throwing if not found.
    for (final packageName in argResults.rest) {
      if (packagesFile.containsPackage(packageName)) {
        packageUris.add(packagesFile[packageName]);
      } else {
        throw PackageNotFoundException(packageName);
      }
    }

    // Print each of the URI paths
    for (final uri in packageUris) {
      // dirname to strip off the trailing `lib/`
      print(dirname(uri.path));
    }
  }
}
