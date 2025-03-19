import 'dart:async';
import 'package:flutter/material.dart';

enum OtherFieldPosition { vertical, horizontal }

class FlexiDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String name;
  final T? initialValue;
  final void Function(T?)? onChanged;
  final Widget Function(BuildContext, T?)? selectedItemBuilder;
  final Widget Function(BuildContext, T)? itemBuilder;
  final bool Function(T)? isOther;
  final Widget? hint;
  final bool showIcon;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isExpanded;
  final Offset? menuOffset;
  final bool useDivider;
  final Widget? divider;
  final IconThemeData? iconStyle;
  final InputDecoration? otherFieldDecoration;
  final double? otherFieldWidth;
  final double? otherFieldHeight;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  final double? menuWidth;
  final double? menuHeight;
  final OtherFieldPosition otherFieldPosition;
  final double? dropdownWidthWhenOther;
  final double? otherFieldWidthWhenOther;
  final int? dropdownFlexWhenOther;
  final int? otherFieldFlexWhenOther;

  FlexiDropdown({
    super.key,
    required this.items,
    required this.name,
    this.initialValue,
    this.onChanged,
    this.selectedItemBuilder,
    this.itemBuilder,
    this.isOther,
    this.hint,
    this.showIcon = false,
    this.leadingIcon,
    this.trailingIcon,
    this.isExpanded = false,
    this.menuOffset,
    this.useDivider = false,
    this.divider,
    this.iconStyle,
    this.otherFieldDecoration,
    this.otherFieldWidth,
    this.otherFieldHeight,
    this.decoration,
    this.padding,
    this.menuWidth,
    this.menuHeight,
    this.otherFieldPosition = OtherFieldPosition.vertical,
    this.dropdownWidthWhenOther,
    this.otherFieldWidthWhenOther,
    this.dropdownFlexWhenOther,
    this.otherFieldFlexWhenOther,
  }) : assert(items.isNotEmpty, 'Items list cannot be empty'),
       assert(name.isNotEmpty, 'Name cannot be empty');

  @override
  FlexiDropdownState<T> createState() => FlexiDropdownState<T>();

  late final FlexiDropdownState<T> state;
}

class FlexiDropdownState<T> extends State<FlexiDropdown<T>> {
  late final StreamController<T?> _valueController;
  late final StreamController<bool> _showOtherFieldController;
  final TextEditingController _otherTextController = TextEditingController();
  T? _selectedValue;
  bool _showOtherField = false;
  final _dropdownKey = GlobalKey();
  double? _dropdownHeight;

  @override
  void initState() {
    super.initState();
    widget.state = this;
    _selectedValue = widget.initialValue;
    _showOtherField =
        widget.initialValue != null &&
        (widget.isOther?.call(widget.initialValue as T) ?? false);
    _valueController = StreamController<T?>.broadcast()..add(_selectedValue);
    _showOtherFieldController =
        StreamController<bool>.broadcast()..add(_showOtherField);
  }

  @override
  void dispose() {
    _valueController.close();
    _showOtherFieldController.close();
    _otherTextController.dispose();
    super.dispose();
  }

  void _updateValue(T? newValue) {
    _selectedValue = newValue;
    _showOtherField =
        newValue != null && (widget.isOther?.call(newValue) ?? false);
    _valueController.add(_selectedValue);
    _showOtherFieldController.add(_showOtherField);
  }

