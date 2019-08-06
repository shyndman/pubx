import 'dart:io';

import 'package:path/path.dart';
import 'package:quiver/iterables.dart';

import '../except.dart';

File findFileInAncestorDirectories(String fileName) {
  final directories = concat([
    [Directory.current.path],
    iterateAncestorDirectories(Directory.current.path),
  ]);

  return directories
      // Convert to File objects
      .map((dir) => File(join(dir, fileName)))
      // and check for existence
      .firstWhere(
        (pubspecFile) => pubspecFile.existsSync(),
        orElse: () => throw FileNotFoundException('$fileName not found'),
      );
}

/// Returns an iterable of [path]'s directories, starting from `dirname(path)`
/// and ending at the root path (`./` or `/`).
Iterable<String> iterateAncestorDirectories(String path) sync* {
  String dirPath = dirname(path), lastDirPath = path;
  // When we hit the the root, dirname() is consistent in its return value
  while (dirPath != lastDirPath) {
    yield dirPath;
    lastDirPath = dirPath;
    dirPath = dirname(dirPath);
  }
}
