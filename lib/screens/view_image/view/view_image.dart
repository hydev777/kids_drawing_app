import 'dart:typed_data';

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
        appBar: AppBar(
          title: const Text('Save Drawing'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Image.memory(
                pngBytes!.buffer.asUint8List(),
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
