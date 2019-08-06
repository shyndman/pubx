import 'dart:io';

import 'except.dart';
import 'util/io.dart';

const pubspecFileName = 'pubspec.yaml';

/// Attempts to find a `pubspec.yaml` file in the current directory, and the
/// current directory's ancestry. If found, a [File] pointing to the
/// `pubspec.yaml` will be returned. If not found, a [FileNotFoundException]
/// will be thrown.
File findPubspec() => findFileInAncestorDirectories(pubspecFileName);
