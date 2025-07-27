import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_editor_app/features/editor/presentation/providers/editor_providers.dart';
import 'package:photo_editor_app/features/editor/presentation/widgets/adjustment_slider.dart';

// Ayar aracını temsil eden basit bir veri sınıfı
class AdjustmentTool {
  final IconData icon;
  final String label;
  final double value;
  final Function(double) onChanged;

  AdjustmentTool({required this.icon, required this.label, required this.value, required this.onChanged});
}

class AdjustmentPanel extends ConsumerStatefulWidget {
  final File initialImageFile;
  const AdjustmentPanel({super.key, required this.initialImageFile});

  @override
  ConsumerState<AdjustmentPanel> createState() => _AdjustmentPanelState();
}

class _AdjustmentPanelState extends ConsumerState<AdjustmentPanel> {
  // O an hangi ayar aracının seçili olduğunu tutan state
  int _selectedAdjustmentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider(widget.initialImageFile));
    final editorNotifier = ref.read(editorProvider(widget.initialImageFile).notifier);

    // Mevcut state'e göre ayar araçlarının listesini oluştur
    final List<AdjustmentTool> tools = [
      AdjustmentTool(
        icon: Icons.brightness_6,
        label: 'Parlaklık',
        value: editorState.brightness,
        onChanged: (val) => editorNotifier.updateBrightness(val),
      ),
      AdjustmentTool(
        icon: Icons.contrast,
        label: 'Kontrast',
        value: editorState.contrast,
        onChanged: (val) => editorNotifier.updateContrast(val),
      ),
      AdjustmentTool(
        icon: Icons.water_drop_outlined,
        label: 'Doygunluk',
        value: editorState.saturation,
        onChanged: (val) => editorNotifier.updateSaturation(val),
      ),
      AdjustmentTool(
        icon: Icons.exposure,
        label: 'Pozlama',
        value: editorState.exposure,
        onChanged: (val) => editorNotifier.updateExposure(val),
      ),
      AdjustmentTool(
        icon: Icons.thermostat,
        label: 'Sıcaklık',
        value: editorState.temperature,
        onChanged: (val) => editorNotifier.updateTemperature(val),
      ),
    ];

    // Seçili olan aracı al
    final selectedTool = tools[_selectedAdjustmentIndex];

    return Container(
      color: Colors.black.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. ÜST KISIM: Seçili olan aracın slider'ı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: AdjustmentSlider(
              label: selectedTool.label,
              value: selectedTool.value,
              min: -1.0,
              max: 1.0,
              onChanged: selectedTool.onChanged,
            ),
          ),
          const SizedBox(height: 10),
          // 2. ALT KISIM: Yatayda kayan ayar aracı ikonları
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tools.length,
              itemBuilder: (context, index) {
                final tool = tools[index];
                final isSelected = _selectedAdjustmentIndex == index;
                // Seçili öğenin metin ve ikon rengi
                final Color selectedColor = Colors.white;
                // Seçili olmayan öğenin metin ve ikon rengi
                final Color unselectedColor = Colors.white.withOpacity(0.7);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAdjustmentIndex = index;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      // Seçiliyse ana renk, değilse şeffaf.
                      color: isSelected ? Theme.of(context).primaryColor : Colors.white12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(tool.icon, color: isSelected ? selectedColor : unselectedColor),
                        const SizedBox(height: 4),
                        Text(
                          tool.label,
                          style: TextStyle(
                            color: isSelected ? selectedColor : unselectedColor,
                            fontSize: 10,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
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
