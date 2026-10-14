import 'dart:convert';
import 'dart:io';

class SemVer implements Comparable<SemVer> {
  final int major;
  final int minor;
  final int patch;
  final String? preRelease;

  SemVer(this.major, this.minor, this.patch, [this.preRelease]);

  factory SemVer.parse(String text) {
    final cleaned = text.trim().replaceFirst(RegExp(r'^v'), '');
    final preReleaseParts = cleaned.split('-');
    final mainParts = preReleaseParts[0].split('+')[0].split('.');
    final major = int.tryParse(mainParts.isNotEmpty ? mainParts[0] : '0') ?? 0;
    final minor = int.tryParse(mainParts.length > 1 ? mainParts[1] : '0') ?? 0;
    final patch = int.tryParse(mainParts.length > 2 ? mainParts[2] : '0') ?? 0;
    final pre = preReleaseParts.length > 1 ? preReleaseParts.sublist(1).join('-') : null;
    return SemVer(major, minor, patch, pre);
  }

  SemVer bump(String type) {
    switch (type.toLowerCase()) {
      case 'major':
        return SemVer(major + 1, 0, 0);
      case 'minor':
        return SemVer(major, minor + 1, 0);
      case 'patch':
      default:
        return SemVer(major, minor, patch + 1);
    }
  }

  @override
  int compareTo(SemVer other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    return 0;
  }

  @override
  String toString() => '$major.$minor.$patch${preRelease != null ? '-$preRelease' : ''}';
}

Future<SemVer?> fetchLiveVersion(String packageName) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse('https://pub.dev/api/packages/$packageName');
    final req = await client.getUrl(uri);
    final resp = await req.close();
    if (resp.statusCode == 200) {
      final body = await resp.transform(utf8.decoder).join();
      final data = jsonDecode(body) as Map<String, dynamic>;
      final latest = data['latest'];
      if (latest is Map<String, dynamic> && latest['version'] != null) {
        return SemVer.parse(latest['version'] as String);
      }
    }
    return null;
  } catch (e) {
    print('Warning: Failed to fetch live version from pub.dev: $e');
    return null;
  } finally {
    client.close();
  }
}

void main(List<String> args) async {
  String? customVersionStr;
  String bumpType = 'patch';
  String pubspecPath = 'pubspec.yaml';
  String changelogPath = 'CHANGELOG.md';

  for (final arg in args) {
    if (arg.startsWith('--custom-version=')) {
      final val = arg.substring('--custom-version='.length).trim();
      if (val.isNotEmpty) customVersionStr = val;
    } else if (arg.startsWith('--bump-type=')) {
      final val = arg.substring('--bump-type='.length).trim();
      if (val.isNotEmpty) bumpType = val;
    } else if (arg.startsWith('--pubspec=')) {
      pubspecPath = arg.substring('--pubspec='.length).trim();
    }
  }

  final pubspecFile = File(pubspecPath);
  if (!pubspecFile.existsSync()) {
    stderr.writeln('Error: $pubspecPath not found!');
    exit(1);
  }

  final pubspecContent = pubspecFile.readAsStringSync();
  final nameMatch = RegExp(r'^name:\s*([^\s#]+)', multiLine: true).firstMatch(pubspecContent);
  if (nameMatch == null) {
    stderr.writeln('Error: Could not find "name:" in $pubspecPath');
    exit(1);
  }
  final packageName = nameMatch.group(1)!;

  final versionMatch = RegExp(r'^version:\s*([^\s#]+)', multiLine: true).firstMatch(pubspecContent);
  if (versionMatch == null) {
    stderr.writeln('Error: Could not find "version:" in $pubspecPath');
    exit(1);
  }
  final currentLocalVersionStr = versionMatch.group(1)!;
  final localVersion = SemVer.parse(currentLocalVersionStr);

  print('Package name: $packageName');
  print('Local version in pubspec.yaml: $localVersion');

  // Fetch live pub.dev version
  final liveVersion = await fetchLiveVersion(packageName);
  print('Live version on pub.dev: ${liveVersion ?? 'None (or package not found)'}');

  SemVer targetVersion;
  String decisionReason;

  if (customVersionStr != null && customVersionStr.isNotEmpty) {
    targetVersion = SemVer.parse(customVersionStr);
    decisionReason = 'Custom version specified manually: $targetVersion';
  } else if (liveVersion != null) {
    if (localVersion.compareTo(liveVersion) > 0) {
      // Local version is already higher than live version (e.g. user manually bumped to 1.0.0 in code)
      targetVersion = localVersion;
      decisionReason =
          'Local version ($localVersion) is already higher than live version ($liveVersion). Keeping $localVersion.';
    } else {
      // Local version is equal or less than live version -> Auto-increment
      targetVersion = liveVersion.bump(bumpType);
      decisionReason =
          'Auto-incrementing live version ($liveVersion) with bump type "$bumpType" -> $targetVersion.';
    }
  } else {
    // If not live yet, use local version
    targetVersion = localVersion;
    decisionReason = 'Package not found on pub.dev. Using local version $localVersion.';
  }

  print('Decision: $decisionReason');
  print('Target version to release: $targetVersion');

  final versionChanged = targetVersion.toString() != currentLocalVersionStr;

  if (versionChanged) {
    // Update pubspec.yaml
    final updatedPubspec = pubspecContent.replaceFirst(
      RegExp(r'^version:\s*[^\s#]+', multiLine: true),
      'version: $targetVersion',
    );
    pubspecFile.writeAsStringSync(updatedPubspec);
    print('Updated $pubspecPath with version: $targetVersion');

    // Update CHANGELOG.md if present
    final changelogFile = File(changelogPath);
    if (changelogFile.existsSync()) {
      final changelogContent = changelogFile.readAsStringSync();
      final headerPattern = RegExp('^##\\s*v?${RegExp.escape(targetVersion.toString())}', multiLine: true);
      if (!headerPattern.hasMatch(changelogContent)) {
        final newEntry = '## $targetVersion\n\n* Automated release of version $targetVersion.\n\n';
        changelogFile.writeAsStringSync('$newEntry$changelogContent');
        print('Prepended new version entry to $changelogPath');
      }
    }
  } else {
    print('No changes needed in $pubspecPath (version is already $targetVersion).');
  }

  // Export to GitHub Actions environment if running in CI
  final githubEnv = Platform.environment['GITHUB_ENV'];
  if (githubEnv != null) {
    final envFile = File(githubEnv);
    envFile.writeAsStringSync(
      'TARGET_VERSION=$targetVersion\nVERSION_CHANGED=$versionChanged\n',
      mode: FileMode.append,
    );
  }

  final githubOutput = Platform.environment['GITHUB_OUTPUT'];
  if (githubOutput != null) {
    final outputFile = File(githubOutput);
    outputFile.writeAsStringSync(
      'target_version=$targetVersion\nversion_changed=$versionChanged\n',
      mode: FileMode.append,
    );
  }
}
