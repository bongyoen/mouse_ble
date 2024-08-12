import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouse_ble/bloc/navigation/navigation_bloc.dart';
import 'package:mouse_ble/pages/active_mouse.dart';
import 'package:mouse_ble/pages/search_ble.dart';

import '../bloc/bluetooth/bluet-bloc.dart';
import '../bloc/navigation/navigation_state.dart';

class NavigationProvider extends StatelessWidget {
  const NavigationProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NavigationConsumer();
  }
}

class NavigationConsumer extends StatefulWidget {
  const NavigationConsumer({Key? key}) : super(key: key);

  @override
  State<NavigationConsumer> createState() => _NavigationConsumerState();
}

class _NavigationConsumerState extends State<NavigationConsumer> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NavigationBloc>(context);
    final bleBloc = BlocProvider.of<BleBloc>(context);

    return BlocConsumer<NavigationBloc, NavigationState>(
      listener: (context, state) {
        // bloc의 state가 변경될 때마다 네비게이션을 수행
        if (state is SearchBlePageState) {
          Navigator.push(
            context,
            MaterialPageRoute<NavigationBloc>(builder: (context) {
              return MultiBlocProvider(providers: [
                BlocProvider.value(value: bloc),
                BlocProvider.value(value: bleBloc)
              ], child: const SearchBle());
            }),
          );
        } else if (state is ActiveBlePageState) {
          Navigator.push(
            context,
            MaterialPageRoute<NavigationBloc>(builder: (context) {
              return MultiBlocProvider(providers: [
                BlocProvider.value(value: bloc),
                BlocProvider.value(value: bleBloc)
              ], child: const ActiveMouse());
            }),
          );
        }
      },
      builder: (context, state) {
        return const SearchBle();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    print("object");
  }
}
