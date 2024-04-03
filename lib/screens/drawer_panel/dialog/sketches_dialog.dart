import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_drawing_app/screens/drawer_panel/provider/provider.dart';
import 'package:provider/provider.dart';

class SketchesDialog extends StatefulWidget {
  const SketchesDialog({Key? key}) : super(key: key);

  @override
  State<SketchesDialog> createState() => _SketchesState();
}

class _SketchesState extends State<SketchesDialog> {
  @override
  Widget build(BuildContext context) {
    final sketchCategories = context.read<SketchProvider>().sketchCategories;

    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(10),
        height: 400,
        child: ListView(
          children: [
            ...sketchCategories
                .map(
                  (category) => ExpansionTile(
                    title: Text(category.name!),
                    children: [
                      ...category.sketches!
                          .map(
                            (sketch) => ListTile(
                              onTap: () {
                                context
                                    .read<SketchProvider>()
                                    .selectSketch(sketch);

                                context.pop();
                              },
                              leading: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      sketch.srcUrl!,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(sketch.name!),
                            ),
                          )
                          .toList()
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
