import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bluetooth/bluet-bloc.dart';
import 'bloc/bluetooth/bluet-event.dart';

class StatefulWrapper extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const StatefulWrapper({Key? key, required this.onInit, required this.child})
      : super(key: key);

  @override
  StatefulWrapperState createState() {
    return StatefulWrapperState();
  }
}

class StatefulWrapperState extends State<StatefulWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    widget.onInit();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    BleBloc bloc = context.read<BleBloc>();

    switch (state) {
      case AppLifecycleState.resumed:
        print("상태변경 resumed");
        bloc.add(ReConnAction());
        break;
      case AppLifecycleState.inactive:
        print("상태변경 inactive");
        break;
      case AppLifecycleState.detached:
        print("상태변경 detached");
        bloc.add(DisConnAction());
        break;
      case AppLifecycleState.paused:
        print("상태변경 paused");
        bloc.add(DisConnAction());
        break;
      case AppLifecycleState.hidden:
        print("상태변경 hidden");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
