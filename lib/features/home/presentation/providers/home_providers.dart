import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Kullanıcının seçtiği anlık fotoğraf dosyasını tutan provider.
/// Başlangıçta null (boş) bir değere sahip.
final selectedImageProvider = StateProvider<File?>((ref) {
  return null;
});
