import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_editor_app/core/constants/app_colors.dart';
import 'package:photo_editor_app/features/editor/domain/entities/text_element.dart';
import 'package:photo_editor_app/features/editor/presentation/providers/editor_providers.dart';

/// Fotoğraf üzerindeki her bir metni temsil eden, sürüklenebilir,
/// döndürülebilir ve ölçeklenebilir widget.
class InteractiveTextWidget extends ConsumerStatefulWidget {
  final TextElement textElement;
  final File initialImageFile;

  const InteractiveTextWidget({super.key, required this.textElement, required this.initialImageFile});

  @override
  ConsumerState<InteractiveTextWidget> createState() => _InteractiveTextWidgetState();
}

class _InteractiveTextWidgetState extends ConsumerState<InteractiveTextWidget> {
  late double _initialScale;
  late double _initialAngle;
  late Offset _initialFocalPoint;

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider(widget.initialImageFile));
    final editorNotifier = ref.read(editorProvider(widget.initialImageFile).notifier);
    final isSelected = editorState.selectedTextId == widget.textElement.id;

    return Positioned(
      left: widget.textElement.position.dx,
      top: widget.textElement.position.dy,
      child: GestureDetector(
        onTap: () => editorNotifier.selectText(widget.textElement.id),
        onScaleStart: (details) {
          if (!isSelected) return;
          _initialScale = widget.textElement.scale;
          _initialAngle = widget.textElement.angle;
          _initialFocalPoint = details.focalPoint - widget.textElement.position;
        },
        onScaleUpdate: (details) {
          if (!isSelected) return;
          final newPosition = details.focalPoint - _initialFocalPoint;
          final newScale = _initialScale * details.scale;
          final newAngle = _initialAngle + details.rotation;

          editorNotifier.updateSelectedText(
            widget.textElement.copyWith(position: newPosition, scale: newScale, angle: newAngle),
          );
        },
        child: Transform.rotate(
          angle: widget.textElement.angle,
          child: Transform.scale(
            scale: widget.textElement.scale,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null),
              child: Text(
                widget.textElement.text,
                style: TextStyle(
                  color: widget.textElement.color,
                  fontSize: widget.textElement.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
