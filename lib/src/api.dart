import 'dart:convert';

import 'package:http/http.dart' as http;

import 'except.dart';

const pubUrlBase = 'https://pub.dartlang.org';
const searchUrl = '$pubUrlBase/api/search';
const viewUrl = '$pubUrlBase/api/packages';

Future<SearchResult> searchPackages(String query) async {
  final searchJson = jsonDecode(await http.read('$searchUrl?q=$query')) as Map;
  final packagesJson = searchJson['packages'] as List<dynamic>;
  final packageInfos = await Future.wait(packagesJson
      .where((json) => !json['package'].toString().startsWith('dart:'))
      .map((json) => fetchPackageInfo(json['package'])));

  return SearchResult(packages: packageInfos);
}

Future<PackageInfo> fetchPackageInfo(
  String packageName, {
  bool fullParse = false,
}) async {
  final response = await http.get('$viewUrl/$packageName');

  // Dumb error handling
  if (response.statusCode == 404) {
    throw PackageNotFoundException(packageName);
  } else if (response.statusCode < 200 || response.statusCode > 299) {
    throw http.ClientException('response.statusCode: ${response.statusCode}');
  }

  final packageJson = jsonDecode(response.body);
  return PackageInfo.parse(packageJson, parseAllVersions: fullParse);
}

class SearchResult {
  SearchResult({this.packages});
  final List<PackageInfo> packages;
}

class PackageInfo {
  PackageInfo(this.name);

  factory PackageInfo.parse(
    Map<String, dynamic> packageJson, {
    bool parseAllVersions = false,
  }) {
    final package = PackageInfo(packageJson['name']);

    final Iterable<dynamic> pubspecsJson = parseAllVersions
        ? packageJson['versions'].map((versionJson) => versionJson['pubspec'])
        : [packageJson['latest']['pubspec']];
    package.versionedPubspecs.addAll(
      pubspecsJson.map((json) => VersionedPubspec.parse(json)),
    );

    return package;
  }

  final String name;
  final List<VersionedPubspec> versionedPubspecs = [];

  String get version => currentPubspec.version;
  List<String> get authors => currentPubspec.authors;
  String get author => currentPubspec.author;
  String get description => currentPubspec.description;
  String get url => 'https://pub.dev/packages/$name';
  VersionedPubspec get currentPubspec => versionedPubspecs.last;
}

class VersionedPubspec {
  VersionedPubspec({this.version, this.author, this.authors, this.description});
  factory VersionedPubspec.parse(Map<String, dynamic> json) {
    return VersionedPubspec(
        version: json['version'],
        authors: (json['authors'] as List<dynamic>)?.cast<String>(),
        author: json['author'],
        description: json['description']);
  }

  final String version;
  final String author;
  final List<String> authors;
  final String description;
}
