import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouse_ble/app_extensions.dart';
import 'package:mouse_ble/bloc/bluetooth/bluet-bloc.dart';
import 'package:mouse_ble/bloc/bluetooth/bluet-event.dart';
import 'package:mouse_ble/bloc/bluetooth/bluet-state.dart';
import 'package:mouse_ble/stateful_wrapper.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulWrapper(
        onInit: () {},
        child: BlocBuilder<BleBloc, BleState>(
          builder: (context, state) {
            final bloc = context.read<BleBloc>();

            if (state is BluetInital) return Container();

            if (state is ConnectedState) {
              return Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        print("onTap");
                        bloc.isDoubleClick = 0;
                        bloc.add(MouseAction(x: 0, y: 0, c: 1, s: 0));
                        bloc.add(MouseAction(x: 0, y: 0, c: 0, s: 0));
                      },
                      onLongPress: () {
                        if (bloc.isDoubleClick == 1) return;
                        print("onLongPressDown");
                        bloc.add(MouseAction(x: 0, y: 0, c: 2, s: 0));
                        bloc.add(MouseAction(x: 0, y: 0, c: 0, s: 0));
                      },
                      onDoubleTapDown: (details) {
                        bloc.isClick = 1;
                        bloc.isDoubleClick = 1;
                      },
                      onDoubleTap: () {
                        print("onDoubleTap");
                        bloc.isClick = 0;
                        bloc.add(MouseAction(x: 0, y: 0, c: 1, s: 0));
                        bloc.add(MouseAction(x: 0, y: 0, c: 0, s: 0));
                        bloc.add(MouseAction(x: 0, y: 0, c: 1, s: 0));
                      },
                      onDoubleTapCancel: () {
                        bloc.add(MouseAction(x: 0, y: 0, c: 0, s: 0));
                      },
                      onScaleStart: (details) {
                        print('onScaleStart');
                        if (details.pointerCount == 2) {
                          bloc.oriDs = details.focalPoint.dy;
                        }
                        bloc.add(PointInital(
                            offset: details.focalPoint,
                            pointerCount: details.pointerCount));
                      },
                      onScaleUpdate: (details) {
                        print('onScaleUpdate');
                        if (details.pointerCount == 2) {
                          double fixDs = (bloc.oriDs - details.focalPoint.dy);

                          if (fixDs.abs() > 25) {
                            bloc.oriDs = details.focalPoint.dy;
                            bloc.scrollValList.add(fixDs);
                          }
                        } else {
                          bloc.add(MoveAction(
                              offset: details.focalPoint,
                              pointerCount: details.pointerCount));
                        }
                      },
                      onScaleEnd: (details) {
                        bloc.isClick = 0;
                        bloc.isDoubleClick = 0;
                        bloc.oriDs = 0;
                        bloc.add(MouseAction(x: 0, y: 0, c: 0, s: 0));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        color: Colors.cyan,
                        width: double.maxFinite,
                        height: context.height * 0.8,
                      ))
                ],
              );
            }

            List<Map<String, String>> devices = bloc.devices;
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
                              },
                              child: Text(devices[index]['name']!)),
                        );
                      }),
                    ),
                  ),
                )
              ],
            );
          },
        ));
  }
}
