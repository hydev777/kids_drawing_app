import 'package:flutter/material.dart';

import '../classes/line_point.dart';

enum Tools { eraser, pencil }

class DrawerPanel with ChangeNotifier {
  final List<Color>? _lineColors = [Colors.black, Colors.red, Colors.blue, Colors.yellow, Colors.green];
  final List<Color>? _backgroundColors = [Colors.white, Colors.cyanAccent, Colors.deepOrangeAccent, Colors.limeAccent, Colors.lightGreen];
  double? _lineSize = 5;
  int _lineColorSelected = 0;
  int _backgroundSelected = 0;
  Offset? _pencil = const Offset(0, 0);
  Tools _tools = Tools.pencil;
  List<LinePoint> _points = [];
  List<List<LinePoint>> _strokesList = [];
  List<List<LinePoint>> _strokesHistory = [];

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

  Tools get selectedTool {
    return _tools;
  }

  set changeLineSize(double size) {
    _lineSize = size;
    notifyListeners();
  }

  set changeLineColor(Color color) {
    if (_lineColors!.contains(color)) {
      int index = _lineColors!.indexOf(color);
      _lineColorSelected = index;
      notifyListeners();
    }
  }

  set changeBackgroundColor(Color color) {
    if (_backgroundColors!.contains(color)) {
      int index = _backgroundColors!.indexOf(color);
      _backgroundSelected = index;
      notifyListeners();
    }
  }

  set selectTool(Tools tool) {
    _tools = tool;
    notifyListeners();
  }

  void drawOnBoard(Offset line) {

    if(_tools == Tools.pencil) {

      LinePoint? point = LinePoint(color: selectedLineColor, size: lineSize, point: line, tool: Tools.pencil);

      _points.add(point);
      _pencil = line;

      notifyListeners();

    } else if(_tools == Tools.eraser) {

      LinePoint? point = LinePoint(size: lineSize, point: line, tool: Tools.eraser);

      _points.add(point);
      _pencil = line;

      notifyListeners();

    }


  }

  void cleanBoard() {
    _points = [];
    _strokesList = [];
    _strokesHistory = [];
    _pencil = const Offset(0, 0);
    notifyListeners();
  }

  void copyStrokeListToPoints() {
    _points = [];

    for (List<LinePoint> strokeList in _strokesList) {
      for (LinePoint linePoint in strokeList) {
        _points.add(linePoint);
      }
    }

    notifyListeners();
  }

  void addStrokeHistory(List<LinePoint> stroke) {
    _strokesList.add(stroke);

    copyStrokeListToPoints();
  }

  void undoStroke() {
    if (_strokesList.isNotEmpty) {
      List<LinePoint>? stroke = _strokesList.removeLast();

      _strokesHistory.add(stroke);

      copyStrokeListToPoints();
    }
  }

  void redoStroke() {
    if (_strokesHistory.isNotEmpty) {
      _strokesList.add(_strokesHistory.removeLast());

      copyStrokeListToPoints();
    }
  }
}
