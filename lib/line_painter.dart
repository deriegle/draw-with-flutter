import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:drawful_impl/models/line.dart';

class LinePainter extends CustomPainter {
  List<Line> _lines;

  LinePainter(this._lines) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    generateImage(canvas, _lines, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

extension FromPaint on Paint {
  Paint from(Paint oldPaint) {
    return Paint()
      ..blendMode = oldPaint.blendMode
      ..color = oldPaint.color
      ..colorFilter = oldPaint.colorFilter
      ..filterQuality = oldPaint.filterQuality
      ..imageFilter = oldPaint.imageFilter
      ..invertColors = oldPaint.invertColors
      ..isAntiAlias = oldPaint.isAntiAlias
      ..maskFilter = oldPaint.maskFilter
      ..shader = oldPaint.shader
      ..strokeCap = oldPaint.strokeCap
      ..strokeJoin = oldPaint.strokeJoin
      ..strokeMiterLimit = oldPaint.strokeMiterLimit
      ..strokeWidth = oldPaint.strokeWidth
      ..style = oldPaint.style;
  }
}

Picture getPictureFromCanvas(List<Line> lines) {
  final recorder = PictureRecorder();
  final paint = Paint()
    ..isAntiAlias = true
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  final canvas = Canvas(recorder);
  generateImage(canvas, lines, paint);

  return recorder.endRecording();
}

void generateImage(Canvas canvas, List<Line> lines, Paint paint) async {
  lines.forEach((line) {
    var linePaint = Paint().from(paint)
      ..color = line.color
      ..strokeWidth = line.strokeWidth;

    if (line.path != null) {
      canvas.drawPath(line.path, linePaint);
    } else {
      if (line.offsets.length > 1) {
        for (var i = 0; i < line.offsets.length - 1; i++) {
          canvas.drawLine(line.offsets[i], line.offsets[i + 1], linePaint);
        }
      } else {
        canvas.drawPoints(PointMode.points, line.offsets, linePaint);
      }
    }
  });
}
