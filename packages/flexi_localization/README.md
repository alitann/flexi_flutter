# Flexi Localization 📢🌍

**Flexi Localization** is a powerful, flexible, and lightweight **internationalization (i18n) library** for Flutter applications.  
It simplifies localization handling using **auto-detected language files**, **code generation**, and **state management with Cubit**.

This package allows developers to:

- **Automatically detect language files** in the project.
- **Generate strongly-typed keys** for translations.
- **Efficiently load translations with lazy loading**.
- **Easily switch languages at runtime** without restarting the app.
- **Use a `Bloc/Cubit` state management approach** to manage localization.

---

## 🚀 Features

👉 **Auto-detect translation files** from `assets/lang`  
👉 **Automatically generate `translations.g.dart`** with strongly-typed keys  
👉 **Efficient lazy loading** for better performance  
👉 **Uses `Cubit` for state management**  
👉 **Customizable loading widget during language initialization**  
👉 **Minimal setup required**

---

## 📚 Installation

### **1⃣ Add Dependency**

Add the **Flexi Localization** package to your `pubspec.yaml`:

```yaml
dependencies:
  flexi_localization:
    git:
      url: https://github.com/alitann/flexi_localization.git
```

Then, run:

```sh
flutter pub get
```

---

## 🛠️ Configuration

### **2⃣ Enable Localization in `pubspec.yaml`**

To specify where your translations are stored and where the generated file should be placed, add:

```yaml
flexi_localization:
  assets_path: "assets/lang"
  output_path: "lib/generated"
```

---

## 📂 3⃣ Adding Translation JSON Files

Create JSON files for each supported language inside your **`assets/lang/`** folder:

#### **English (`assets/lang/en.json`)**

```json
{
  "home_title": "Home",
  "welcome_message": "Welcome to our app",
  "logout_button": "Logout",
  "login_button": "Login"
}
```

#### **Turkish (`assets/lang/tr.json`)**

```json
{
  "home_title": "Ana Sayfa",
  "welcome_message": "Uygulamaya hoş geldiniz",
  "logout_button": "Çıkış Yap",
  "login_button": "Giriş Yap"
}
```

---

## 🏗️ Usage

### **4⃣ Wrap Your App with `FlexiLocalization`**

Modify your `main.dart` file to use `FlexiLocalization`:

```dart
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
```

---

### **5⃣ Use Translations in Widgets**

Now you can access translations anywhere in your Flutter app using **`context.tr`**.

```dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.homeTitle)), // Fetches "Home" or "Ana Sayfa"
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.tr.welcomeMessage), // Displays localized message
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.localeManager.changeLocale("tr"); // Switch to Turkish
              },
              child: const Text("Change to Turkish"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                context.localeManager.changeLocale("en"); // Switch to English
              },
              child: const Text("Change to English"),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🛠️ Code Generation

### **6⃣ Generate Translation Keys**

To generate strongly-typed translation keys, run:

```sh
dart run build_runner build --delete-conflicting-outputs
```

This will create a file named **`translations.g.dart`** inside **`lib/generated/`**.  
Now, instead of using raw string keys, you can use **auto-complete translation keys**:

```dart
Text(context.tr.homeTitle) // Instead of context.tr("home_title")
```

---

## 🎯 Advanced Features

### 🔥 Lazy Loading

The package **only loads the requested language** instead of preloading all translations.  
This improves performance and memory usage.

### 📅 Auto-Detect Translation Files

No need to manually register languages! The package scans `assets/lang/` and automatically detects available languages.

### 🎨 Custom Loading Widget

You can specify a **custom loading widget** while translations are being loaded:

```dart
FlexiLocalization(
  loadingWidget: Center(child: CircularProgressIndicator()),
  builder: (context, locale, supportedLocales, localizationsDelegates) {
    return MaterialApp(...);
  },
);
```

---

## 🚨 Error Handling

- If a translation key is **missing**, it returns the key itself:
  ```dart
  Text(context.tr.nonExistentKey) // Displays "nonExistentKey"
  ```
- If no translation files are found, the **default locale is used**.

---

## 📄 License

MIT License

---

## 👊 Contributing

We welcome contributions! Feel free to submit issues, feature requests, or pull requests on [GitHub](https://github.com/alitann/flexi_localization).

---

## ❤️ Support

If you like **Flexi Localization**, give it a ⭐ on GitHub!  
For questions or feedback, feel free to open an issue.

---

🎉 **Happy Coding with Flexi Localization!** 🚀
