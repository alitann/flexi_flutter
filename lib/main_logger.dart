import 'package:flexi_logger/flexi_logger.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final logObserver = LogNavigationObserver();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexi Logger Demo',
      navigatorObservers: [logObserver],
      routes: {
        '/': (context) => const HomePage(),
        '/second': (context) => const SecondPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget with LoggableMixin {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                logButtonClick('go_to_second_page', context);
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('Go to Second Page'),
            ),
            ElevatedButton(
              onPressed: () {
                logDialogShown('info_dialog', 'helloDialog', context);
                showDialog(
                  context: context,
                  builder:
                      (_) => const AlertDialog(
                        title: Text('Hello'),
                        content: Text('This is a test dialog'),
                      ),
                );
              },
              child: const Text('Show Dialog'),
            ),
            ElevatedButton(
              onPressed: () {
                logCustomEvent('custom_test_event', {
                  'user_action': 'pressed_custom_event_button',
                  'extra_info': 'Hello from logger',
                }, context);
              },
              child: const Text('Send Custom Event'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget with LoggableMixin {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            logButtonClick('go_back_home', context);
            Navigator.pop(context);
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}
