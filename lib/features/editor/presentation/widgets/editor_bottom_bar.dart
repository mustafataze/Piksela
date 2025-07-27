import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_editor_app/core/constants/app_colors.dart';
import 'package:photo_editor_app/features/editor/presentation/screens/editor_page.dart';
import 'package:photo_editor_app/features/editor/presentation/widgets/adjustment_panel.dart';
import 'package:photo_editor_app/features/editor/presentation/widgets/filters_panel.dart';

/// Editor sayfasındaki tüm alt navigasyon mantığını yöneten widget.
class EditorBottomBar extends StatelessWidget {
  final EditorTool currentTool;
  final ValueChanged<EditorTool> onToolSelected;
  final VoidCallback onCrop;
  final VoidCallback onText;
  final File initialImageFile;

  const EditorBottomBar({
    super.key,
    required this.currentTool,
    required this.onToolSelected,
    required this.onCrop,
    required this.onText,
    required this.initialImageFile,
  });

  @override
  Widget build(BuildContext context) {
    switch (currentTool) {
      case EditorTool.filters:
        return _buildToolWrapper(context, FiltersPanel(initialImageFile: initialImageFile));
      case EditorTool.adjustments:
        return _buildToolWrapper(context, AdjustmentPanel(initialImageFile: initialImageFile));
      case EditorTool.none:
        return _buildDefaultNavigationBar();
    }
  }

  Widget _buildDefaultNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      onTap: (index) {
        if (index == 0) onCrop();
        if (index == 1) onToolSelected(EditorTool.filters);
        if (index == 2) onToolSelected(EditorTool.adjustments);
        if (index == 3) onText();
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.crop_rotate), label: 'Kırp'),
        BottomNavigationBarItem(icon: Icon(Icons.filter), label: 'Filtreler'),
        BottomNavigationBarItem(icon: Icon(Icons.tune), label: 'Ayarlar'),
        BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Metin'),
      ],
    );
  }

  Widget _buildToolWrapper(BuildContext context, Widget toolPanel) {
    return Container(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          toolPanel,
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => onToolSelected(EditorTool.none),
          ),
        ],
      ),
    );
  }
}
