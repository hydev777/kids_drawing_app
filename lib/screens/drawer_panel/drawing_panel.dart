import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../classes/tool.dart';
import '../../provider/drawer_panel.dart';
import '../../classes/line_point.dart';
import '../view_image/view_image.dart';
import 'draw/draw.dart';

class Panel extends StatefulWidget {
  const Panel({Key? key}) : super(key: key);

  @override
  State<Panel> createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  Color? sizeSelectorColor;

  // void setImageToolOnInit() {
  //
  //   Provider.of<DrawerPanel>(context, listen: false).changeToolPicture();
  //
  // }

  void changeSizeSelectorColor() {
    Tools? selectedTool = Provider.of<DrawerPanel>(context, listen: false).selectedTool;
    Color? selectedBackgroundColor = Provider.of<DrawerPanel>(context, listen: false).selectedBackgroundColor;
    Color? selectedLineColor = Provider.of<DrawerPanel>(context, listen: false).selectedLineColor;

    if (selectedTool == Tools.pencil) {
      setState(() {
        sizeSelectorColor = selectedLineColor;
      });
      // setImageToolOnInit();
    } else if (selectedTool == Tools.eraser) {
      setState(() {
        sizeSelectorColor = selectedBackgroundColor;
      });
    }
  }

  @override
  void initState() {
    changeSizeSelectorColor();
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
    List<LinePoint>? points = Provider.of<DrawerPanel>(context).points;
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

                                        if(points!.isNotEmpty){

                                          panelActions.convertCanvasToImage();
                                          // ByteData? image = Provider.of<DrawerPanel>(context, listen: false).getImage;

                                          // print(image!.lengthInBytes);

                                          ByteData? image = await Provider.of<DrawerPanel>(context, listen: false).convertCanvasToImage();

                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) => ViewImage(image: image),
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

                                        if(points!.isNotEmpty) {

                                          ByteData? image = await Provider.of<DrawerPanel>(context, listen: false).convertCanvasToImage();

                                          Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) => ViewImage(image: image),
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
            // Provider.of<DrawerPanel>(context).showImage ? Container(
            //   child: RawImage(image: Provider.of<DrawerPanel>(context).pointerImage, width: 40, height: 40,),
            // ) : Container()
            const Expanded(
              child: Draw(),
            ),
          ],
        ),
      ),
    );
  }
}
