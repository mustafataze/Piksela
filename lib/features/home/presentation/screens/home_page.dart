import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editor_app/core/constants/app_colors.dart';
import 'package:photo_editor_app/core/constants/app_styles.dart';
import 'package:photo_editor_app/features/editor/presentation/screens/editor_page.dart';
import 'package:photo_editor_app/features/home/presentation/providers/home_providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _pickImage(ImageSource source, BuildContext context, WidgetRef ref) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      ref.read(selectedImageProvider.notifier).state = imageFile;

      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => EditorPage(initialImageFile: imageFile)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık ve Logo Alanı
                Row(
                  children: [
                    // Logo konseptini temsil eden bir ikon
                    const Icon(Icons.camera_enhance, color: AppColors.primary, size: 40),
                    const SizedBox(width: 12),
                    Text('Piksela', style: AppTextStyles.h1),
                    const Spacer(),
                    // Gelecekteki Login/Profil sayfası için bir ikon
                    IconButton(
                      icon: const Icon(Icons.person_outline, color: Colors.white, size: 30),
                      onPressed: () {
                        //Profil sayfasına yönlendirme eklenecek.
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // Ana Başlık
                Text('Yaratıcılığını\nOrtaya Çıkar', style: AppTextStyles.homeTitle),
                const SizedBox(height: 40),

                // Eylem Kartları
                _ActionCard(
                  title: 'Galeriden Seç',
                  subtitle: 'Bir fotoğraf düzenlemeye başla',
                  icon: Icons.photo_library,
                  color: AppColors.primary,
                  onTap: () => _pickImage(ImageSource.gallery, context, ref),
                ),
                const SizedBox(height: 20),
                _ActionCard(
                  title: 'Kamerayı Aç',
                  subtitle: 'Yeni bir an yakala',
                  icon: Icons.camera_alt,
                  color: Colors.deepPurpleAccent,
                  onTap: () => _pickImage(ImageSource.camera, context, ref),
                ),

                const Spacer(),

                // "Son Projeler" gibi gelecekteki özellikler için alan
                const Center(
                  child: Text('Son Düzenlemeler Yakında Burada', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Ana sayfadaki tıklanabilir kartlar için özel widget
class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.cardSubtitle),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
