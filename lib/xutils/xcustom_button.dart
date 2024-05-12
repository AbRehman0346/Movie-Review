import 'package:flutter/material.dart';

class XCustomButton extends StatelessWidget {
  double? fontSize;
  Widget widget;
  Color? background;
  Color? textColor;
  double horizontalPadding;
  double verticalPadding;
  Function? onTap;
  XCustomButton({
    Key? key,
    required this.widget,
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
        child: widget,
      ),
    );
  }
}
