import 'package:flutter/material.dart';

class XText extends StatelessWidget {
  final double? fontSize;
  final String text;
  final Color? color;
  final int? maxLines;
  final TextOverflow overflow;
  final FontWeight? fontWeight;
  const XText(this.text,
      {Key? key,
      this.fontSize,
      this.color,
      this.fontWeight,
      this.maxLines,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        maxLines: maxLines,
        overflow: overflow,
        style: TextStyle(
            fontSize: fontSize, color: color, fontWeight: fontWeight));
  }
}
