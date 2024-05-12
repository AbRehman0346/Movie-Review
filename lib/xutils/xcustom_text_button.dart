import 'package:flutter/material.dart';

class XCustomTextButton extends StatelessWidget {
  double? fontSize;
  String text;
  Color? background;
  Color? textColor;
  double horizontalPadding;
  double verticalPadding;
  Function? onTap;
  XCustomTextButton({
    Key? key,
    required this.text,
    this.fontSize,
    this.background,
    this.textColor,
    this.horizontalPadding = 15,
    this.verticalPadding = 10,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: verticalPadding, horizontal: horizontalPadding),
        color: background,
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: textColor),
        ),
      ),
    );
  }
}
