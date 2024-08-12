import 'dart:async';

import '../bloc/bluetooth/bluet-bloc.dart';
import '../bloc/bluetooth/bluet-event.dart';

class SendDataClass {
  static final List<double> mScrollList = [];
  static final List<double> mXAxisList = [];
  static final List<double> mYAxisList = [];
  static final List<double> mClickList = [];
  static const Duration foling = Duration(microseconds: 2);
  static late BleBloc _bloc;
  static late final Timer _timer;

  static void process() {
    if (mScrollList.isEmpty &&
        mXAxisList.isEmpty &&
        mYAxisList.isEmpty &&
        mClickList.isEmpty) {
      return;
    }

    // _bloc.add(MouseAction(x: 0, y: 0, c: 0, s: 0));

    mScrollList.removeRange(0, mScrollList.length - 1);
    mXAxisList.removeRange(0, mScrollList.length - 1);
    mYAxisList.removeRange(0, mScrollList.length - 1);
    mClickList.removeRange(0, mScrollList.length - 1);
  }

  static void putS(double scroll) {
    mScrollList.add(scroll);
  }

  static void putX(double scroll) {
    mXAxisList.add(scroll);
  }

  static void putY(double scroll) {
    mYAxisList.add(scroll);
  }

  static void putC(double scroll) {
    mClickList.add(scroll);
  }

  void editScroll(List<double> scrolls) {}

  static void close() {
    _timer.cancel();
  }

  static void start(BleBloc bloc1) {
    _bloc = bloc1;
    _timer = Timer.periodic(foling, (timer) {
      process();
    });
  }
}
