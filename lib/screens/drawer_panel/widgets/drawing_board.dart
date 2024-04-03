import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classes/classes.dart';
import '../../../core/enums/enums.dart';

class DrawingBoard extends CustomPainter {
  ValueNotifier<ui.Image>? image;
  List<LinePoint>? points;
  Color? backgroundColor;
  Offset? pointerOffset;

  DrawingBoard({
    this.image,
    this.points,
    this.backgroundColor,
    this.pointerOffset,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(backgroundColor!, BlendMode.multiply);

    // TODO: Add Shader pencil options

    // image != null
    //     ? canvas.drawImage(
    //         image!.value,
    //         Offset(size.width / 2, size.height / 2),
    //         Paint()..color = Colors.black,
    //       )
    //     : canvas;

    for (int i = 0; i < (points!.length - 1); i++) {
      if (points![i].tool == Tools.pencil) {
        if (points![i].point != null && points![i + 1].point != null) {
          canvas.drawLine(
              points![i].point!,
              points![i + 1].point!,
              Paint()
                ..color = points![i].color!
                ..strokeWidth = points![i].size!);
        } else if (points![i].point == null && points![i + 1].point == null) {
          canvas.drawCircle(
              points![i].point!,
              points![i].size! / 2,
              Paint()
                ..color = points![i - 1].color!
                ..strokeWidth = points![i - 1].size!);
        }
      } else if (points![i].tool == Tools.eraser) {
        if (points![i].point != null && points![i + 1].point != null) {
          canvas.drawLine(
            points![i].point!,
            points![i + 1].point!,
            Paint()
              ..color = backgroundColor!
              ..strokeWidth = points![i].size!
              ..strokeJoin = StrokeJoin.miter,
          );
        } else if (points![i].point == null && points![i + 1].point == null) {
          canvas.drawCircle(
            points![i].point!,
            points![i].size! / 2,
            Paint()
              ..color = backgroundColor!
              ..strokeWidth = points![i - 1].size!
              ..strokeJoin = StrokeJoin.miter,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
