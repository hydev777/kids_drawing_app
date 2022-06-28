import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../classes/tool.dart';
import '../../provider/drawer_panel.dart';
import '../../classes/line_point.dart';
import '../view_image/view_image.dart';

class Panel extends StatefulWidget {
  const Panel({Key? key}) : super(key: key);

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  Color? sizeSelectorColor;
  final recorder = ui.PictureRecorder();
  ui.Canvas? canvas;

  void changeSizeSelectorColor() {
    Tools? selectedTool = Provider.of<DrawerPanel>(context, listen: false).selectedTool;
    Color? selectedBackgroundColor = Provider.of<DrawerPanel>(context, listen: false).selectedBackgroundColor;
    Color? selectedLineColor = Provider.of<DrawerPanel>(context, listen: false).selectedLineColor;

    if (selectedTool == Tools.pencil) {
      setState(() {
        sizeSelectorColor = selectedLineColor;
      });
    } else if (selectedTool == Tools.eraser) {
      setState(() {
        sizeSelectorColor = selectedBackgroundColor;
      });
    }
  }

  @override
  void initState() {
    changeSizeSelectorColor();
    canvas = ui.Canvas(recorder);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var viewportWidth = MediaQuery.of(context).size.width;

    List<Color>? lineColors = Provider.of<DrawerPanel>(context).getLineColors;
    List<Color>? backgroundColors = Provider.of<DrawerPanel>(context).getBackgroundColors;
    List<Tool>? toolsList = Provider.of<DrawerPanel>(context).getToolsList;
    Color? selectedBackgroundColor = Provider.of<DrawerPanel>(context).selectedBackgroundColor;
    Color? selectedLineColor = Provider.of<DrawerPanel>(context).selectedLineColor;
    Tools? selectedTool = Provider.of<DrawerPanel>(context).selectedTool;
    double? lineSize = Provider.of<DrawerPanel>(context).lineSize;
    // ui.Image? image = Provider.of<DrawerPanel>(context).getImage;
    List<LinePoint> points = Provider.of<DrawerPanel>(context).points;
    final panelActions = Provider.of<DrawerPanel>(context);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            viewportWidth < 426
                ? Container(
                    height: 150,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 25,
                                        width: 25,
                                        child: const Icon(Icons.create, size: 18),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {

                                        panelActions.convertCanvasToImage();

                                        if(points.isNotEmpty) {

                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) => ViewImage(image: Provider.of<DrawerPanel>(context).getImage),
                                            ),
                                          );

                                        }


                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 25,
                                        width: 25,
                                        child: const Icon(Icons.save, size: 18),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        panelActions.cleanBoard();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 25,
                                        width: 25,
                                        child: const Icon(Icons.delete, size: 18),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 25,
                                        width: 25,
                                        child: const Icon(Icons.share, size: 18),
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
                                        margin: const EdgeInsets.all(2),
                                        height: 25,
                                        width: 25,
                                        child: const Icon(Icons.undo, size: 18),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        panelActions.redoStroke();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                                        margin: const EdgeInsets.all(2),
                                        height: 25,
                                        width: 25,
                                        child: const Icon(Icons.redo, size: 18),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  child: Text('Line Size'),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      child: Slider(
                                        value: lineSize!,
                                        onChanged: (newSize) {
                                          panelActions.changeLineSize = newSize;
                                        },
                                        activeColor: sizeSelectorColor,
                                        thumbColor: Colors.black,
                                        min: 1,
                                        max: 10,
                                        divisions: 9,
                                        label: "$lineSize",
                                      ),
                                      width: 150,
                                    )
                                  ],
                                ),
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
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  child: Text('Line'),
                                ),
                                Row(
                                  children: [
                                    ...lineColors!.map((color) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeLineColor = color;
                                          changeSizeSelectorColor();
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
                                          margin: const EdgeInsets.all(2),
                                          height: selectedLineColor == color ? 25 : 20,
                                          width: selectedLineColor == color ? 25 : 20,
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
                                          changeSizeSelectorColor();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: selectedBackgroundColor == color
                                                ? Border.all(color: Colors.black, width: 3)
                                                : Border.all(color: color == Colors.white ? Colors.black : color),
                                          ),
                                          margin: const EdgeInsets.all(2),
                                          height: selectedBackgroundColor == color ? 25 : 20,
                                          width: selectedBackgroundColor == color ? 25 : 20,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     const Padding(
                            //       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            //       child: Text('Line Size'),
                            //     ),
                            //     Row(
                            //       children: [
                            //         Slider(
                            //           value: lineSize!,
                            //           onChanged: (newSize) {
                            //             panelActions.changeLineSize = newSize;
                            //           },
                            //           activeColor: sizeSelectorColor,
                            //           thumbColor: Colors.black,
                            //           min: 1,
                            //           max: 10,
                            //           divisions: 9,
                            //           label: "$lineSize",
                            //         )
                            //       ],
                            //     ),
                            //   ],
                            // ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                  child: Text('Tools'),
                                ),
                                Row(
                                  children: [
                                    ...toolsList!.map((tool) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeToolSelected = tool;
                                          changeSizeSelectorColor();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: selectedTool == tool.tool ? Border.all(color: Colors.black, width: 3) : Border.all(color: Colors.white),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          padding: const EdgeInsets.all(4),
                                          height: 25,
                                          width: 25,
                                          child: SvgPicture.asset(
                                            tool.srcUrl!,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
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
                                      onTap: () async {

                                        panelActions.convertCanvasToImage();

                                        if(points.isNotEmpty) {

                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) => ViewImage(image: Provider.of<DrawerPanel>(context).getImage),
                                            ),
                                          );

                                        }

                                      },
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
                                          changeSizeSelectorColor();
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
                                          changeSizeSelectorColor();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                            border: selectedBackgroundColor == color
                                                ? Border.all(color: Colors.black, width: 3)
                                                : Border.all(color: color == Colors.white ? Colors.black : color),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Line Size'),
                                ),
                                Row(
                                  children: [
                                    Slider(
                                      value: lineSize!,
                                      onChanged: (newSize) {
                                        panelActions.changeLineSize = newSize;
                                      },
                                      activeColor: sizeSelectorColor,
                                      thumbColor: Colors.black,
                                      min: 1,
                                      max: 10,
                                      divisions: 9,
                                      label: "$lineSize",
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  child: Text('Tools'),
                                ),
                                Row(
                                  children: [
                                    ...toolsList!.map((tool) {
                                      return GestureDetector(
                                        onTap: () {
                                          panelActions.changeToolSelected = tool;
                                          changeSizeSelectorColor();
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: selectedTool == tool.tool ? Border.all(color: Colors.black, width: 3) : Border.all(color: Colors.white),
                                          ),
                                          margin: const EdgeInsets.all(4),
                                          padding: const EdgeInsets.all(4),
                                          height: 30,
                                          width: 30,
                                          child: SvgPicture.asset(
                                            tool.srcUrl!,
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    }).toList()
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            Expanded(
              child: const Draw(),
            ),
          ],
        ),
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
  List<LinePoint> stroke = [];

  @override
  Widget build(BuildContext context) {
    Color selectedBackgroundColor = Provider.of<DrawerPanel>(context).selectedBackgroundColor;
    Color selectedLineColor = Provider.of<DrawerPanel>(context).selectedLineColor;
    double? lineSize = Provider.of<DrawerPanel>(context).lineSize;
    List<LinePoint> points = Provider.of<DrawerPanel>(context).points;
    Offset? pencil = Provider.of<DrawerPanel>(context).pencil;
    Tools selectedTool = Provider.of<DrawerPanel>(context).selectedTool;
    // Canvas? canvasCopy = Provider.of<DrawerPanel>(context).getCanvas;
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
        drawActions.addStrokeHistory([...stroke]);
        stroke = [];
      },
      child: ClipRect(
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: Board(
            pencil: pencil,
            points: points,
            backgroundColor: selectedBackgroundColor,
            // canvasCopy: canvasCopy
          ),
        ),
      ),
    );
  }
}

class Board extends CustomPainter {
  List<LinePoint>? points;
  Offset? pencil;
  Color? backgroundColor;

  Board({
    this.pencil,
    this.points,
    this.backgroundColor,
    // this.canvasCopy,
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

    // canvas.drawCircle(
    //   pencil!,
    //   5,
    //   Paint()
    //     ..color = Colors.purple
    //     ..strokeWidth = 5,
    // );
  }

  // @override
  // void paint(Canvas canvas, Size size) {
  //
  //   PictureRecorder recorder = PictureRecorder();
  //   outerRecorder = recorder;
  //   tempCanvas = Canvas(recorder);
  //   canvas.drawImage(image, Offset(0.0, 0.0), Paint());
  //   tempCanvas.drawImage(image, Offset(0.0, 0.0), Paint());
  //
  //   for (Offset offset in points) {
  //     canvas.drawCircle(offset, 10, painter);
  //     tempCanvas.drawCircle(offset, 10, painter);
  //   }
  //
  // }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
