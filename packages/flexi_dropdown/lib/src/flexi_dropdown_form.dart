import 'package:flutter/material.dart';
import 'flexi_dropdown.dart';

/// A form widget to manage multiple [FlexiDropdown] instances with a GlobalKey.
///
/// Provides methods to retrieve dropdown values and "other" text by name using a form key.
///
/// Example usage:
/// ```dart
/// final formKey = GlobalKey<FlexiDropdownFormState>();
/// FlexiDropdownForm(
///   key: formKey,
///   dropdowns: [
///     FlexiDropdown<String>(
///       name: 'color',
///       items: ['Red', 'Blue'],
///     ),
///   ],
///   child: ElevatedButton(
///     onPressed: () {
///       final value = formKey.value<String>('color');
///       final text = formKey.text('color');
///       print('Value: $value, Text: $text');
///     },
///     child: Text('Get Value'),
///   ),
/// )
/// ```
class FlexiDropdownForm<T> extends StatefulWidget {
  final List<FlexiDropdown> dropdowns;
  final Widget? child;

  const FlexiDropdownForm({super.key, required this.dropdowns, this.child});

  @override
  FlexiDropdownFormState<T> createState() => FlexiDropdownFormState<T>();
}

class FlexiDropdownFormState<T> extends State<FlexiDropdownForm<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [...widget.dropdowns, if (widget.child != null) widget.child!],
    );
  }

  U? getValueByName<U>(String name) {
    final dropdown = widget.dropdowns.firstWhere(
      (d) => d.name == name,
      orElse: () => throw Exception('Dropdown with name "$name" not found'),
    );
    return dropdown.state.getValue() as U?;
  }

  String? getOtherTextByName(String name) {
    final dropdown = widget.dropdowns.firstWhere(
      (d) => d.name == name,
      orElse: () => throw Exception('Dropdown with name "$name" not found'),
    );
    return dropdown.state.getOtherText();
  }
}

// Extension to shorten the syntax
extension FlexiDropdownFormKeyExtension<T>
    on GlobalKey<FlexiDropdownFormState<T>> {
  U? value<U>(String name) => currentState?.getValueByName<U>(name);
  String? text(String name) => currentState?.getOtherTextByName(name);
}
