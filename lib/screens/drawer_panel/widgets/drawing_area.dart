import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/enums.dart';
import '../classes/classes.dart';
import '../provider/provider.dart';
import 'drawing_board.dart';

class DrawingArea extends StatefulWidget {
  const DrawingArea({Key? key}) : super(key: key);

  @override
  State<DrawingArea> createState() => _DrawingAreaState();
}

class _DrawingAreaState extends State<DrawingArea> {
  List<LinePoint> stroke = [];

  @override
  Widget build(BuildContext context) {
    Color selectedBackgroundColor =
        context.watch<DrawerProvider>().selectedBackgroundColor;
    Color selectedLineColor = context.watch<DrawerProvider>().selectedLineColor;
    double? lineSize = context.watch<DrawerProvider>().lineSize;
    List<LinePoint>? points = context.watch<DrawerProvider>().points;
    Offset? pointerOffset = context.watch<DrawerProvider>().pointerOffset;
    Tools selectedTool = context.watch<DrawerProvider>().selectedTool;
    final drawActions = context.read<DrawerProvider>();

    setStroke(Offset position) {
      if (selectedTool == Tools.pencil) {
        stroke.add(
          LinePoint(
            point: position,
            color: selectedLineColor,
            size: lineSize,
            tool: Tools.pencil,
          ),
        );
      } else if (selectedTool == Tools.eraser) {
        stroke.add(
          LinePoint(
            point: position,
            size: lineSize,
            tool: Tools.eraser,
          ),
        );
      }
    }

    return GestureDetector(
      onPanStart: (details) {
        drawActions.drawOnBoard(details.localPosition);
        setStroke(details.localPosition);
      },
      onPanUpdate: (details) {
        drawActions.drawOnBoard(details.localPosition);
        setStroke(details.localPosition);
      },
      onPanEnd: (details) {
        drawActions.drawOnBoard(null);
        stroke.add(
          LinePoint(
            point: null,
            size: lineSize,
            tool: Tools.eraser,
          ),
        );
        drawActions.addStrokeHistory([...stroke]);
        stroke = [];
      },
      child: ClipRect(
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: DrawingBoard(
            pointerOffset: pointerOffset,
            points: points,
            backgroundColor: selectedBackgroundColor,
            // pointerImage: pointerImage
          ),
        ),
      ),
    );
  }
}
