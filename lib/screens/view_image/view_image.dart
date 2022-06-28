import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ViewImage extends StatefulWidget {
  const ViewImage({Key? key, this.image}) : super(key: key);

  final ByteData? image;

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  ByteData? pngBytes;

  @override
  void initState() {
    pngBytes = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Expanded(
              child: Image.memory(
                pngBytes!.buffer.asUint8List(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
