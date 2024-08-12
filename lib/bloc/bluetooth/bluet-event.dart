import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class BleEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddDevice extends BleEvent {
  final Map<String, String> device;

  AddDevice({required this.device});
}

class GetDeviceList extends BleEvent {}

class SendData extends BleEvent {}

class Connected extends BleEvent {}

class MouseAction extends BleEvent {
  final double c;
  final double x;
  final double y;
  final double s;

  MouseAction({required this.c, required this.x, required this.y, required this.s});
}

class MoveAction extends BleEvent {
  final Offset offset;
  final int pointerCount;

  MoveAction({required this.offset,required this.pointerCount});
}
class OutMoveAction extends BleEvent {
  final Offset offset;
  final int pointerCount;

  OutMoveAction({required this.offset, required this.pointerCount});

}

class PointInital extends BleEvent {
  final Offset offset;
  final int pointerCount;

  PointInital({required this.offset, required this.pointerCount});
}

class ReConnAction extends BleEvent {}

class DisConnAction extends BleEvent {}


