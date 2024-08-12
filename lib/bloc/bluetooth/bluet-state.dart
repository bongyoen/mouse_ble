import 'package:equatable/equatable.dart';

abstract class BleState {}

class BluetInital extends BleState {}

class GetList extends BleState {
  final List<Map<String, String>> deviceList;

  GetList({required this.deviceList});
}

class ConnectedState extends BleState {}
class DisConnectedState extends BleState {}