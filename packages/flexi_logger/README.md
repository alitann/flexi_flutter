# 📦 flexi_logger

A flexible and pluggable logging package for Flutter projects.  
Track user actions, page navigation, dialogs, buttons, and errors with ease.  
Supports custom sinks like Firebase, Sentry, Mixpanel, and more.

---

## ✨ Features

✅ Page view & close tracking  
✅ Dialog and button interaction logging  
✅ Custom event support  
✅ Error logging with stack traces  
✅ Works with any analytics/logging provider via pluggable `LogSink`  
✅ Lightweight and easy to integrate

---

## 🚀 Getting Started

### 1. Install

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flexi_logger:
    path: ../flexi_logger
```

Then, run:

```sh
flutter pub get
```

---

## 🛠️ Initialize

In your main.dart:

```
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: Set custom sink (e.g., FirebaseLogSink)
  Logger().logSink = MyCustomLogSink();

  // Global error handling
  FlutterError.onError = (details) => Logger().onFlutterFrameworkError(details);
  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) {
    Logger().onApplicationLevelError(error, stack);
  });
}
```

## 📂 Use It

**Page Tracking**

```
MaterialApp(
  navigatorObservers: [LogNavigationObserver()],
);
```

**In Widgets (with mixin)**

```
class MyWidget extends StatelessWidget with LoggableMixin {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        logButtonClick("my_button", context);
      },
      child: Text("Click Me"),
    );
  }
}
```

**Custom Event**

```
logCustomEvent("form_submit", {"formName": "Contact"}, context);

```

**Error Logging**

```
try {
  // something risky
} catch (e, st) {
  Logger().logError("Failed to load data", error: e, stackTrace: st);
}
```

## 🧩 Custom LogSink

```
class MySink implements LogSink {
  @override
  Future<void> init() async {
    // Setup
  }

  @override
  void logEvent(String eventType, Map<String, dynamic> data) {
    // Send to Firebase, Sentry, etc.
  }
}
```
