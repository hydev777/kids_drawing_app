import 'dart:ui';

import 'package:flutter/material.dart';

class Panel extends StatelessWidget {
  const Panel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    child: Text('Color'),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                        ),
                        margin: const EdgeInsets.all(5),
                        height: 30,
                        width: 30,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),
                        margin: const EdgeInsets.all(5),
                        height: 30,
                        width: 30,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue
                        ),
                        margin: const EdgeInsets.all(5),
                        height: 30,
                        width: 30,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow
                        ),
                        margin: const EdgeInsets.all(5),
                        height: 30,
                        width: 30,
                      )
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
  List<Offset> points = [];
  Offset? pencil = Offset(0, 0);

  drawOnBoard(line) {

    setState(() {
      points.add(line);
    });

    setState(() {
      pencil = line;
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {

        drawOnBoard(details.localPosition);

      },
      onPanUpdate: (details) {

        drawOnBoard(details.localPosition);

      },
      child: CustomPaint(
        painter: Board(pencil: pencil, points: points, backgroundColor: Colors.white, lineColor: Colors.black, lineSize: 5),
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