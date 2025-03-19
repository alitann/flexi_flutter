// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';
import 'package:build/build.dart';

/// Builder Factory Tanımı
Builder localizationGeneratorFactory(BuilderOptions options) =>
    LocalizationGenerator();

class LocalizationGenerator extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final inputPath = "assets/lang/";
    final outputPath = "lib/gen/translations.g.dart"; // Tekrar .g.dart yaptık

    print("🚀 [Localization Generator] Çalışıyor...");

    final buffer = StringBuffer();
    buffer.writeln("// GENERATED CODE - DO NOT MODIFY BY HAND");
    buffer.writeln(
      "import 'package:flexi_localization/src/localization_service.dart';\n",
    );
    buffer.writeln("class Translations {");

    final getterBuffer = StringBuffer();
    getterBuffer.writeln("extension TranslationKeys on LocalizationService {");

    final dir = Directory(inputPath);
    if (!dir.existsSync()) {
      print("❌ Error: $inputPath does not exist.");
      return;
    }

    final files = dir.listSync().where((file) => file.path.endsWith('.json'));
    final Set<String> processedKeys = {};

    for (var file in files) {
      final fileContent = File(file.path).readAsStringSync().trim();

      if (fileContent.isEmpty) {
        print("⚠️ Warning: ${file.path} is empty. Skipping...");
        continue;
      }

      try {
        final jsonContent = json.decode(fileContent) as Map<String, dynamic>;

        jsonContent.forEach((key, value) {
          final variableName = _toLowerCamelCase(key);
          if (processedKeys.contains(variableName)) return;

          buffer.writeln("  static const String $variableName = '$key';");
          getterBuffer.writeln(
            "  String get $variableName => translate(Translations.$variableName);",
          );
          processedKeys.add(variableName);
        });
      } catch (e) {
        print("❌ Error: Invalid JSON format in ${file.path}. Skipping...");
        continue;
      }
    }

    buffer.writeln("}");
    getterBuffer.writeln("}");

    // Çıktıyı oluştur ve dosyayı yaz
    final outputFile = File(outputPath);
    outputFile.createSync(recursive: true);
    outputFile.writeAsStringSync("$buffer\n\n$getterBuffer");

    print(
      "✅ [Localization Generator] translations.g.dart dosyası oluşturuldu!",
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    ".json": [".g.dart"], // Tekrar .g.dart yaptık
  };

  String _toLowerCamelCase(String key) {
    final words = key.split('_');
    if (words.isEmpty) return key;

    final firstWord = words.first;
    final restWords = words
        .skip(1)
        .map((word) => word[0].toUpperCase() + word.substring(1));

    return firstWord + restWords.join();
  }
}
