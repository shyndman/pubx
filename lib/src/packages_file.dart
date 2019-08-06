// Utilities related to handling .packages files.

import 'dart:convert';
import 'dart:io';

import 'package:quiver/strings.dart';

import 'util/io.dart';

const packagesFileName = '.packages';

/// Attempts to find a `.packages` file in the current directory, and the
/// current directory's ancestry.
///
/// If found, a [PackagesFile] representation of the `.packages` will be
/// returned. If not found, a [FileNotFoundException] will be thrown.
PackagesFile findPackagesFile() {
  final file = findFileInAncestorDirectories(packagesFileName);
  return PackagesFile.fromFile(file);
}

/// In-memory representation of a `.packages` file.
class PackagesFile {
  PackagesFile(this.path, Map<String, Uri> packageMappings)
      : assert(packageMappings != null),
        _packageMappings = packageMappings;

  factory PackagesFile.fromFile(File file) {
    final fileContents = file.readAsStringSync();
    final packageLines = LineSplitter.split(fileContents).where(
      (line) => isNotEmpty(line) && !line.startsWith('#'),
    );

    final entries = packageLines.map((line) {
      final separatorIndex = line.indexOf(':');
      return MapEntry(
        line.substring(0, separatorIndex),
        Uri.parse(line.substring(separatorIndex + 1)),
      );
    });

    return PackagesFile(file.path, Map.fromEntries(entries));
  }

  final String path;
  final Map<String, Uri> _packageMappings;

  /// Returns `true` if this file contains a mapping for [packageName], or
  /// `false` otherwise.
  bool containsPackage(String packageName) =>
      _packageMappings.containsKey(packageName);

  /// Returns the [Uri] of the package named [packageName], or `null` if not
  /// found.
  Uri operator [](String packageName) => _packageMappings[packageName];
}
