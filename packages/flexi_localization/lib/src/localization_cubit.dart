import 'package:flexi_localization/src/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit(String defaultLocale, this.assetsPath)
    : super(
        LocalizationState(
          locale: Locale(defaultLocale),
          supportedLocales: [Locale(defaultLocale)],
        ),
      ) {
    _loadSavedLocale();
  }
  final String assetsPath;
  static const String _localeKey = 'selected_locale';

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale =
        prefs.getString(_localeKey) ?? state.locale.languageCode;

    await LocalizationService().loadLanguage(savedLocale, assetsPath);
    await detectAvailableLanguages();
    emit(
      LocalizationState(
        locale: Locale(savedLocale),
        supportedLocales: state.supportedLocales,
      ),
    );
  }

  Future<void> detectAvailableLanguages() async {
    if (state.supportedLocales.isNotEmpty) return;

    final locales = await LocalizationService().detectAvailableLanguages(
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
    await LocalizationService().loadLanguage(languageCode, assetsPath); // Lazy
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
  LocalizationState({required this.locale, required this.supportedLocales});
  final Locale locale;
  final List<Locale> supportedLocales;
}
