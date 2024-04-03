import 'package:flutter/material.dart';

import '../classes/classes.dart';

class SketchProvider extends ChangeNotifier {
  final List<SketchCategory> _sketchCategories = const [
    SketchCategory(
      name: "Bodies",
      sketches: [
        Sketch(
          name: "Body 1",
          srcUrl: "assets/images/pendraw_body_sketch_1.png",
        ),
        Sketch(
          name: "Body 2",
          srcUrl: "assets/images/pendraw_body_sketch_2.png",
        )
      ],
    ),
    SketchCategory(
      name: "Faces",
      sketches: [
        Sketch(
          name: "Face 1",
          srcUrl: "assets/images/pendraw_face_1.png",
        ),
        Sketch(
          name: "Face 2",
          srcUrl: "assets/images/pendraw_face_2.png",
        )
      ],
    ),
    SketchCategory(
      name: "Hands",
      sketches: [
        Sketch(
          name: "Hand 1",
          srcUrl: "assets/images/pendraw_hands_sketch_1.png",
        ),
        Sketch(
          name: "Hand 2",
          srcUrl: "assets/images/pendraw_hands_sketch_2.png",
        )
      ],
    ),
  ];
  Sketch _selectedSketch = const Sketch(
    name: "Body 1",
    srcUrl: "assets/images/pendraw_body_sketch_1.png",
  );
  bool _isSketchedSelected = false;

  List<SketchCategory> get sketchCategories {
    return _sketchCategories;
  }

  Sketch get selectedSketch {
    return _selectedSketch;
  }

  bool get isSketchedSelected {
    return _isSketchedSelected;
  }

  void selectSketch(Sketch sketch) {
    if (_isSketchedSelected == false) {
      _isSketchedSelected = true;
    }

    _selectedSketch = sketch;

    notifyListeners();
  }

  void unselectSketch() {
    _isSketchedSelected = false;

    notifyListeners();
  }
}
