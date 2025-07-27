import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_editor_app/core/constants/app_filters.dart';
import 'package:photo_editor_app/features/editor/presentation/providers/editor_providers.dart';

class FiltersPanel extends ConsumerWidget {
  final File initialImageFile;

  const FiltersPanel({super.key, required this.initialImageFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorProvider(initialImageFile));
    final editorNotifier = ref.read(editorProvider(initialImageFile).notifier);
    final activeFilter = editorState.activeFilter;

    return Container(
      color: Colors.black.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: SizedBox(
        height: 90,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: kFilterPresets.length,
          itemBuilder: (context, index) {
            final preset = kFilterPresets[index];
            final isSelected = preset.name == activeFilter.name;

            return GestureDetector(
              onTap: () => editorNotifier.applyFilter(preset),
              child: Container(
                width: 70,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected ? Border.all(color: Theme.of(context).primaryColor, width: 3) : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: ColorFiltered(
                          colorFilter: ColorFilter.matrix(preset.matrix),
                          child: Image.file(initialImageFile, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        preset.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          // Seçiliyken yazı rengi beyaz, değilken normal.
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
