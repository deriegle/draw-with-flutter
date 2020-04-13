import 'package:flutter/material.dart';

class Line {
  Color color;
  List<Offset> offsets;
  double strokeWidth;
  Path path;

  Line(this.offsets, this.strokeWidth, this.color);

  getPathFromOffset() {
    var path = Path();

    for (var i = 0; i < offsets.length; i++) {
      var offset = offsets[i];

      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }

    offsets = [];
    path = path;
  }
}
