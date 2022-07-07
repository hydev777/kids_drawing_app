import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../classes/line_point.dart';
import '../../../provider/drawer_panel.dart';
import '../board/board.dart';

class Draw extends StatefulWidget {
  const Draw({Key? key}) : super(key: key);

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  List<LinePoint> stroke = [];

  @override
  Widget build(BuildContext context) {
    Color selectedBackgroundColor = Provider.of<DrawerPanel>(context).selectedBackgroundColor;
    Color selectedLineColor = Provider.of<DrawerPanel>(context).selectedLineColor;
    double? lineSize = Provider.of<DrawerPanel>(context).lineSize;
    List<LinePoint>? points = Provider.of<DrawerPanel>(context).points;
    Offset? pointerOffset = Provider.of<DrawerPanel>(context).pointerOffset;
    Tools selectedTool = Provider.of<DrawerPanel>(context).selectedTool;
    // ui.Image pointerImage = Provider.of<DrawerPanel>(context).pointerImage;
    final drawActions = Provider.of<DrawerPanel>(context);

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
          painter: Board(
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
