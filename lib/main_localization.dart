import 'package:flexi_localization/flexi_localization.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlexiLocalization(
      builder: (context, locale, supportedLocales, localizationsDelegates) {
        return MaterialApp(
          title: 'Flexi Localization Demo',
          locale: locale,
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
          home: HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.homeTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.tr.welcomeMessage), // Çeviri testi
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.localeManager.changeLocale("tr"); // Dili değiştir
              },
              child: Text("Change to Turkish"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.localeManager.changeLocale("en"); // Dili değiştir
              },
              child: Text("Change to English"),
            ),
          ],
        ),
      ),
    );
  }
}
