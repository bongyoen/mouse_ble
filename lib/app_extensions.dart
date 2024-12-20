import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  Size get _size => MediaQuery.of(this).size;

  double get width => _size.width;

  double get height => _size.height;
}

enum DeviceType { desktop }

extension DeviceTypeExtension on DeviceType {
  int getMaxWidth() => 768;

  Widget deviceType(BuildContext context, Widget mobile, Widget desktop) {
    return context.width < 768 ? mobile : desktop;
  }

  double getHorizontalPadding(BuildContext context) {
    if (context.width < DeviceType.desktop.getMaxWidth()) {
      return context.width * .03;
    } else {
      return context.width * .08;
    }
  }
}
