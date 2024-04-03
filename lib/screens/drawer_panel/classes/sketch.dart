class SketchCategory {
  const SketchCategory({
    this.name,
    this.sketches,
  });

  final String? name;
  final List<Sketch>? sketches;
}

class Sketch {
  const Sketch({
    this.name,
    this.srcUrl,
  });

  final String? name;
  final String? srcUrl;
}
