import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../classes/line_point.dart';
import '../../../provider/drawer_panel.dart';

class Board extends CustomPainter {
  List<LinePoint>? points;
  Color? backgroundColor;
  ui.Image? pointerImage;
  Offset? pointerOffset;

  Board({
    this.points,
    this.backgroundColor,
    this.pointerImage,
    this.pointerOffset,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(backgroundColor!, BlendMode.multiply);

    // canvas.drawImage(pointerImage!, pointerOffset!, Paint());

    for (int i = 0; i < (points!.length - 1); i++) {

      if (points![i].point != null && points![i + 1].point != null) {
        canvas.drawLine(
          points![i].point!,
          points![i + 1].point!,
          Paint()
            ..color = points![i].color!
            ..strokeWidth = points![i].size!
            ..strokeJoin = StrokeJoin.miter,
        );
      } else {
        canvas.drawCircle(
          points![i - 1].point!,
          Paint().strokeWidth / 2,
          Paint()
            ..color = points![i - 1].color!
            ..strokeWidth = points![i - 1].size!
            ..strokeJoin = StrokeJoin.miter,
        );
      }
    }

    // for (var point in points!) {
    //   if (point.tool == Tools.pencil) {
    //
    //     canvas.drawPoints(
    //       ui.PointMode.points,
    //       [point.point!],
    //       Paint()
    //         ..color = point.color!
    //         ..strokeWidth = point.size!
    //         ..strokeJoin = StrokeJoin.miter,
    //     );
    //   }
    //   else if (point.tool == Tools.eraser) {
    //     canvas.drawPoints(
    //       ui.PointMode.points,
    //       [point.point!],
    //       Paint()
    //         ..color = backgroundColor!
    //         ..strokeWidth = point.size!
    //         ..strokeJoin = StrokeJoin.miter,
    //     );
    //   }
    // }

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
