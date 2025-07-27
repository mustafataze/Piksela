import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_editor_app/core/theme/app_theme.dart';
import 'package:photo_editor_app/features/home/presentation/screens/home_page.dart';

void main() {
  // Flutter binding'lerinin başlatıldığından emin oluyoruz.
  WidgetsFlutterBinding.ensureInitialized();

  // Riverpod'u tüm uygulamaya tanıtmak için ProviderScope ile sarmalıyoruz.
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Fotoğraf Editörü',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
