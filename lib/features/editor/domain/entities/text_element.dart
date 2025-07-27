import 'package:flutter/material.dart';

/// Fotoğraf üzerine eklenecek her bir metin öğesinin özelliklerini
/// tutan, değiştirilemez (immutable) bir veri sınıfı.
@immutable
class TextElement {
  final String id;
  final String text;
  final Offset position;
  final Color color;
  final double fontSize;
  final double angle; // Döndürme açısı (radyan cinsinden)
  final double scale; // Büyütme/küçültme oranı

  const TextElement({
    required this.id,
    this.text = 'Metin Gir',
    this.position = const Offset(100, 100),
    this.color = Colors.white,
    this.fontSize = 48.0,
    this.angle = 0.0,
    this.scale = 1.0,
  });

  /// Mevcut nesnenin bir kopyasını oluştururken belirli alanları
  /// yeni değerlerle değiştirmemizi sağlayan yardımcı metot.
  TextElement copyWith({
    String? id,
    String? text,
    Offset? position,
    Color? color,
    double? fontSize,
    double? angle,
    double? scale,
  }) {
    return TextElement(
      id: id ?? this.id,
      text: text ?? this.text,
      position: position ?? this.position,
      color: color ?? this.color,
      fontSize: fontSize ?? this.fontSize,
      angle: angle ?? this.angle,
      scale: scale ?? this.scale,
    );
  }
}
