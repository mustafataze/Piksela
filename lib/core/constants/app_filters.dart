import 'package:photo_editor_app/core/utils/color_matrix_helper.dart';
import 'package:photo_editor_app/features/editor/domain/entities/filter_preset.dart';

final List<FilterPreset> kFilterPresets = [
  FilterPreset(name: 'Orijinal', matrix: ColorMatrixHelper.identity),
  FilterPreset(
    name: 'Canlı',
    matrix: ColorMatrixHelper.compose([ColorMatrixHelper.saturation(0.4), ColorMatrixHelper.contrast(0.2)]),
  ),
  // YENİ: Sepya filtresi
  FilterPreset(
    name: 'Sepya',
    matrix: const [
      0.393, 0.769, 0.189, 0, 0, //
      0.349, 0.686, 0.168, 0, 0,
      0.272, 0.534, 0.131, 0, 0,
      0, 0, 0, 1, 0,
    ],
  ),
  FilterPreset(
    name: 'S&B', // Siyah & Beyaz
    matrix: ColorMatrixHelper.saturation(-1.0),
  ),
  // YENİ: Soğuk filtresi
  FilterPreset(
    name: 'Soğuk',
    matrix: ColorMatrixHelper.compose([ColorMatrixHelper.temperature(-0.2), ColorMatrixHelper.contrast(0.1)]),
  ),
  // YENİ: Vintage filtresi
  FilterPreset(
    name: 'Vintage',
    matrix: ColorMatrixHelper.compose([
      ColorMatrixHelper.saturation(-0.3),
      ColorMatrixHelper.brightness(0.1),
      const [
        1, 0, 0, 0, 0,
        0, 1, 0, 0, -10, // Hafif mavi tonu
        0, 0, 1, 0, -20, // Hafif sarı tonu
        0, 0, 0, 1, 0,
      ],
    ]),
  ),
];
