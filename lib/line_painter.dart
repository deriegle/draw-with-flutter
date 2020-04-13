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
    var newPaint = Paint();

    newPaint.blendMode = oldPaint.blendMode ?? newPaint.blendMode;
    newPaint.color = oldPaint.color ?? newPaint.color;
    newPaint.colorFilter = oldPaint.colorFilter ?? newPaint.colorFilter;
    newPaint.filterQuality = oldPaint.filterQuality ?? newPaint.filterQuality;
    newPaint.imageFilter = oldPaint.imageFilter ?? newPaint.imageFilter;
    newPaint.invertColors = oldPaint.invertColors ?? newPaint.invertColors;
    newPaint.isAntiAlias = oldPaint.isAntiAlias ?? newPaint.isAntiAlias;
    newPaint.maskFilter = oldPaint.maskFilter ?? newPaint.maskFilter;
    newPaint.shader = oldPaint.shader ?? newPaint.shader;
    newPaint.strokeCap = oldPaint.strokeCap ?? newPaint.strokeCap;
    newPaint.strokeJoin = oldPaint.strokeJoin ?? newPaint.strokeJoin;
    newPaint.strokeMiterLimit = oldPaint.strokeMiterLimit ?? newPaint.strokeMiterLimit;
    newPaint.strokeWidth = oldPaint.strokeWidth ?? newPaint.strokeWidth;
    newPaint.style = oldPaint.style ?? newPaint.style;
    return newPaint;
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
      ..color = line.color ?? Colors.red
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