  @override
  Widget build(BuildContext context) {
    // Dropdown yüksekliğini her zaman ölç
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? box =
          _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && mounted) {
        setState(() {
          _dropdownHeight = box.size.height;
        });
      }
    });

    return StreamBuilder<T?>(
      stream: _valueController.stream,
      builder: (context, valueSnapshot) {
        final selectedValue = valueSnapshot.data;
        return StreamBuilder<bool>(
          stream: _showOtherFieldController.stream,
          initialData: false,
          builder: (context, otherFieldSnapshot) {
            final showOtherField = otherFieldSnapshot.data ?? false;
            if (widget.otherFieldPosition == OtherFieldPosition.horizontal &&
                showOtherField) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildDropdownWithWidth(context, selectedValue),
                  const SizedBox(
                    width: 8,
                  ), // Dropdown ve TextField arasına boşluk
                  _buildOtherTextFieldRow(),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment:
                    widget.isExpanded
                        ? CrossAxisAlignment.stretch
                        : CrossAxisAlignment.start,
                children: [
                  _buildDropdown(context, selectedValue),
                  if (showOtherField) _buildOtherTextField(),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildDropdown(BuildContext context, T? currentValue) {
    return GestureDetector(
      key: _dropdownKey,
      onTap: () => _showPopupMenu(context, currentValue),
      child: Container(
        padding:
            widget.padding ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration:
            widget.decoration ??
            BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
        child: Row(
          children: [
            if (widget.showIcon && widget.leadingIcon != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  widget.leadingIcon,
                  color:
                      widget.iconStyle?.color ??
                      Theme.of(context).iconTheme.color,
                  size: widget.iconStyle?.size ?? 24,
                ),
              ),
            Expanded(
              child:
                  currentValue != null
                      ? (widget.selectedItemBuilder?.call(
                            context,
                            currentValue,
                          ) ??
                          Text(currentValue.toString()))
                      : (widget.hint ?? const Text('Select an option')),
            ),
            Icon(
              widget.trailingIcon ?? Icons.arrow_drop_down,
              color:
                  widget.iconStyle?.color ?? Theme.of(context).iconTheme.color,
              size: widget.iconStyle?.size ?? 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownWithWidth(BuildContext context, T? currentValue) {
    if (widget.dropdownWidthWhenOther != null) {
      return SizedBox(
        width: widget.dropdownWidthWhenOther,
        child: _buildDropdown(context, currentValue),
      );
    } else {
      return Flexible(
        flex: widget.dropdownFlexWhenOther ?? 1,
        child: _buildDropdown(context, currentValue),
      );
    }
  }

  Widget _buildOtherTextField() {
    // Kullanıcı manuel yükseklik belirttiyse onu kullan, yoksa dropdown yüksekliğine eşitle
    final effectiveHeight = widget.otherFieldHeight ?? _dropdownHeight ?? 48;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: widget.otherFieldWidth ?? double.infinity,
        height: effectiveHeight,
        child: TextField(
          controller: _otherTextController,
          decoration:
              widget.otherFieldDecoration ??
              const InputDecoration(
                hintText: 'Please specify',
                labelText: 'Specify Other', // Varsayılan etiket
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Kenarlık rengi
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ), // Odaklanmış kenarlık
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Etkin kenarlık
                ),
                filled: true, // Dolgu
                fillColor: Colors.white, // Dolgu rengi
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintStyle: TextStyle(color: Colors.grey), // Hint metni stili
              ),
        ),
      ),
    );
  }

  Widget _buildOtherTextFieldRow() {
    // Kullanıcı manuel yükseklik belirttiyse onu kullan, yoksa dropdown yüksekliğine eşitle
    final effectiveHeight = widget.otherFieldHeight ?? _dropdownHeight ?? 48;

    if (widget.otherFieldWidthWhenOther != null) {
      return SizedBox(
        width: widget.otherFieldWidthWhenOther,
        height: effectiveHeight,
        child: TextField(
          controller: _otherTextController,
          decoration:
              widget.otherFieldDecoration ??
              const InputDecoration(
                hintText: 'Please specify',
                labelText: 'Specify Other', // Varsayılan etiket
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Kenarlık rengi
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ), // Odaklanmış kenarlık
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey), // Etkin kenarlık
                ),
                filled: true, // Dolgu
                fillColor: Colors.white, // Dolgu rengi
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintStyle: TextStyle(color: Colors.grey), // Hint metni stili
              ),
        ),
      );
    } else {
      return Flexible(
        flex: widget.otherFieldFlexWhenOther ?? 1,
        child: SizedBox(
          height: effectiveHeight,
          child: TextField(
            controller: _otherTextController,
            decoration:
                widget.otherFieldDecoration ??
                const InputDecoration(
                  hintText: 'Please specify',
                  labelText: 'Specify Other', // Varsayılan etiket
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // Kenarlık rengi
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ), // Odaklanmış kenarlık
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ), // Etkin kenarlık
                  ),
                  filled: true, // Dolgu
                  fillColor: Colors.white, // Dolgu rengi
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  hintStyle: TextStyle(color: Colors.grey), // Hint metni stili
                ),
          ),
        ),
      );
    }
  }

  void _showPopupMenu(BuildContext context, T? currentValue) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final double dropdownWidth = box.size.width;

    final double effectiveMenuWidth = widget.menuWidth ?? dropdownWidth;
    final double minWidth = dropdownWidth;

    final selected = await showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx + (widget.menuOffset?.dx ?? 0),
        position.dy + box.size.height + (widget.menuOffset?.dy ?? 0),
        position.dx + box.size.width,
        position.dy + box.size.height,
      ),
      items:
          widget.items.map((T item) {
            return PopupMenuItem<T>(
              value: item,
              child: Container(
                color: Colors.red, // Item arka planı kırmızı
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.itemBuilder?.call(context, item) ??
                        Text(
                          item.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                          ), // Metin beyaz
                        ),
                    if (widget.useDivider && widget.items.last != item)
                      widget.divider ??
                          Divider(color: Colors.grey.shade300, height: 1),
                  ],
                ),
              ),
            );
          }).toList(),
      color: Colors.red, // Menü arka planı kırmızı
      constraints: BoxConstraints(
        minWidth: minWidth,
        maxWidth: effectiveMenuWidth > minWidth ? effectiveMenuWidth : minWidth,
        maxHeight: widget.menuHeight ?? double.infinity,
      ),
    );

    if (selected != null) {
      _updateValue(selected);
    }
  }

  T? getValue() => _selectedValue;
  String? getOtherText() => _showOtherField ? _otherTextController.text : null;
}
