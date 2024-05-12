import 'package:flutter/material.dart';

class Dimension {
  //For Laptop/Computer
  // static const double developScreenWidth = 1536;
  // static const double developScreenHeight = 753.5999755859375;

  //For Mobile Phone
  // static const double developScreenHeight = 752;
  // static const double developScreenWidth = 360;

  static double getDeveloperWidth(BuildContext context) {
    if (MediaQuery.of(context).size.width > 1200) {
      return 1536;
    } else {
      return 360;
    }
  }

  static double getWidth(BuildContext context, double width) {
    return getDeveloperWidth(context) /
        (MediaQuery.of(context).size.width / width);
  }

  static double getHeight(BuildContext context, double height) {
    return getDeveloperWidth(context) /
        (MediaQuery.of(context).size.height / height);
  }

  static double getHeightPercent(BuildContext context, double height) {
    return (height * (MediaQuery.of(context).size.height - 200)) / 100;
  }

  static double getWidthPercent(BuildContext context, double width) {
    return (width * MediaQuery.of(context).size.width) / 100;
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 640;
  }

  static bool isMediumScreen(BuildContext context) {
    return (MediaQuery.of(context).size.width >= 640 &&
        MediaQuery.of(context).size.width <= 1200);
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }
}
