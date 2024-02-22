import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/enums/enums.dart';
import '../classes/classes.dart';

class DrawerProvider with ChangeNotifier {
  final List<Color> _lineColors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green
  ];
  final List<Color> _backgroundColors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green
  ];
  final List<Tool> _toolList = [
    Tool(tool: Tools.pencil, srcUrl: 'assets/images/pencil.svg'),
    Tool(tool: Tools.eraser, srcUrl: 'assets/images/eraser.svg'),
  ];
  double? _lineSize = 5;
  int _lineColorSelected = 1;
  int _backgroundSelected = 0;
  int _toolSelected = 0;
  Offset? _pointerOffset = const Offset(0, 0);
  List<LinePoint>? _points = [];
  List<List<LinePoint>> _strokesList = [];
  List<List<LinePoint>> _strokesHistory = [];

  Offset? get pointerOffset {
    return _pointerOffset;
  }

  List<LinePoint>? get points {
    return _points!;
  }

  List<Color>? get backgroundColors {
    return _backgroundColors;
  }

  List<Color>? get lineColors {
    return _lineColors;
  }

  List<Tool>? get toolList {
    return _toolList;
  }

  Color get selectedLineColor {
    return _lineColors[_lineColorSelected];
  }

  Color get selectedBackgroundColor {
    return _backgroundColors[_backgroundSelected];
  }

  Tools get selectedTool {
    return _toolList[_toolSelected].tool!;
  }

  double? get lineSize {
    return _lineSize;
  }

  set changeToolSelected(Tool tool) {
    if (_toolList.contains(tool)) {
      int index = _toolList.indexOf(tool);
      _toolSelected = index;
      notifyListeners();
    }
  }

  set changeLineSize(double size) {
    _lineSize = size;
    notifyListeners();
  }

  set changeLineColor(Color color) {
    if (_lineColors.contains(color)) {
      int index = _lineColors.indexOf(color);
      _lineColorSelected = index;
      notifyListeners();
    }
  }

  set changeBackgroundColor(Color color) {
    if (_backgroundColors.contains(color)) {
      int index = _backgroundColors.indexOf(color);
      _backgroundSelected = index;
      notifyListeners();
    }
  }

  void drawOnBoard(line) {
    if (selectedTool == Tools.pencil) {
      LinePoint? point = LinePoint(
          color: selectedLineColor,
          size: lineSize,
          point: line,
          tool: Tools.pencil);

      _points!.add(point);
      _pointerOffset = line;

      notifyListeners();
    } else if (selectedTool == Tools.eraser) {
      LinePoint? point =
          LinePoint(size: lineSize, point: line, tool: Tools.eraser);

      _points!.add(point);
      _pointerOffset = line;

      notifyListeners();
    }
  }

  void cleanBoard() {
    _points = [];
    _strokesList = [];
    _strokesHistory = [];
    _pointerOffset = const Offset(0, 0);

    _lineSize = 5;
    _lineColorSelected = 0;
    _backgroundSelected = 0;

    notifyListeners();
  }

  void newPaint() {
    if (_points!.isNotEmpty) {
      _points = [];
      _strokesList = [];
      _strokesHistory = [];
      _pointerOffset = const Offset(0, 0);

      _lineSize = 5;
      _lineColorSelected = 1;
      _backgroundSelected = 0;

      changeToolSelected = Tool(
        tool: Tools.pencil,
        srcUrl: 'assets/images/pencil.svg',
      );

      notifyListeners();
    }
  }

  void copyStrokeListToPoints() {
    _points = [];

    for (List<LinePoint> strokeList in _strokesList) {
      for (LinePoint linePoint in strokeList) {
        _points!.add(linePoint);
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

  Future<ByteData?> convertCanvasToImage() async {
    if (_points!.isNotEmpty) {
      ByteData? pngImage;
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder);

      canvas.drawColor(selectedBackgroundColor, BlendMode.multiply);

      for (int i = 0; i < (_points!.length - 1); i++) {
        if (_points![i].tool == Tools.pencil) {
          if (_points![i].point != null && _points![i + 1].point != null) {
            canvas.drawLine(
                _points![i].point!,
                _points![i + 1].point!,
                Paint()
                  ..color = _points![i].color!
                  ..strokeWidth = _points![i].size!);
          } else if (points![i].point == null && points![i + 1].point == null) {
            canvas.drawCircle(
                _points![i].point!,
                _points![i].size! / 2,
                Paint()
                  ..color = _points![i - 1].color!
                  ..strokeWidth = _points![i - 1].size!);
          }
        } else if (_points![i].tool == Tools.eraser) {
          if (_points![i].point != null && _points![i + 1].point != null) {
            canvas.drawLine(
              _points![i].point!,
              _points![i + 1].point!,
              Paint()
                ..color = selectedBackgroundColor
                ..strokeWidth = _points![i].size!
                ..strokeJoin = StrokeJoin.miter,
            );
          } else if (points![i].point == null && points![i + 1].point == null) {
            canvas.drawCircle(
              _points![i].point!,
              _points![i].size! / 2,
              Paint()
                ..color = selectedBackgroundColor
                ..strokeWidth = _points![i - 1].size!
                ..strokeJoin = StrokeJoin.miter,
            );
          }
        }
      }

      ui.Picture picture = recorder.endRecording();
      ui.Image img = await picture.toImage(500, 500);
      pngImage = await img.toByteData(format: ui.ImageByteFormat.png);
      return pngImage;
    } else {
      return ByteData(0);
    }
  }

  Future<Uint8List> getImageFileFromAssets(String path) async {
    ByteData byteData = await rootBundle.load('assets/$path');
    Uint8List image = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
    return image;
  }
}
