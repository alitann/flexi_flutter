import 'dart:convert';
import 'dart:io';

import 'package:build/build.dart';
import 'package:logging/logging.dart';
import 'package:yaml/yaml.dart';

final log = Logger('LocalizationGenerator');

Builder localizationGeneratorFactory(BuilderOptions options) =>
    LocalizationGenerator();

class LocalizationGenerator extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final config = _loadConfig(buildStep);
    final assetsPath = config['assets_path'] ?? 'assets/lang';
    final outputPath = config['output_path'] ?? 'lib/generated';

    _printInfo('🚀 [Localization Generator] Running from user project...');
    _printInfo('📂 Language files directory: $assetsPath');
    _printInfo('📌 Output directory: $outputPath');

    final buffer =
        StringBuffer()
          ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND')
          ..writeln(
            "import 'package:flexi_localization/flexi_localization.dart';\n",
          )
          ..writeln('class Translations {');

    final getterBuffer =
        StringBuffer()
          ..writeln('extension TranslationKeys on LocalizationService {');

    final dir = Directory(assetsPath as String);
    if (!dir.existsSync()) {
      _printWarning(
        '⚠️ Warning: Language files directory '
        '`$assetsPath` does not exist. Skipping...',
      );
      return;
    }

    final files = dir.listSync().where((file) => file.path.endsWith('.json'));
    final processedKeys = <String>{};

    for (final file in files) {
      final fileContent = File(file.path).readAsStringSync().trim();
      if (fileContent.isEmpty) {
        _printWarning(
          '⚠️ Warning: JSON file `${file.path}` is empty. Skipping...',
        );
        continue;
      }

      try {
        final jsonContent = json.decode(fileContent) as Map<String, dynamic>;
        _printInfo('📜 Processing JSON file: ${file.path}');
        _printSuccess('✅ JSON Content:\n${_formatJson(jsonContent)}');

        jsonContent.forEach((key, value) {
          final variableName = _toLowerCamelCase(key);
          if (processedKeys.contains(variableName)) return;

          buffer.writeln("  static const String $variableName = '$key';");
          getterBuffer.writeln(
            '  String get $variableName '
            '=> translate(Translations.$variableName);',
          );
          processedKeys.add(variableName);
        });
      } catch (e) {
        _printError(
          '❌ Error: Invalid JSON format in '
          '`${file.path}`. Skipping... Error: $e',
        );
        continue;
      }
    }

    buffer.writeln('}');
    getterBuffer.writeln('}');

    final outputDir = Directory(outputPath as String);
    final outputFile = File('$outputPath/translations.g.dart');

    // If outputPath exists as a file, delete it
    if (outputFile.existsSync()) {
      outputFile.deleteSync();
    }

    // If outputPath is not a directory, create it
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    // ✅ Generate and write the output file
    outputFile.writeAsStringSync('$buffer\n$getterBuffer');

    _printSuccess(
      '✅ [Localization Generator] Successfully created `translations.g.dart`!',
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    '.json': ['.g.dart'],
  };

  /// Reads `pubspec.yaml` and extracts flexi_localization settings
  Map<String, dynamic> _loadConfig(BuildStep buildStep) {
    try {
      final projectRoot = Directory.current.path;
      final pubspecPath = '$projectRoot/pubspec.yaml';

      _printInfo('🔍 Debug: Looking for pubspec.yaml at -> $pubspecPath');

      final file = File(pubspecPath);
      if (!file.existsSync()) {
        _printWarning(
          '⚠️ Warning: pubspec.yaml not found. Using default values.',
        );
        return {};
      }

      final yamlString = file.readAsStringSync();
      final yamlMap = loadYaml(yamlString) as Map;

      return yamlMap['flexi_localization'] != null
          ? Map<String, dynamic>.from(yamlMap['flexi_localization'] as YamlMap)
          : {};
    } catch (e) {
      _printError(
        '❌ Error: Could not read pubspec.yaml. Using default values. Error: $e',
      );
      return {};
    }
  }

  /// Converts snake_case keys into lowerCamelCase
  String _toLowerCamelCase(String key) {
    final words = key.split('_');
    if (words.isEmpty) return key;

    final firstWord = words.first;
    final restWords = words
        .skip(1)
        .map((word) => word[0].toUpperCase() + word.substring(1));

    return firstWord + restWords.join();
  }

  /// Formats JSON for better readability
  String _formatJson(Map<String, dynamic> jsonContent) {
    return const JsonEncoder.withIndent('  ').convert(jsonContent);
  }

  /// 🔵 **INFO Message Print**
  void _printInfo(String message) {
    print('\x1B[34m$message\x1B[0m'); // Blue color
  }

  /// 🟡 **WARNING Message Print**
  void _printWarning(String message) {
    print('\x1B[33m$message\x1B[0m'); // Yellow color
  }

  /// 🔴 **ERROR Message Print**
  void _printError(String message) {
    print('\x1B[31m$message\x1B[0m'); // Red color
  }

  /// 🟢 **SUCCESS Message Print**
  void _printSuccess(String message) {
    print('\x1B[32m$message\x1B[0m'); // Green color
  }
}
