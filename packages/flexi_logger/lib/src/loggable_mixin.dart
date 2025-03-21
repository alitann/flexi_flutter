import 'package:flexi_logger/src/logger.dart';
import 'package:flutter/material.dart';

mixin LoggableMixin {
  void logButtonClick(String buttonName, BuildContext context) {
    final widgetName = context.widget.runtimeType.toString();
    Logger().logButtonClick(buttonName, widgetName);
  }

  void logDialogShown(
    String dialogType,
    String dialogName,
    BuildContext context,
  ) {
    Logger().logDialogShown(dialogType, dialogName);
  }

  void logCustomEvent(
    String eventName,
    Map<String, dynamic> details,
    BuildContext context,
  ) {
    final widgetName = context.widget.runtimeType.toString();
    Logger().logCustomEvent(eventName, {'widget': widgetName, ...details});
  }
}
