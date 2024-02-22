import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/enums.dart';
import '../provider/provider.dart';
import '../classes/classes.dart';
import '../widgets/widgets.dart';

class Panel extends StatefulWidget {
  const Panel({Key? key}) : super(key: key);

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  void saveDrawingInDevice(List<LinePoint>? points) {
    if (points!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Notice"),
          content: const Text(
            'Do you want to save the drawing?',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'NO',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () async {
                await savePaintInDevice();
                context.read<DrawerProvider>().newPaint();
                Navigator.of(context).pop();
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                    color: Colors.blue[500],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    } else {
      context.read<DrawerProvider>().newPaint();
    }
  }

  Future<void> savePaintInDevice() async {
    ByteData? image =
        await context.read<DrawerProvider>().convertCanvasToImage();
    final Uint8List pngBytes = image!.buffer.asUint8List();

    final String dir = (await getTemporaryDirectory()).path;
    final String fullPath = '$dir/${DateTime.now().millisecond}.png';
    File capturedFile = File(fullPath);
    await capturedFile.writeAsBytes(pngBytes);

    await ImageGallerySaver.saveFile(fullPath, isReturnPathOfIOS: true)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Drawing saved in Images folder'),
        ),
      );
    });
  }

  void clearBoard() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text("Notice"),
        content: const Text(
          'Do you want to clear the board?',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'NO',
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () async {
              context.read<DrawerProvider>().newPaint();
              Navigator.of(context).pop();
            },
            child: Text(
              'CLEAR',
              style: TextStyle(
                  color: Colors.blue[500],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color>? lineColors = context.watch<DrawerProvider>().lineColors;
    List<Color>? backgroundColors =
        context.watch<DrawerProvider>().backgroundColors;
    List<Tool>? toolsList = context.watch<DrawerProvider>().toolList;
    Color? selectedBackgroundColor =
        context.watch<DrawerProvider>().selectedBackgroundColor;
    Color? selectedLineColor =
        context.watch<DrawerProvider>().selectedLineColor;
    Tools? selectedTool = context.watch<DrawerProvider>().selectedTool;
    double? lineSize = context.watch<DrawerProvider>().lineSize;
    List<LinePoint>? points = context.watch<DrawerProvider>().points;
    final panelActions = context.read<DrawerProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[500],
          actions: [
            GestureDetector(
              onTap: () async {
                if (points!.isNotEmpty) {
                  clearBoard();
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(2),
                height: 35,
                width: 35,
                child: const Icon(
                  Icons.restart_alt,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                panelActions.undoStroke();
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(2),
                height: 35,
                width: 35,
                child: const Icon(
                  Icons.undo,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                panelActions.redoStroke();
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(2),
                height: 35,
                width: 35,
                child: const Icon(
                  Icons.redo,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                saveDrawingInDevice(points);
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(2),
                height: 35,
                width: 35,
                child: const Icon(
                  Icons.save,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            children: [
              const DrawingArea(),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  height: 90,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
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
                                      activeColor: selectedLineColor,
                                      thumbColor: Colors.black,
                                      min: 1,
                                      max: 10,
                                      divisions: 9,
                                      label: "$lineSize",
                                      inactiveColor: Colors.black45,
                                    ),
                                    width: 150,
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(width: 5),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 2),
                                child: Text('Line'),
                              ),
                              SizedBox(
                                width: 105,
                                child: Wrap(
                                  children: [
                                    ...lineColors!.map((color) {
                                      return ColorOption(
                                        color: color,
                                        selectedColor: selectedLineColor,
                                        onTap: () {
                                          panelActions.changeLineColor = color;
                                        },
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Text('Background'),
                              ),
                              SizedBox(
                                width: 110,
                                child: Wrap(
                                  children: [
                                    ...backgroundColors!.map((color) {
                                      return ColorOption(
                                        color: color,
                                        selectedColor: selectedBackgroundColor,
                                        onTap: () {
                                          panelActions.changeBackgroundColor =
                                              color;
                                        },
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...toolsList!.map((tool) {
                        return DrawingTool(
                          tool: tool,
                          selectedTool: selectedTool,
                        );
                      }).toList()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
