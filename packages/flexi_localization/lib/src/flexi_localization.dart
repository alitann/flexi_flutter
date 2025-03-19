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
  final String defaultLocale;
  final String assetsPath;
  final FlexiLocalizationBuilder builder;

  const FlexiLocalization({
    super.key,
    this.defaultLocale = "en",
    this.assetsPath = "packages/flexi_localization/assets/lang",
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              LocalizationCubit(defaultLocale, assetsPath)
                ..detectAvailableLanguages(),
      child: BlocBuilder<LocalizationCubit, LocalizationState>(
        // Burada doğru state tipi kullanıldı
        builder: (context, state) {
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

  List<LocalizationsDelegate<dynamic>> _localizationDelegates() {
    return [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ];
  }
}
