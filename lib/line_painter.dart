import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:drawful_impl/models/line.dart';

class LinePainter extends CustomPainter {
  List<Line> _lines;

  LinePainter(this._lines) : super();

  @override
  void paint(Canvas canvas, Size size) {
    _lines.forEach((line) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.strokeWidth
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round;

      if (line.path != null) {
        canvas.drawPath(line.path, paint);
        return;
      }

      if (line.offsets.length > 1) {
        for (var i = 0; i < line.offsets.length - 1; i++) {
          canvas.drawLine(line.offsets[i], line.offsets[i + 1], paint);
        }
      } else {
        canvas.drawPoints(PointMode.points, line.offsets, paint);
      }
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
