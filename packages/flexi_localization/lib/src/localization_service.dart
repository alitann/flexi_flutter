import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocalizationService {
  factory LocalizationService() => _instance;
  LocalizationService._internal();
  static final LocalizationService _instance = LocalizationService._internal();

  Map<String, dynamic> _localizedStrings = {};
  final Map<String, Map<String, dynamic>> _cache =
      {}; // Önceden yüklenen dilleri sakla
  List<Locale> _detectedLocales = []; // Tespit edilen diller önceden saklanacak

  /// Sadece ihtiyaç duyulan dili yükler (Lazy Loading)
  Future<void> loadLanguage(String languageCode, String assetsPath) async {
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

  /// `assets/lang/` içindeki tüm JSON dosyalarını tarar ve mevcut dilleri döndürür.
  Future<List<Locale>> detectAvailableLanguages(String assetsPath) async {
    if (_detectedLocales.isNotEmpty) {
      return _detectedLocales; // Daha önce tespit edilen dilleri döndür
    }

    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

      _detectedLocales =
          manifestMap.keys
              .where(
                (path) => path.startsWith(assetsPath) && path.endsWith('.json'),
              )
              .map((path) {
                final langCode = path.split('/').last.split('.').first;
                return Locale(langCode);
              })
              .toList();

      if (_detectedLocales.isEmpty) {
        _detectedLocales.add(
          const Locale('en'),
        ); // Eğer hiç dil bulunamazsa, en azından "en" olsun
      }

      return _detectedLocales;
    } catch (e) {
      return [const Locale('en')]; // Hata olursa varsayılan olarak "en" döndür
    }
  }

  String translate(String key) {
    return _localizedStrings[key] as String? ?? key;
  }
}
