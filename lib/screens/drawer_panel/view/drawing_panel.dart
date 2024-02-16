import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../classes/tool.dart';
import '../provider/drawer_panel.dart';
import '../classes/line_point.dart';
import '../widgets/color_option.dart';
import '../widgets/drawing_area.dart';
import '../widgets/drawing_tool.dart';

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
                context.read<DrawerPanel>().newPaint();
                Navigator.of(context).pop();
              },
              child: Text(
                'SAVE',
                style: TextStyle(
                    color: Colors.deepPurple[300],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      );
    } else {
      context.read<DrawerPanel>().newPaint();
    }
  }

  Future<void> savePaintInDevice() async {
    ByteData? image = await context.read<DrawerPanel>().convertCanvasToImage();
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
              context.read<DrawerPanel>().newPaint();
              Navigator.of(context).pop();
            },
            child: Text(
              'CLEAR',
              style: TextStyle(
                  color: Colors.deepPurple[300],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 0),
      () {
        context.read<DrawerPanel>().changeSizeSelectorColor();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var viewportWidth = MediaQuery.of(context).size.width;
    List<Color>? lineColors = context.watch<DrawerPanel>().getLineColors;
    List<Color>? backgroundColors =
        context.watch<DrawerPanel>().getBackgroundColors;
    List<Tool>? toolsList = context.watch<DrawerPanel>().getToolsList;
    Color? selectedBackgroundColor =
        context.watch<DrawerPanel>().selectedBackgroundColor;
    Color? selectedLineColor = context.watch<DrawerPanel>().selectedLineColor;
    Tools? selectedTool = context.watch<DrawerPanel>().selectedTool;
    double? lineSize = context.watch<DrawerPanel>().lineSize;
    List<LinePoint>? points = context.watch<DrawerPanel>().points;
    Color? sizeSelectorColor = context.watch<DrawerPanel>().lineSizeColor;
    final panelActions = context.read<DrawerPanel>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[500],
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
          child: Column(
            children: [
              viewportWidth < 426
                  ? SizedBox(
                      height: 120,
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
                                            panelActions.changeLineSize =
                                                newSize;
                                          },
                                          activeColor:
                                              sizeSelectorColor == Colors.white
                                                  ? Colors.white54
                                                  : sizeSelectorColor,
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
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 2),
                                    child: Text('Line'),
                                  ),
                                  Row(
                                    children: [
                                      ...lineColors!.map((color) {
                                        return ColorOption(
                                          color: color,
                                          selectedColor: selectedLineColor,
                                          onTap: () {
                                            panelActions.changeLineColor =
                                                color;
                                          },
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text('Background'),
                                  ),
                                  Row(
                                    children: [
                                      ...backgroundColors!.map((color) {
                                        return ColorOption(
                                          color: color,
                                          selectedColor:
                                              selectedBackgroundColor,
                                          onTap: () {
                                            panelActions.changeBackgroundColor =
                                                color;
                                          },
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
                    )
                  : SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text('Line'),
                                  ),
                                  Row(
                                    children: [
                                      ...lineColors!.map((color) {
                                        return ColorOption(
                                          color: color,
                                          selectedColor: selectedLineColor,
                                          onTap: () {
                                            panelActions.changeLineColor =
                                                color;
                                          },
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text('Background'),
                                  ),
                                  Row(
                                    children: [
                                      ...backgroundColors!.map((color) {
                                        return ColorOption(
                                          color: color,
                                          selectedColor:
                                              selectedBackgroundColor,
                                          onTap: () {
                                            panelActions.changeBackgroundColor =
                                                color;
                                          },
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
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
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
                            ],
                          ),
                        ],
                      ),
                    ),
              const Expanded(
                child: DrawingArea(),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple[300],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                padding: const EdgeInsets.all(4),
                height: 50,
                child: Row(
                  children: [
                    ...toolsList!.map((tool) {
                      return DrawingTool(
                        tool: tool,
                        selectedTool: selectedTool,
                      );
                    }).toList()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
