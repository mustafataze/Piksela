import 'package:flutter/material.dart';

/// Çizim ayarlarını (renk, fırça boyutu) tutan sınıf.
@immutable
class DrawingSettings {
  final Color color;
  final double strokeWidth;

  const DrawingSettings({this.color = Colors.white, this.strokeWidth = 5.0});

  DrawingSettings copyWith({Color? color, double? strokeWidth}) {
    return DrawingSettings(color: color ?? this.color, strokeWidth: strokeWidth ?? this.strokeWidth);
  }
}

/// Tek bir fırça darbesini temsil eden sınıf.
/// Çizim ayarlarını ve çizilen noktaların listesini içerir.
@immutable
class DrawingPath {
  final List<Offset> points;
  final DrawingSettings settings;

  const DrawingPath({required this.points, required this.settings});
}
