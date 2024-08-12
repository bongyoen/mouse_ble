import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouse_ble/bloc/bluetooth/bluet-event.dart';
import 'package:mouse_ble/bloc/bluetooth/bluet-state.dart';
import 'package:permission_handler/permission_handler.dart';


class BleBloc extends Bloc<BleEvent, BleState> {
  BleBloc() : super(BluetInital()) {
    initBond();
    on<AddDevice>(_addDevice);
    on<GetDeviceList>(_getDeviceList);
    on<Connected>(_connected);
    on<MouseAction>(_mouseAction);
    on<MoveAction>(_moveAction);
    on<OutMoveAction>(_outMoveAction);
    on<PointInital>(_pointInital);
    on<ReConnAction>(_reConnAction);
    on<DisConnAction>(_disConnAction);
    // SendDataClass.start(this);
    //
    // Timer(const Duration(seconds: 3), () {
    //   SendDataClass.close();
    // });
    // SendDataClass.putC(0);
  }

  List<Map<String, String>> _deviceList = [];

  List<Map<String, String>> get devices => _deviceList;

  double oriDx = 0;
  double oriDy = 0;
  double oriDs = 0;
  double isClick = 0;
  double isDoubleClick = 0;

  final platform = const MethodChannel('com.example.bonded_devices');

  String addr = "";
  var yVal = 10;
  List<double> scrollValList = [];

  Future<void> initBond() async {
    getBondedDevices().then((value) {
      _deviceList = value;
      print("test : $_deviceList");
      add(GetDeviceList());
    });
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.locationAlways,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.systemAlertWindow,
      Permission.notification,
    ].request();
    print(statuses[Permission.location]);

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (scrollValList.isNotEmpty && state is ConnectedState) {
        double fixds = scrollValList.reduce((value, element) {
          return value + element;
        });
        add(MouseAction(x: 0, y: 0, c: 0, s: fixds > 0 ? -1 : 1));
        scrollValList = [];
      }
    });
  }

  Future<void> conn(Map<String, String> device) async {
    platform.invokeMethod("conn", device).then((value) {
      String res = (value as String);

      if (res == "ok") add(Connected());
    });
  }

  FutureOr<void> _connected(Connected event, Emitter<BleState> emit) {
    emit(ConnectedState());
  }

  FutureOr<void> _getDeviceList(GetDeviceList event, Emitter<BleState> emit) {
    print("실행됬나?");
    emit(GetList(deviceList: _deviceList));
  }

  FutureOr<void> _addDevice(AddDevice event, Emitter<BleState> emit) {
    conn(event.device);
    return null;
  }

  Future<List<Map<String, String>>> getBondedDevices() async {
    try {
      List<Map<String, String>> res = [];
      List<dynamic> bondedDevices =
          await platform.invokeMethod('getBondedDevices');

      for (var val in bondedDevices) {
        Map<Object?, Object?> map = val as Map<Object?, Object?>;
        bool isStringMap =
            map.entries.every((e) => e.key is String && e.value is String);
        if (isStringMap) {
          Map<String, String> stringMap = {};
          map.forEach((k, v) {
            stringMap[k as String] = v as String;
          });
          res.add(stringMap);
        }
      }

      return res;
    } on PlatformException catch (e) {
      print('Failed to get bonded devices: ${e.message}');
      return [];
    }
  }

  FutureOr<void> _mouseAction(MouseAction event, Emitter<BleState> emit) {
    Map<String, double> map = {
      "c": event.c,
      "x": event.x,
      "y": event.y,
      "s": event.s,
    };
    platform.invokeMethod("mouse", map);
  }

  FutureOr<void> _moveAction(MoveAction event, Emitter<BleState> emit) {
    if (event.pointerCount == 1) {
      double dx = event.offset.dx;
      double dy = event.offset.dy;

      double fixDx = (oriDx - dx);
      double fixDy = (oriDy - dy) * -1;

      oriDx = dx;
      oriDy = dy;
      add(MouseAction(c: isClick, x: fixDx, y: fixDy, s: 0));
    } else if (event.pointerCount == 2) {
      double fixDs = (oriDs - event.offset.dy);
      oriDs = fixDs;
      scrollValList.add(fixDs);
      add(MouseAction(c: isClick, x: 0, y: 0, s: fixDs));
    }
  }

  FutureOr<void> _outMoveAction(OutMoveAction event, Emitter<BleState> emit) {
    double dx = event.offset.dx;
    double dy = event.offset.dy;
    add(MouseAction(c: isClick, x: dx, y: dy, s: 0));
  }

  FutureOr<void> _pointInital(PointInital event, Emitter<BleState> emit) {
    double dy = event.offset.dy;
    if (event.pointerCount == 1) {
      double dx = event.offset.dx;
      oriDx = dx;
      oriDy = dy;
    } else if (event.pointerCount == 2) {
      oriDs = dy;
    }
  }

  FutureOr<void> _reConnAction(ReConnAction event, Emitter<BleState> emit) {
    platform.invokeMethod("reConn", state is GetList ? false : true);
  }

  FutureOr<void> _disConnAction(DisConnAction event, Emitter<BleState> emit) {
    emit(GetList(deviceList: _deviceList));
    platform.invokeMethod("disConn").then((value) => {});
  }


}
