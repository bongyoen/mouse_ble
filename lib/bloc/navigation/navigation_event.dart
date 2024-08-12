import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable{}
class GoToSearchBlePageEvent extends NavigationEvent {
  @override
  List<Object?> get props => [];
}

class GoToActiveBlePageEvent extends NavigationEvent {
  @override
  List<Object?> get props => [];
}