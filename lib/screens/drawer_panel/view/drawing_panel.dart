import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/enums/enums.dart';
import '../dialog/sketches_dialog.dart';
import '../provider/provider.dart';
import '../classes/classes.dart';
import '../widgets/widgets.dart';

class DrawingView extends StatelessWidget {
  const DrawingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SketchProvider(),
      child: const DrawingPanelBody(),
    );
  }
}

class DrawingPanelBody extends StatefulWidget {
  const DrawingPanelBody({Key? key}) : super(key: key);

  @override
  State<DrawingPanelBody> createState() => _DrawingPanelBodyState();
}

class _DrawingPanelBodyState extends State<DrawingPanelBody> {
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
            onPressed: () {
              context.read<SketchProvider>().unselectSketch();
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
  void initState() {
    super.initState();

    context.read<DrawerProvider>().setImage();
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
    final sketch = context.watch<SketchProvider>().selectedSketch;
    final isKetchSelected = context.watch<SketchProvider>().isSketchedSelected;

    return SafeArea(
      child: Scaffold(
        drawerEdgeDragWidth: 0.0,
        drawer: Drawer(
          child: Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.blue[200],
            ),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Image.asset("assets/logos/pendraw_logo.png"),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  endIndent: 10,
                  indent: 10,
                  color: Colors.white,
                ),
                TextButton(
                  onPressed: () {
                    context.push("/privacy-policy");
                  },
                  child: const Text(
                    "Privacy Policy - Pendraw",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.blue[500],
          actions: [
            ActionButton(
              onTap: () {
                if (points!.isNotEmpty || isKetchSelected) {
                  clearBoard();
                }
              },
              icon: const Icon(
                Icons.restart_alt,
                size: 22,
                color: Colors.white,
              ),
            ),
            ActionButton(
              onTap: () {
                panelActions.undoStroke();
              },
              icon: const Icon(
                Icons.undo,
                size: 22,
                color: Colors.white,
              ),
            ),
            ActionButton(
              onTap: () {
                panelActions.redoStroke();
              },
              icon: const Icon(
                Icons.redo,
                size: 22,
                color: Colors.white,
              ),
            ),
            ActionButton(
              onTap: () {
                saveDrawingInDevice(points);
              },
              icon: const Icon(
                Icons.save,
                size: 22,
                color: Colors.white,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                size: 24.0,
              ),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    final sketchProvider = context.read<SketchProvider>();

                    showDialog(
                        context: context,
                        builder: (context) {
                          return ChangeNotifierProvider<SketchProvider>.value(
                            value: sketchProvider,
                            child: const SketchesDialog(),
                          );
                        });
                  },
                  child: const Text('Sketches'),
                ),
              ],
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Stack(
            children: [
              Selector<SketchProvider, bool>(
                selector: (context, provider) => provider.isSketchedSelected,
                builder: (context, isSketchedSelected, _) {
                  if (isSketchedSelected) {
                    return Center(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(sketch.srcUrl!),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const DrawingArea(),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: const EdgeInsets.all(2),
                      height: 95,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Line Size',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
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
                                width: 140,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Line',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 90,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Background',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 90,
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
                    ),
                    isKetchSelected
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  context
                                      .read<SketchProvider>()
                                      .unselectSketch();
                                },
                                icon: const Icon(Icons.close),
                              )
                            ],
                          )
                        : const SizedBox.shrink()
                  ],
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
                  margin: const EdgeInsets.all(2),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
