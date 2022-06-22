import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/drawer_panel.dart';

class Panel extends StatelessWidget {
  const Panel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Color>? lineColors = Provider.of<DrawerPanel>(context).getLineColors;
    List<Color>? backgroundColor = Provider.of<DrawerPanel>(context).getBackgroundColors;
    final panelActions = Provider.of<DrawerPanel>(context);

    return Scaffold(
      body: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            child: Text('Actions'),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black)
                                  ),
                                  margin: const EdgeInsets.all(4),
                                  height: 30,
                                  width: 30,
                                  child: const Icon(Icons.create),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black)
                                  ),
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
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black)
                                  ),
                                  margin: const EdgeInsets.all(4),
                                  height: 30,
                                  width: 30,
                                  child: const Icon(Icons.delete),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.black)
                                  ),
                                  margin: const EdgeInsets.all(4),
                                  height: 30,
                                  width: 30,
                                  child: const Icon(Icons.share),
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color,
                                        border: Border.all(color: Colors.black)
                                    ),
                                    margin: const EdgeInsets.all(4),
                                    height: 25,
                                    width: 25,
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

                              ...backgroundColor!.map((color) {

                                return GestureDetector(
                                  onTap: () {
                                    panelActions.changeBackgroundColor = color;
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: color,
                                        border: Border.all(color: Colors.black)
                                    ),
                                    margin: const EdgeInsets.all(4),
                                    height: 25,
                                    width: 25,
                                  ),
                                );

                              }).toList(),

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
          ]
      ),
    );
  }
}

class Draw extends StatefulWidget {
  const Draw({Key? key}) : super(key: key);

  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  // List<Offset> points = [];
  Offset? pencil = Offset(0, 0);

  // drawOnBoard(line) {
  //
  //   setState(() {
  //     points.add(line);
  //   });
  //
  //   setState(() {
  //     pencil = line;
  //   });
  //
  // }

  @override
  Widget build(BuildContext context) {

    Color selectedLineColor = Provider.of<DrawerPanel>(context).selectedLineColor;
    Color selectedBackgroundColor = Provider.of<DrawerPanel>(context).selectedBackgroundColor;
    double? lineSize = Provider.of<DrawerPanel>(context).lineSize;
    List<Offset> points = Provider.of<DrawerPanel>(context).points;
    final drawActions = Provider.of<DrawerPanel>(context);

    return GestureDetector(
      onPanStart: (details) {

        drawActions.drawOnBoard(details.localPosition);
        // drawOnBoard();

      },
      onPanUpdate: (details) {

        drawActions.drawOnBoard(details.localPosition);
        // drawOnBoard(details.localPosition);

      },
      child: CustomPaint(
        painter: Board(pencil: pencil, points: points, backgroundColor: selectedBackgroundColor, lineColor: selectedLineColor, lineSize: lineSize),
      ),
    );
  }
}

class Board extends CustomPainter {
  final points;
  Offset? pencil;
  Color? lineColor;
  Color? backgroundColor;
  double? lineSize;

  Board({this.pencil, this.points, this.lineColor, this.backgroundColor, this.lineSize}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = lineColor!..strokeWidth = lineSize!;

    canvas.drawColor(backgroundColor!, BlendMode.multiply);

    // for(var line = 0; line < points!.length; line++) {
    //
    //   canvas.drawCircle(points![line], 5, Paint()..color = Colors.white..strokeWidth = 5);
    //
    // }

    for(var point in points) {

      canvas.drawPoints(
        PointMode.points,
        [point],
        paint,
      );

    }

    //   canvas.drawCircle(points![line], 5, Paint()..color = Colors.white..strokeWidth = 5);

    // for(var line = 0; line < points!.length; line++) {
    //
    //   canvas.drawPoints(
    //     PointMode.lines,
    //     [points![line]],
    //     Paint()..color = Colors.amber
    //     ..strokeWidth = 10,
    //   );
    //
    // }

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}