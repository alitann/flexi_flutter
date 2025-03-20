import 'package:flexi_localization/src/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit({required this.defaultLocale, required this.assetsPath})
    : super(
        LocalizationState(
          locale: Locale(defaultLocale),
          supportedLocales: [Locale(defaultLocale)],
        ),
      ) {
    _initialize();
  }

  final String defaultLocale;
  final String assetsPath;
  static const String _localeKey = 'selected_locale';

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey) ?? defaultLocale;

    await LocalizationService().loadLanguage(
      languageCode: savedLocale,
      assetsPath: assetsPath,
    );
    final locales = await LocalizationService().detectAvailableLanguages(
      defaultLocale: defaultLocale,
      assetsPath: assetsPath,
    );

    emit(
      LocalizationState(
        locale: Locale(savedLocale),
        supportedLocales:
            locales.isNotEmpty ? locales : [Locale(defaultLocale)],
      ),
    );
  }

  Future<void> changeLocale(String languageCode) async {
    await LocalizationService().loadLanguage(
      languageCode: languageCode,
      assetsPath: assetsPath,
    );
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
