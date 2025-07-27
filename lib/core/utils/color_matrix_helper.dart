import 'dart:math';

class ColorMatrixHelper {
  ColorMatrixHelper._();

  static const List<double> identity = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];

  static List<double> brightness(double value) {
    final b = value * 255;
    return List.from(identity)..setAll(0, [1, 0, 0, 0, b, 0, 1, 0, 0, b, 0, 0, 1, 0, b, 0, 0, 0, 1, 0]);
  }

  static List<double> saturation(double value) {
    final s = value + 1.0;
    const rLum = 0.2126;
    const gLum = 0.7152;
    const bLum = 0.0722;
    final sr = (1 - s) * rLum;
    final sg = (1 - s) * gLum;
    final sb = (1 - s) * bLum;
    return [sr + s, sg, sb, 0, 0, sr, sg + s, sb, 0, 0, sr, sg, sb + s, 0, 0, 0, 0, 0, 1, 0];
  }

  static List<double> contrast(double value) {
    final c = value + 1.0;
    final t = (1.0 - c) / 2.0 * 255;
    return [c, 0, 0, 0, t, 0, c, 0, 0, t, 0, 0, c, 0, t, 0, 0, 0, 1, 0];
  }

  static List<double> exposure(double value) {
    final v = pow(2, value).toDouble();
    return [v, 0, 0, 0, 0, 0, v, 0, 0, 0, 0, 0, v, 0, 0, 0, 0, 0, 1, 0];
  }

  static List<double> temperature(double value) {
    final t = value * 100;
    List<double> matrix = List.from(identity);
    if (t > 0) {
      matrix[0] = 1 + t / 255;
      matrix[6] = 1 + t / 510;
    } else {
      matrix[12] = 1 - t / 255;
    }
    return matrix;
  }

  static List<double> compose(List<List<double>> matrices) {
    List<double> result = List.from(identity);
    for (var matrix in matrices) {
      result = _multiply(result, matrix);
    }
    return result;
  }

  static List<double> _multiply(List<double> a, List<double> b) {
    final result = List<double>.filled(20, 0);
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 5; j++) {
        double val = 0;
        if (j < 4) {
          for (int k = 0; k < 4; k++) {
            val += a[i * 5 + k] * b[k * 5 + j];
          }
        }
        if (j == 4) {
          val += a[i * 5 + 4];
          for (int k = 0; k < 4; k++) {
            val += a[i * 5 + k] * b[k * 5 + 4];
          }
        }
        result[i * 5 + j] = val;
      }
    }
    return result;
  }
}
