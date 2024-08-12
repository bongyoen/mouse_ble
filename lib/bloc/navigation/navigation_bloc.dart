import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouse_ble/bloc/bluetooth/bluet-bloc.dart';

import '../bluetooth/bluet-event.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc(this.bleBloc) : super(SearchBlePageState()) {

    on<GoToSearchBlePageEvent>(_goToSearchBlePageEvent);
    on<GoToActiveBlePageEvent>(_goToActiveBlePageEvent);
  }

  final BleBloc bleBloc;

  FutureOr<void> _goToSearchBlePageEvent(GoToSearchBlePageEvent event, Emitter<NavigationState> emit) {
    print("FirstPageState");
    bleBloc.add(DisConnAction());
    emit(SearchBlePageState());
  }

  FutureOr<void> _goToActiveBlePageEvent(GoToActiveBlePageEvent event, Emitter<NavigationState> emit) {
    print("SecondPageState");
    emit(ActiveBlePageState());
  }
}
