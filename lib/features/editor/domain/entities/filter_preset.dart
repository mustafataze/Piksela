import 'package:flutter/foundation.dart';

@immutable
class FilterPreset {
  final String name;
  final List<double> matrix;

  const FilterPreset({required this.name, required this.matrix});
}
