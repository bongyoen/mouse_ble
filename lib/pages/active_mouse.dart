import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouse_ble/app_extensions.dart';

import '../bloc/bluetooth/bluet-bloc.dart';
import '../bloc/bluetooth/bluet-event.dart';

late BleBloc test;

class ActiveMouse extends StatefulWidget {
  const ActiveMouse({Key? key}) : super(key: key);

  @override
  State<ActiveMouse> createState() => _ActiveMouseState();
}

class _ActiveMouseState extends State<ActiveMouse> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BleBloc>();
    test = bloc;
    const double outMove = 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("bloctest"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('My Account'),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Settings'),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text('Logout'),
                ),
              ];
            },
            onSelected: (value) {
              if (value == 0) {
                print('My account menu is selected.');
              } else if (value == 1) {
                print('Settings menu is selected.');
              } else if (value == 2) {
                print('Logout menu is selected.');
              }
            },
          )
        ],
      ),
      body: Column(
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
                if (details.pointerCount == 2) {
                  double fixDs = (bloc.oriDs - details.focalPoint.dy);

                  if (fixDs.abs() > 25) {
                    bloc.oriDs = details.focalPoint.dy;
                    bloc.scrollValList.add(fixDs);
                  }
                } else {

                  final bool isOutXm =
                      details.focalPoint.dx > context.width * 0.9;
                  final bool isOutXp = details.focalPoint.dx < 30;
                  final bool isOutYp =
                      details.focalPoint.dy > context.height * 0.9;
                  final bool isOutYm = details.focalPoint.dy < 30;

                  if (isOutXp && isOutYp) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(outMove, outMove),
                        pointerCount: 1));
                  } else if (isOutXp && isOutYm) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(outMove, -outMove),
                        pointerCount: 1));
                  } else if (isOutXm && isOutYp) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(-outMove, outMove),
                        pointerCount: 1));
                  } else if (isOutXm && isOutYm) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(-outMove, -outMove),
                        pointerCount: 1));
                  } else if (isOutXp) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(outMove, 0),
                        pointerCount: 1));
                  } else if (isOutXm) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(-outMove, 0),
                        pointerCount: 1));
                  } else if (isOutYp) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(0, outMove),
                        pointerCount: 1));
                  } else if (isOutYm) {
                    bloc.add(OutMoveAction(
                        offset: const Offset(0, -outMove),
                        pointerCount: 1));
                  } else {
                    print(details.focalPoint);
                    bloc.add(MoveAction(
                        offset: details.focalPoint,
                        pointerCount: details.pointerCount));
                  }

                  // GestureDetector의 크기를 가져옵니다.
                  // final size = context.size;
                  // 드래그의 중심점을 가져옵니다.
                  // final focalPoint = details.localFocalPoint;
                  // 중심점이 영역을 벗어났는지를 판단합니다.
                  // final isXPOut = focalPoint.dx > (size!.width * 0.8);
                  // final isXMOut = focalPoint.dx < 50;
                  // final isYPOut = focalPoint.dy > (size.height * 0.8);
                  // final isYMOut = focalPoint.dy < 50;
                  // final isOutside = focalPoint.dx < 0 ||
                  //     focalPoint.dx > (size.width * 0.8) ||
                  //     focalPoint.dy < 0 ||
                  //     focalPoint.dy > (size.height * 0.8);
                  // 영역을 벗어났다면, 원하는 동작을 수행합니다.
                }
              },
              onScaleEnd: (details) {
                bloc.isClick = 0;
                bloc.isDoubleClick = 0;
                bloc.oriDs = 0;
                bloc.add(MouseAction(x: 0, y: 0, c: 0, s: 0));
              },
              child: Center(
                child: Container(
                  color: Colors.cyan,
                  width: context.width * 0.8,
                  height: context.height * 0.8,
                ),
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    test.add(GetDeviceList());
  }
}
