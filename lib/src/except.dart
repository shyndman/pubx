class FileNotFoundException implements Exception {
  FileNotFoundException(this.message);
  final String message;

  @override
  String toString() => 'FileNotFoundException: $message';
}

class PackageNotFoundException {
  PackageNotFoundException(this.packageName);
  final String packageName;

  @override
  String toString() => 'PackageNotFoundException: $packageName not found';
}
