import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../classes/line_point.dart';
import '../../../provider/drawer_panel.dart';

class Board extends CustomPainter {
  List<LinePoint>? points;
  ui.Image? pointer;
  Offset? pointerOffset;
  Offset? pencil;
  Color? backgroundColor;

  Board({
    this.pencil,
    this.points,
    this.backgroundColor,
    this.pointer,
    this.pointerOffset,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(backgroundColor!, BlendMode.multiply);

    for (var point in points!) {
      if (point.tool == Tools.pencil) {
        canvas.drawPoints(
          ui.PointMode.points,
          [point.point!],
          Paint()
            ..color = point.color!
            ..strokeWidth = point.size!
            ..strokeJoin = StrokeJoin.miter,
        );
      } else if (point.tool == Tools.eraser) {
        canvas.drawPoints(
          ui.PointMode.points,
          [point.point!],
          Paint()
            ..color = backgroundColor!
            ..strokeWidth = point.size!
            ..strokeJoin = StrokeJoin.miter,
        );
      }
    }

    // canvas.drawImage(pointer!, pointerOffset!, Paint());

    // canvas.drawCircle(
    //   pencil!,
    //   5,
    //   Paint()
    //     ..color = Colors.purple
    //     ..strokeWidth = 5,
    // );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
