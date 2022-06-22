import 'package:flutter/material.dart';

class DrawerPanel with ChangeNotifier {

  final List<Color>? _lineColors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green
  ];
  final List<Color>? _backgroundColors = [

    Colors.white10,
    Colors.cyanAccent,
    Colors.deepOrangeAccent,
    Colors.limeAccent,
    Colors.lightGreen

  ];
  double? _lineSize = 2;
  int _lineColorSelected = 0;
  int _backgroundSelected = 0;

  Color get selectedLineColor {
    return _lineColors![_lineColorSelected];
  }

  Color get selectedBackgroundColor {
    return _backgroundColors![_backgroundSelected];
  }

  set changeLineSize(double size) {

    _lineSize = size;
    notifyListeners();

  }

  set changeLineColor(int index) {

    if(index < _lineColors!.length) {
      _lineColorSelected = index;
      notifyListeners();
    }

  }

  set changeBackgroundColor(int index) {

    if(index < _backgroundColors!.length) {
      _backgroundSelected = index;
      notifyListeners();
    }

  }


}