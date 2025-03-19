import 'package:flexi_localization/src/localization_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

typedef FlexiLocalizationBuilder =
    Widget Function(
      BuildContext context,
      Locale locale,
      List<Locale> supportedLocales,
      List<LocalizationsDelegate<dynamic>> localizationsDelegates,
    );

class FlexiLocalization extends StatelessWidget {
  const FlexiLocalization({
    required this.builder,
    super.key,
    this.defaultLocale = 'en',
    this.assetsPath = 'packages/flexi_localization/assets/lang',
    this.loadingWidget,
  });
  final String defaultLocale;
  final String assetsPath;
  final FlexiLocalizationBuilder builder;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              LocalizationCubit(defaultLocale, assetsPath)
                ..detectAvailableLanguages(),
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        builder: (context, state) {
          /// Eğer supportedLocales henüz belirlenmediyse
          /// kullanıcıdan gelen `loadingWidget`'ı göster
          if (state.supportedLocales.isEmpty) {
            return loadingWidget ?? _buildDefaultLoadingScreen();
          }

          return builder(
            context,
            state.locale,
            state.supportedLocales,
            _localizationDelegates(),
          );
        },
      ),
    );
  }

  /// Varsayılan yükleme ekranı
  Widget _buildDefaultLoadingScreen() {
    return const MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }

  List<LocalizationsDelegate<dynamic>> _localizationDelegates() {
    return [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }
}
