import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flexi_bloc/flexi_bloc.dart';

// CheckboxCubit
class CheckboxCubit extends BaseCubit<bool> {
  CheckboxCubit() : super(const Success(data: false));
  void setCheckbox(bool value) => emitSuccess(value);
}

// LoginCubit
class LoginCubit extends BaseCubit<String> {
  Future<void> login(String username, String password) async {
    emitInProgress();
    await Future.delayed(const Duration(seconds: 1));
    if (username == "test" && password == "1234") {
      emitSuccess("token123");
    } else {
      emitError("Invalid credentials");
    }
  }
}

// ApiCubit
class ApiCubit extends BaseCubit<List<String>> {
  Future<void> fetchData() async {
    emitInProgress();
    await Future.delayed(const Duration(seconds: 2));
    emitSuccess(["Item 1", "Item 2", "Item 3"]);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Base Bloc Examples")),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              CheckboxExample(),
              LoginExample(),
              ApiExample(),
              ErrorExample(),
            ],
          ),
        ),
      ),
    );
  }
}

// 1. Checkbox Senaryosu
class CheckboxExample extends StatelessWidget {
  const CheckboxExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckboxCubit(),
      child: BaseBlocWidget<CheckboxCubit, bool>(
        buildWhen: (prev, curr) => curr is Success,
        onSuccess:
            (context, data) => Checkbox(
              // Context parametresi eklendi
              value: data ?? false,
              onChanged:
                  (value) =>
                      context.read<CheckboxCubit>().setCheckbox(value ?? false),
            ),
        onStateListen: (state) => debugPrint("Checkbox state: $state"),
        listenWhen: (previous, current) => current is Success,
      ),
    );
  }
}

// 2. Login Senaryosu
class LoginExample extends StatelessWidget {
  const LoginExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBlocStatefulWidget<LoginCubit, String>(
      blocCreator: () => LoginCubit(),
      onInitial:
          (context) => ElevatedButton(
            onPressed: () => context.read<LoginCubit>().login("test", "1234"),
            child: const Text("Login"),
          ),
      onLoading: (_, __) => const CircularProgressIndicator(),
      onSuccess: (_, data) => Text("Logged in: $data"),
      onError: (_, message, __) => Text(message),
      onStateListen: (state) => debugPrint("Login state: $state"),
      listenStateChanges: true,
      buildWhen: (prev, curr) => curr is Success || curr is Error,
      listenWhen: (prev, curr) => curr is Success,
    );
  }
}

// 3. API Senaryosu
class ApiExample extends StatelessWidget {
  const ApiExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApiCubit(),
      child: Column(
        children: [
          BaseBlocWidget<ApiCubit, List<String>>(
            buildWhen:
                (prev, curr) => true, // **Tüm durumlarda build edilmeli**
            onInitial: (context) => _buildFetchButton(context),
            onSuccess: (context, _) => _buildFetchButton(context),
            onError: (context, message, _) => _buildFetchButton(context),
            onLoading: (_, __) => const CircularProgressIndicator(),
          ),
          const SizedBox(height: 16),
          // API sonucunu gösterecek widget
          BaseBlocWidget<ApiCubit, List<String>>(
            buildWhen: (prev, curr) => curr is Success,
            onSuccess:
                (_, data) => Column(
                  children: data?.map((item) => Text(item)).toList() ?? [],
                ),
            orElse: (_) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFetchButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.read<ApiCubit>().fetchData(),
      child: const Text("Fetch Data"),
    );
  }
}

// 4. Hata Senaryosu
class ErrorExample extends StatelessWidget {
  const ErrorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBlocStatefulWidget<LoginCubit, String>(
      blocCreator: () => LoginCubit(),
      onInitial:
          (context) => ElevatedButton(
            onPressed: () => context.read<LoginCubit>().login("wrong", "user"),
            child: const Text("Trigger Error"),
          ),
      onError: (_, message, __) => Text(message),
    );
  }
}
