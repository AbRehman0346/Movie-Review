import 'package:flutter/material.dart';

class XTextField extends StatelessWidget {
  int _maxLines;
  final int _minLines;
  final String _hint;
  final Color _borderColor;
  final Color? _fillColor;
  final Color? _textColor;
  final Color? _hintTextColor;
  final double _borderWidth;
  final double _borderRadius;
  final double _fontSize;
  final double _contentPadding;
  final bool _obscureText;
  final bool _enableSuggestions;
  final bool _autocorrect;
  final bool _filled;
  final bool _enabled;
  final bool _enableBorder;
  final Widget? _suffixIcon;
  final Widget? _prefixIcon;
  final TextEditingController? _controller;
  final Function? _onChange;
  String _onChangeFunctionVariableValue = "default Value";
  XTextField({
    Key? key,
    int maxLines = 1,
    int minLines = 1,
    String hint = "",
    Color borderColor = Colors.blue,
    Color? fillColor,
    Color? textColor,
    Color? hintTextColor,
    double borderWidth = 20,
    double borderRadius = 0,
    double fontSize = 20,
    double contentPadding = 10,
    bool obscureText = false,
    bool enableSuggestions = true,
    bool autocorrect = true,
    bool filled = false,
    bool enabled = true,
    bool enableBorder = true,
    Widget? suffixIcon,
    Widget? prefixIcon,
    TextEditingController? controller,
    double height = 30,
    double width = 200,
    Function? onChange,
  })  : _controller = controller,
        _prefixIcon = prefixIcon,
        _suffixIcon = suffixIcon,
        _filled = filled,
        _enabled = enabled,
        _enableBorder = enableBorder,
        _autocorrect = autocorrect,
        _enableSuggestions = enableSuggestions,
        _obscureText = obscureText,
        _contentPadding = contentPadding,
        _fontSize = fontSize,
        _borderRadius = borderRadius,
        _borderWidth = borderWidth,
        _hintTextColor = hintTextColor,
        _textColor = textColor,
        _fillColor = fillColor,
        _borderColor = borderColor,
        _hint = hint,
        _minLines = minLines,
        _maxLines = maxLines,
        _onChange = onChange,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_minLines > _maxLines) {
      _maxLines = _minLines;
    }

    InputDecoration decoration = InputDecoration(
      fillColor: _fillColor,
      filled: _filled,
      suffixIcon: _suffixIcon,
      prefixIcon: _prefixIcon,
      hintText: _hint,
      hintStyle: TextStyle(color: _hintTextColor),
      contentPadding: EdgeInsets.all(_contentPadding),
      border: _enableBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(_borderRadius),
              borderSide: BorderSide(
                color: _borderColor,
                width: _borderWidth,
              ),
            )
          : null,
    );

    TextStyle textStyle = TextStyle(fontSize: _fontSize, color: _textColor);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            obscureText: _obscureText,
            autocorrect: _autocorrect,
            enableSuggestions: _enableSuggestions,
            enabled: _enabled,
            onChanged: (s) {
              if (_onChange != null) {
                _onChangeFunctionVariableValue = s;
                _onChange!();
              }
            },
            maxLines: _maxLines,
            minLines: _minLines,
            decoration: decoration,
            style: textStyle,
          ),
        ),
      ],
    );
  }

  String get onChangeString => _onChangeFunctionVariableValue;
}
