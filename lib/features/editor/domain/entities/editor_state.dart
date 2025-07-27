import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:photo_editor_app/core/utils/color_matrix_helper.dart';
import 'package:photo_editor_app/features/editor/domain/entities/filter_preset.dart';
import 'package:photo_editor_app/features/editor/domain/entities/text_element.dart';

@immutable
class EditorState {
  final File imageFile;
  final double brightness;
  final double contrast;
  final double saturation;
  final double exposure;
  final double temperature;

  final FilterPreset activeFilter;

  final List<TextElement> texts;
  final String? selectedTextId;

  const EditorState({
    required this.imageFile,
    this.brightness = 0.0,
    this.contrast = 0.0,
    this.saturation = 0.0,
    this.exposure = 0.0,
    this.temperature = 0.0,
    this.activeFilter = const FilterPreset(name: 'Orijinal', matrix: ColorMatrixHelper.identity),
    this.texts = const [],
    this.selectedTextId,
  });

  EditorState copyWith({
    File? imageFile,
    double? brightness,
    double? contrast,
    double? saturation,
    double? exposure,
    double? temperature,
    FilterPreset? activeFilter,
    List<TextElement>? texts,
    ValueGetter<String?>? selectedTextId,
  }) {
    return EditorState(
      imageFile: imageFile ?? this.imageFile,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      exposure: exposure ?? this.exposure,
      temperature: temperature ?? this.temperature,
      activeFilter: activeFilter ?? this.activeFilter,
      texts: texts ?? this.texts,
      selectedTextId: selectedTextId != null ? selectedTextId() : this.selectedTextId,
    );
  }
}
