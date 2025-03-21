import 'package:flexi_logger/src/default_log_sink.dart';
import 'package:flexi_logger/src/log_sink.dart';
import 'package:flutter/material.dart';

class Logger {
  factory Logger() => _instance;
  Logger._internal() {
    _logSink = DefaultLogSink();
  }
  static final Logger _instance = Logger._internal();

  LogSink? _logSink;
  Map<String, dynamic>? _globalData;
  Map<String, dynamic> get globalData => _globalData ??= {};

  set globalData(Map<String, dynamic> data) => _globalData = data;

  set logSink(LogSink logSink) {
    _logSink = logSink;
  }

  LogSink get logSink => _logSink!;

  void logPageView(String pageName) {
    _logEvent('page_view', {'page_name': pageName});
  }

  void logPageClosed(String pageName) {
    _logEvent('page_close', {'page_name': pageName});
  }

  void logButtonClick(String buttonName, String widgetName) {
    _logEvent('button_click', {
      'button_name': buttonName,
      'widget_name': widgetName,
    });
  }

  void logDialogShown(String dialogType, String dialogName) {
    _logEvent('dialog_shown', {
      'dialog_type': dialogType,
      'dialog_name': dialogName,
    });
  }

  void logCustomEvent(String eventName, Map<String, dynamic> details) {
    _logEvent(eventName, details);
  }

  void _logEvent(String eventType, Map<String, dynamic> data) {
    final fullData = {..._globalData ?? {}, ...data};
    _logSink?.logEvent(eventType, fullData);
  }

  void logError(String message, {dynamic error, StackTrace? stackTrace}) {
    final errorData = {
      'message': message,
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stack_trace': stackTrace.toString(),
    };
    _logEvent('error', errorData);
  }

  void onFlutterFrameworkError(FlutterErrorDetails details) {
    _logEvent('Flutter framework error', {
      'exception': details.exceptionAsString(),
      'stack_trace': details.stack.toString(),
    });
  }

  void onApplicationLevelError(Object error, StackTrace stackTrace) {
    _logEvent('Application error', {
      'exception': error,
      'stack_trace': stackTrace.toString(),
    });
  }
}
