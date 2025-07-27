import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:photo_editor_app/features/editor/domain/entities/drawing_path.dart';

/// Ekrana çizimleri yansıtan CustomPainter sınıfı.
class DrawingPainter extends CustomPainter {
  final List<DrawingPath> drawings;

  DrawingPainter({required this.drawings});

  @override
  void paint(Canvas canvas, Size size) {
    for (var pathData in drawings) {
      final paint = Paint()
        ..color = pathData.settings.color
        ..strokeWidth = pathData.settings.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (pathData.points.length > 1) {
        final path = Path();
        path.moveTo(pathData.points.first.dx, pathData.points.first.dy);
        for (int i = 1; i < pathData.points.length; i++) {
          path.lineTo(pathData.points[i].dx, pathData.points[i].dy);
        }
        canvas.drawPath(path, paint);
      } else {
        // Tek bir nokta varsa, onu daire olarak çiz
        canvas.drawPoints(ui.PointMode.points, pathData.points, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
