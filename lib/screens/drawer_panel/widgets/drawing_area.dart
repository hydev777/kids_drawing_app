import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/line_point.dart';
import '../provider/drawer_panel.dart';
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
        context.watch<DrawerPanel>().selectedBackgroundColor;
    Color selectedLineColor = context.watch<DrawerPanel>().selectedLineColor;
    double? lineSize = context.watch<DrawerPanel>().lineSize;
    List<LinePoint>? points = context.watch<DrawerPanel>().points;
    Offset? pointerOffset = context.watch<DrawerPanel>().pointerOffset;
    Tools selectedTool = context.watch<DrawerPanel>().selectedTool;
    final drawActions = context.read<DrawerPanel>();

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
