import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization_service.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  final String assetsPath;
  static const String _localeKey = "selected_locale";

  LocalizationCubit(String defaultLocale, this.assetsPath)
    : super(
        LocalizationState(locale: Locale(defaultLocale), supportedLocales: []),
      ) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String savedLocale =
        prefs.getString(_localeKey) ?? state.locale.languageCode;
    await LocalizationService().loadLanguage(savedLocale, assetsPath);
    detectAvailableLanguages();
    emit(
      LocalizationState(
        locale: Locale(savedLocale),
        supportedLocales: state.supportedLocales,
      ),
    );
  }

  Future<void> detectAvailableLanguages() async {
    List<Locale> locales = await LocalizationService().detectAvailableLanguages(
      assetsPath,
    );
    emit(
      LocalizationState(
        locale: state.locale,
        supportedLocales: locales.isNotEmpty ? locales : [state.locale],
      ),
    );
  }

  Future<void> changeLocale(String languageCode) async {
    await LocalizationService().loadLanguage(languageCode, assetsPath);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, languageCode);
    emit(
      LocalizationState(
        locale: Locale(languageCode),
        supportedLocales: state.supportedLocales,
      ),
    );
  }
}

class LocalizationState {
  final Locale locale;
  final List<Locale> supportedLocales;

  LocalizationState({required this.locale, required this.supportedLocales});
}
