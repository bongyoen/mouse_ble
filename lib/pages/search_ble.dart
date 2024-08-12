import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouse_ble/app_extensions.dart';
import 'package:mouse_ble/bloc/navigation/navigation_bloc.dart';

import '../bloc/bluetooth/bluet-bloc.dart';
import '../bloc/bluetooth/bluet-event.dart';
import '../bloc/bluetooth/bluet-state.dart';
import '../bloc/navigation/navigation_event.dart';

class SearchBle extends StatefulWidget {
  const SearchBle({Key? key}) : super(key: key);

  @override
  State<SearchBle> createState() => _SearchBleState();
}

class _SearchBleState extends State<SearchBle> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BleBloc>();
    final naviBloc = context.read<NavigationBloc>();
    List<Map<String, String>> devices = bloc.devices;

    return BlocBuilder<BleBloc, BleState>(
      builder: (context, state) {
        if (state is GetList) {

          return Column(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: context.height * 0.8,
                  child: ListView(
                    children: List.generate(state.deviceList.length, (index) {
                      return ListTile(
                        title: TextButton(
                            onPressed: () {
                              naviBloc.add(GoToActiveBlePageEvent());
                              bloc.add(AddDevice(device: state.deviceList[index]));
                            },
                            child: Text(state.deviceList[index]['name']!)),
                      );
                    }),
                  ),
                ),
              )
            ],
          );
        }
        return const Text("data");
      },
    );

    return Column(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            height: context.height * 0.8,
            child: ListView(
              children: List.generate(devices.length, (index) {
                return ListTile(
                  title: TextButton(
                      onPressed: () {
                        bloc.add(AddDevice(device: devices[index]));
                        naviBloc.add(GoToSearchBlePageEvent());
                      },
                      child: Text(devices[index]['name']!)),
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}
