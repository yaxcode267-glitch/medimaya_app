import 'package:flutter/material.dart';

class Responsive {
  static const mobile = 600.0;
  static const desktop = 1024.0;

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = Responsive.width(context);
    return width >= mobile && width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= desktop;
  }

  static double value(
    BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    final screenWidth = width(context);

    if (screenWidth >= Responsive.desktop) {
      return desktop ?? tablet ?? mobile;
    }

    if (screenWidth >= Responsive.mobile) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}
