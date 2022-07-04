import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../classes/line_point.dart';
import '../classes/tool.dart';

enum Tools { eraser, pencil }

class DrawerPanel with ChangeNotifier {
  final List<Color> _lineColors = [Colors.black, Colors.red, Colors.blue, Colors.yellow, Colors.green];
  final List<Color> _backgroundColors = [Colors.white, Colors.cyanAccent, Colors.deepOrangeAccent, Colors.limeAccent, Colors.lightGreen];
  final List<Tool> _toolList = [
    Tool(tool: Tools.pencil, srcUrl: 'assets/images/pencil.svg'),
    Tool(tool: Tools.eraser, srcUrl: 'assets/images/eraser.svg'),
  ];
  double? _lineSize = 5;
  int _lineColorSelected = 0;
  int _backgroundSelected = 0;
  int _toolSelected = 0;
  Offset? _pointerOffset = const Offset(0, 0);
  Tools _tools = Tools.pencil;
  List<LinePoint>? _points = [];
  List<List<LinePoint>> _strokesList = [];
  List<List<LinePoint>> _strokesHistory = [];
  ByteData? _pngImage;
  ui.Image? _pointerImage;
  ui.Picture? pointerPicture;

  // ui.Image get pointerImage {
  //   changeToolPicture();
  //
  //   return _pointerImage!;
  // }

  ByteData? get getImage {
    return _pngImage;
  }

  Offset? get pointerOffset {
    return _pointerOffset;
  }

  List<LinePoint>? get points {
    return _points!;
  }

  List<Color>? get getBackgroundColors {
    return _backgroundColors;
  }

  List<Color>? get getLineColors {
    return _lineColors;
  }

  List<Tool>? get getToolsList {
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

  set selectTool(Tools tool) {
    _tools = tool;
    notifyListeners();
  }

  // changeToolPicture() async {
  //   if (_tools == Tools.pencil) {
  //     PictureInfo pointer = await svg.svgPictureDecoder(
  //       await getImageFileFromAssets("pointers/pencil_pointer.svg"), // get the svg converted to
  //       true,                                                        // Uint8List to then decode it
  //       const ColorFilter.linearToSrgbGamma(),                       // as a PictureInfo
  //       UniqueKey().toString(),
  //     );
  //     _pointerImage = await pointer.picture!.toImage(70, 70); // get the property picture of
  //   }                                                         // pointer and convert it to Image
  //   notifyListeners();                                       //  or use only the picture property
  // }                                                          //  if needed

  convertCanvasToImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    if (_points!.isNotEmpty) {
      canvas.drawColor(selectedBackgroundColor, BlendMode.multiply);

      for (int i = 0; i < (points!.length - 1); i++) {

        if(points![i].tool == Tools.pencil) {

          if (points![i].point != null && points![i + 1].point != null) {
            canvas.drawLine(
                points![i].point!,
                points![i + 1].point!,
                Paint()
                  ..color = points![i].color!
                  ..strokeWidth = points![i].size!
            );
          }
          else if(points![i].point == null) {
            canvas.drawCircle(
                points![i - 1].point!,
                points![i - 1].size! / 2,
                Paint()
                  ..color = points![i - 1].color!
                  ..strokeWidth = points![i - 1].size!
            );
          }

        }
        else if (points![i].tool == Tools.eraser) {

          if (points![i].point != null && points![i + 1].point != null) {
            canvas.drawLine(
              points![i].point!,
              points![i + 1].point!,
              Paint()
                ..color = selectedBackgroundColor
                ..strokeWidth = points![i].size!
                ..strokeJoin = StrokeJoin.miter,
            );
          }
          else if(points![i].point == null) {
            canvas.drawCircle(
              points![i - 1].point!,
              points![i - 1].size! / 2,
              Paint()
                ..color = selectedBackgroundColor
                ..strokeWidth = points![i - 1].size!
                ..strokeJoin = StrokeJoin.miter,
            );
          }

        }

      }

      final picture = recorder.endRecording();
      ui.Image img = await picture.toImage(500, 500);
      _pngImage = await img.toByteData(format: ui.ImageByteFormat.png);
    }
  }

  void drawOnBoard(line) {
    if (selectedTool == Tools.pencil) {
      LinePoint? point = LinePoint(color: selectedLineColor, size: lineSize, point: line, tool: Tools.pencil);

      _points!.add(point);
      _pointerOffset = line;

      notifyListeners();
    } else if (selectedTool == Tools.eraser) {
      LinePoint? point = LinePoint(size: lineSize, point: line, tool: Tools.eraser);

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
    notifyListeners();
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

  Future<Uint8List> getImageFileFromAssets(String path) async {
    ByteData byteData = await rootBundle.load('assets/$path'); // 1. Obtain the svg image from the assets
    Uint8List image = byteData.buffer.asUint8List(             // 2. Convert the svg image to Uint8List
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
    return image;
  }

}
