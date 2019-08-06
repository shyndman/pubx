class FileNotFoundException implements Exception {
  FileNotFoundException(this.message);
  final String message;
  String toString() => 'FileNotFoundException: $message';
}
