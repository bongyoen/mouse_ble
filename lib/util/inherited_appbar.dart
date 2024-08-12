import 'package:flutter/material.dart';

class InheritedAppbar extends InheritedWidget {
  final AppBar appBar;

  const InheritedAppbar({
    Key? key,
    required this.appBar,
    required Widget child,
  }) : super(key: key, child: child);

  static InheritedAppbar of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedAppbar>()!;
  }

  @override
  bool updateShouldNotify(InheritedAppbar oldWidget) {
    return appBar != oldWidget.appBar;
  }
}