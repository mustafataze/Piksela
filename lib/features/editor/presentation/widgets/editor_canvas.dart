import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_editor_app/core/utils/color_matrix_helper.dart';
import 'package:photo_editor_app/features/editor/presentation/providers/editor_providers.dart';
import 'package:photo_editor_app/features/editor/presentation/widgets/interactive_text.dart';

/// Fotoğrafı, filtreleri ve metinleri gösteren ana tuval alanı.
class EditorCanvas extends ConsumerWidget {
  final GlobalKey canvasKey;
  final File initialImageFile;
  final VoidCallback onEditSelectedText;

  const EditorCanvas({
    super.key,
    required this.canvasKey,
    required this.initialImageFile,
    required this.onEditSelectedText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(editorProvider(initialImageFile));
    final editorNotifier = ref.read(editorProvider(initialImageFile).notifier);

    final baseAdjustmentsMatrix = ColorMatrixHelper.compose([
      ColorMatrixHelper.brightness(editorState.brightness),
      ColorMatrixHelper.contrast(editorState.contrast),
      ColorMatrixHelper.saturation(editorState.saturation),
      ColorMatrixHelper.exposure(editorState.exposure),
      ColorMatrixHelper.temperature(editorState.temperature),
    ]);

    final finalMatrix = ColorMatrixHelper.compose([baseAdjustmentsMatrix, editorState.activeFilter.matrix]);

    return GestureDetector(
      onTap: () => editorNotifier.selectText(null),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: RepaintBoundary(
              key: canvasKey,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ColorFiltered(colorFilter: ColorFilter.matrix(finalMatrix), child: Image.file(editorState.imageFile)),
                  ...editorState.texts.map(
                    (text) => InteractiveTextWidget(textElement: text, initialImageFile: initialImageFile),
                  ),
                ],
              ),
            ),
          ),
          if (editorState.selectedTextId != null)
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                    onPressed: onEditSelectedText,
                    style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.5)),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                    onPressed: () => editorNotifier.deleteSelectedText(),
                    style: IconButton.styleFrom(backgroundColor: Colors.black.withOpacity(0.5)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
