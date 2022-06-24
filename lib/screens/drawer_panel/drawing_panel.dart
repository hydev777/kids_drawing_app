import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/drawer_panel.dart';
import '../../classes/line_point.dart';

class Panel extends StatelessWidget {
  const Panel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Color>? lineColors = Provider.of<DrawerPanel>(context).getLineColors;
    List<Color>? backgroundColors = Provider.of<DrawerPanel>(context).getBackgroundColors;
    Color? selectedBackgroundColor = Provider.of<DrawerPanel>(context).selectedBackgroundColor;
    Color? selectedLineColor = Provider.of<DrawerPanel>(context).selectedLineColor;
    double? lineSize = Provider.of<DrawerPanel>(context).lineSize;
    final panelActions = Provider.of<DrawerPanel>(context);

    return Scaffold(
      body: Column(children: [
        Container(
          height: 150,
          width: double.infinity,
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Text('Actions'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                              margin: const EdgeInsets.all(4),
                              height: 30,
                              width: 30,
                              child: const Icon(Icons.create),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                              margin: const EdgeInsets.all(4),
                              height: 30,
                              width: 30,
                              child: const Icon(Icons.save),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              panelActions.cleanBoard();
                            },
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                              margin: const EdgeInsets.all(4),
                              height: 30,
                              width: 30,
                              child: const Icon(Icons.delete),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                              margin: const EdgeInsets.all(4),
                              height: 30,
                              width: 30,
                              child: const Icon(Icons.share),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              panelActions.undoStroke();
                            },
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                              margin: const EdgeInsets.all(4),
                              height: 30,
                              width: 30,
                              child: const Icon(Icons.undo),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              panelActions.redoStroke();
                            },
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                              margin: const EdgeInsets.all(4),
                              height: 30,
                              width: 30,
                              child: const Icon(Icons.redo),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Text('Line'),
                      ),
                      Row(
                        children: [
                          ...lineColors!.map((color) {
                            return GestureDetector(
                              onTap: () {
                                panelActions.changeLineColor = color;
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                  border: selectedLineColor == color
                                      ? Border.all(color: color == Colors.black ? Colors.white : Colors.black, width: 3)
                                      : Border.all(color: color),
                                ),
                                margin: const EdgeInsets.all(4),
                                height: selectedLineColor == color ? 30 : 25,
                                width: selectedLineColor == color ? 30 : 25,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Text('Background'),
                      ),
                      Row(
                        children: [
                          ...backgroundColors!.map((color) {
                            return GestureDetector(
                              onTap: () {
                                panelActions.changeBackgroundColor = color;
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: color,
                                  border: selectedBackgroundColor == color ? Border.all(color: Colors.black, width: 3) : Border.all(color: color),
                                ),
                                margin: const EdgeInsets.all(4),
                                height: selectedBackgroundColor == color ? 30 : 25,
                                width: selectedBackgroundColor == color ? 30 : 25,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Text('Font Size'),
                      ),
                      Row(
                        children: [
                          Slider(
                            value: lineSize!,
                            onChanged: (newSize) {
                              panelActions.changeLineSize = newSize;
                            },
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: "$lineSize",
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 150,
          child: const Draw(),
        ),
      ]),
    );
  }
}

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
    List<LinePoint> points = Provider.of<DrawerPanel>(context).points;
    Offset? pencil = Provider.of<DrawerPanel>(context).pencil;
    final drawActions = Provider.of<DrawerPanel>(context);

    return GestureDetector(
      onPanStart: (details) {
        drawActions.drawOnBoard(details.localPosition);
        stroke.add(LinePoint(point: details.localPosition, color: selectedLineColor, size: lineSize));
      },
      onPanUpdate: (details) {
        drawActions.drawOnBoard(details.localPosition);
        stroke.add(LinePoint(point: details.localPosition, color: selectedLineColor, size: lineSize));
      },
      onPanEnd: (details) {
        drawActions.addStrokeHistory([...stroke]);
        stroke = [];
      },
      child: CustomPaint(
        painter: Board(
          pencil: pencil,
          points: points,
          backgroundColor: selectedBackgroundColor,
          lineSize: lineSize,
        ),
      ),
    );
  }
}

class Board extends CustomPainter {
  List<LinePoint>? points;
  Offset? pencil;
  Color? backgroundColor;
  double? lineSize;

  Board({this.pencil, this.points, this.backgroundColor, this.lineSize}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(backgroundColor!, BlendMode.multiply);

    for (var point in points!) {
      canvas.drawPoints(
          PointMode.points,
          [point.point!],
          Paint()
            ..color = point.color!
            ..strokeWidth = point.size!
            ..strokeJoin = StrokeJoin.miter);
    }

    canvas.drawCircle(
      pencil!,
      5,
      Paint()
        ..color = Colors.purple
        ..strokeWidth = 5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
