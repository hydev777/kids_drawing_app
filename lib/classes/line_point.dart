import 'dart:ui';

class LinePoint {
  Offset? point;
  Color? color;
  double? size;

  LinePoint({this.point, this.color, this.size});

  LinePoint clone() => LinePoint(point: point, color: color, size: size);
}
