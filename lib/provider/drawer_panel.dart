import 'package:flutter/material.dart';

import '../classes/line_point.dart';

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

  Offset? _pencil = Offset(0, 0);

  List<LinePoint> _points = [];

  Offset? get pencil {

    return _pencil;

  }

  List<LinePoint> get points {
    return _points;
  }

  List<Color>? get getBackgroundColors {
    return _backgroundColors;
  }

  List<Color>? get getLineColors {
    return _lineColors;
  }

  Color get selectedLineColor {
    return _lineColors![_lineColorSelected];
  }

  Color get selectedBackgroundColor {
    return _backgroundColors![_backgroundSelected];
  }

  double? get lineSize {
    return _lineSize;
  }

  set changeLineSize(double size) {

    _lineSize = size;
    notifyListeners();

  }

  set changeLineColor(Color color) {

    if(_lineColors!.contains(color)) {
      int index = _lineColors!.indexOf(color);
      _lineColorSelected = index;
      notifyListeners();
    }

  }

  set changeBackgroundColor(Color color) {

    if(_backgroundColors!.contains(color)) {
      int index = _backgroundColors!.indexOf(color);
      _backgroundSelected = index;
      notifyListeners();
    }

  }

  void drawOnBoard(Offset line) {

    LinePoint? point = LinePoint( color: selectedLineColor, point: line );

    _points.add(point);
    _pencil = line;
    notifyListeners();

  }

  void cleanBoard() {

    _points = [];
    notifyListeners();

  }

}