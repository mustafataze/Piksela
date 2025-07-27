import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_editor_app/features/editor/presentation/providers/editor_providers.dart';

class DrawingPanel extends ConsumerWidget {
  final File initialImageFile;
  const DrawingPanel({super.key, required this.initialImageFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drawingSettings = ref.watch(editorProvider(initialImageFile).select((s) => s.drawingSettings));
    final editorNotifier = ref.read(editorProvider(initialImageFile).notifier);

    final List<Color> colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
    ];

    return Container(
      color: Colors.black.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fırça Boyutu Slider'ı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text('Boyut:', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: drawingSettings.strokeWidth,
                    min: 1.0,
                    max: 30.0,
                    onChanged: (val) => editorNotifier.changeDrawingStrokeWidth(val),
                    activeColor: drawingSettings.color,
                  ),
                ),
                Text(drawingSettings.strokeWidth.toInt().toString(), style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Renk Seçim Listesi
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final color = colors[index];
                final isSelected = color == drawingSettings.color;
                return GestureDetector(
                  onTap: () => editorNotifier.changeDrawingColor(color),
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Theme.of(context).primaryColor, width: 3)
                          : Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
