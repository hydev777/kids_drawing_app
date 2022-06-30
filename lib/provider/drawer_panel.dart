import 'dart:ui' as ui;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../classes/line_point.dart';
import '../classes/tool.dart';

enum Tools { eraser, pencil }

class DrawerPanel with ChangeNotifier {

  final List<Color> _lineColors = [Colors.black, Colors.red, Colors.blue, Colors.yellow, Colors.green];
  final List<Color> _backgroundColors = [Colors.white, Colors.cyanAccent, Colors.deepOrangeAccent, Colors.limeAccent, Colors.lightGreen];
  final List<Tool> _toolList = [
    Tool( tool: Tools.pencil, srcUrl: 'assets/images/pencil.svg' ),
    Tool( tool: Tools.eraser, srcUrl: 'assets/images/eraser.svg' ),
  ];
  double? _lineSize = 5;
  int _lineColorSelected = 0;
  int _backgroundSelected = 0;
  int _toolSelected = 0;
  Offset? _pencil = const Offset(0, 0);
  Tools _tools = Tools.pencil;
  List<LinePoint> _points = [];
  List<List<LinePoint>> _strokesList = [];
  List<List<LinePoint>> _strokesHistory = [];
  ByteData? pngImage;
  File? image;
  ui.Image? pointerImage;
  ui.Picture? pointerPicture;
  bool showImage = false;

  ByteData? get getImage {

    return pngImage;

  }

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

  convertCanvasToImage() async {

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    if(_points.isNotEmpty) {

      canvas.drawColor(selectedBackgroundColor, BlendMode.multiply);

      for (var point in points) {
        if (point.tool == Tools.pencil) {
          canvas.drawPoints(
            ui.PointMode.points,
            [point.point!],
            Paint()
              ..color = point.color!
              ..strokeWidth = point.size!
              ..strokeJoin = StrokeJoin.miter,
          );
        }
        else if (point.tool == Tools.eraser) {
          canvas.drawPoints(
            ui.PointMode.points,
            [point.point!],
            Paint()
              ..color = selectedBackgroundColor
              ..strokeWidth = point.size!
              ..strokeJoin = StrokeJoin.miter,
          );
        }
      }

      final picture = recorder.endRecording();
      ui.Image img = await picture.toImage(500, 500);
      pngImage = await img.toByteData( format: ui.ImageByteFormat.png );

    }

  }

  void drawOnBoard(Offset line) {

    if(selectedTool == Tools.pencil) {

      LinePoint? point = LinePoint(color: selectedLineColor, size: lineSize, point: line, tool: Tools.pencil);

      _points.add(point);
      _pencil = line;

      notifyListeners();

    }
    else if(selectedTool == Tools.eraser) {

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

  void testPointer() async {

    image = await getImageFileFromAssets("pointers/pencil_pointer.svg");
    showImage = true;

    PictureInfo pointer = await svg.svgPictureDecoder(image!.readAsBytesSync(), true, const ColorFilter.linearToSrgbGamma(), UniqueKey().toString());

    pointerImage = await pointer.picture!.toImage(70, 70);

    notifyListeners();

    print({
      image!.path,
      image!.absolute,
      image!.parent,
      image!.uri,
    });

  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    // final file = File('${(await getTemporaryDirectory()).path}/$path');
    File file = await  File('${(await getTemporaryDirectory()).path}/pencil_pointer.svg').create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

}
