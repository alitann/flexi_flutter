import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  factory LocalizationService() => _instance;
  LocalizationService._internal();
  static final LocalizationService _instance = LocalizationService._internal();

  Map<String, dynamic> _localizedStrings = {};
  final Map<String, Map<String, dynamic>> _cache =
      {}; // Önceden yüklenen dilleri saklar

  /// Sadece ihtiyaç duyulan dili yükler (Lazy Loading)
  Future<void> loadLanguage({
    required String languageCode,
    required String assetsPath,
  }) async {
    if (_cache.containsKey(languageCode)) {
      _localizedStrings = _cache[languageCode]!;
      return;
    }

    try {
      final jsonString = await rootBundle.loadString(
        '$assetsPath/$languageCode.json',
      ); // Sadece istenen dili yükle
      _localizedStrings = json.decode(jsonString) as Map<String, dynamic>;
      _cache[languageCode] = _localizedStrings; // Cache'e ekle
    } catch (e) {
      _localizedStrings = {};
    }
  }

  Future<List<Locale>> detectAvailableLanguages({
    required String defaultLocale,
    required String assetsPath,
  }) async {
    final detectedLocales = <Locale>[];

    try {
      final dir = Directory(assetsPath);
      if (!dir.existsSync()) return [const Locale('en')];

      final files = dir.listSync().where((file) => file.path.endsWith('.json'));

      for (final file in files) {
        final langCode = file.uri.pathSegments.last.split('.').first;
        detectedLocales.add(Locale(langCode));
      }

      return detectedLocales.isNotEmpty
          ? detectedLocales
          : [Locale(defaultLocale)];
    } catch (e) {
      return [Locale(defaultLocale)];
    }
  }

  String translate(String key) {
    return _localizedStrings[key] as String? ?? key;
  }
}
