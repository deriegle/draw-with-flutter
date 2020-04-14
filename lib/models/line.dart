import 'package:flutter/material.dart';
import 'package:drawful_impl/main.dart';

class Line {
  Color color;
  List<Offset> offsets;
  double strokeWidth;
  Path path;

  Line(this.offsets, this.strokeWidth, this.color);

  getPathFromOffset() {
    if (offsets.length == 10) {
      return;
    }

    var path = Path();

    for (var i = 0; i < offsets.length; i++) {
      var offset = offsets[i];

      if (i == 0) {
        path.moveTo(offset.dx, offset.dy);
      } else {
        path.lineTo(offset.dx, offset.dy);
      }
    }

    path = path;
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color.value,
      'strokeWidth': strokeWidth,
      'offsets': offsets.map((offset) => offset.toJSON()).toList(),
    };
  }

  factory Line.fromJSON(Map<String, dynamic> json) {
    var strokeWidth = double.tryParse(json['strokeWidth'].toString()) ?? MIN_POINT_SIZE;
    var color = Color(int.tryParse(json['color'].toString()));
    var offsets = offsetsFromJSON(json['offsets']);
    var newLine = Line(
      offsets,
      strokeWidth,
      color,
    );

    if (newLine.offsets.length > 0) {
      newLine.getPathFromOffset();
    }

    return newLine;
  }
}

List<Offset> offsetsFromJSON(List<dynamic> json) {
  if (json == null) {
    return List<Offset>();
  }

  return List.from(json)
      .map((offset) =>
          Offset(double.tryParse(offset['x'].toString()), double.tryParse(offset['y'].toString())))
      .toList();
}

extension OffsetJSON on Offset {
  Map<String, dynamic> toJSON() {
    return {'x': this.dx, 'y': this.dy};
  }
}
