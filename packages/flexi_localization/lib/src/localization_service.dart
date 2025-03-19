import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  Map<String, dynamic> _localizedStrings = {};
  final Map<String, Map<String, dynamic>> _cache = {};

  Future<void> loadLanguage(String languageCode, String assetsPath) async {
    if (_cache.containsKey(languageCode)) {
      _localizedStrings = _cache[languageCode]!;
      return;
    }

    try {
      String jsonString = await rootBundle.loadString(
        '$assetsPath/$languageCode.json',
      );
      _localizedStrings = json.decode(jsonString);
      _cache[languageCode] = _localizedStrings;
    } catch (e) {
      _localizedStrings = {};
    }
  }

  /// `assets/lang/` içindeki tüm JSON dosyalarını tarar ve mevcut dilleri döndürür.
  Future<List<Locale>> detectAvailableLanguages(String assetsPath) async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      List<Locale> availableLocales =
          manifestMap.keys
              .where(
                (path) => path.startsWith(assetsPath) && path.endsWith(".json"),
              )
              .map((path) {
                String langCode = path.split("/").last.split(".").first;
                return Locale(langCode);
              })
              .toList();

      return availableLocales;
    } catch (e) {
      return [];
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}
