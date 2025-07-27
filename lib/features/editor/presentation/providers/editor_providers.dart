import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_editor_app/features/editor/domain/entities/editor_state.dart';
import 'package:photo_editor_app/features/editor/domain/entities/filter_preset.dart';
import 'package:photo_editor_app/features/editor/domain/entities/text_element.dart';

class EditorStateNotifier extends StateNotifier<EditorState> {
  final List<EditorState> _history = [];
  int _historyIndex = -1;

  EditorStateNotifier(File initialImage) : super(EditorState(imageFile: initialImage)) {
    _history.add(state);
    _historyIndex = 0;
  }

  bool get canUndo => _historyIndex > 0;
  bool get canRedo => _historyIndex < _history.length - 1;

  void _recordChange(EditorState newState) {
    if (_historyIndex < _history.length - 1) {
      _history.removeRange(_historyIndex + 1, _history.length);
    }
    _history.add(newState);
    _historyIndex++;
    state = newState;
  }

  void undo() {
    if (canUndo) {
      _historyIndex--;
      state = _history[_historyIndex];
    }
  }

  void redo() {
    if (canRedo) {
      _historyIndex++;
      state = _history[_historyIndex];
    }
  }

  void updateImage(File newImage) {
    _recordChange(state.copyWith(imageFile: newImage));
  }

  // --- FİLTRE VE AYAR METOTLARI ---
  void updateBrightness(double value) {
    _recordChange(state.copyWith(brightness: value));
  }

  void updateContrast(double value) {
    _recordChange(state.copyWith(contrast: value));
  }

  void updateSaturation(double value) {
    _recordChange(state.copyWith(saturation: value));
  }

  void updateExposure(double value) {
    _recordChange(state.copyWith(exposure: value));
  }

  void updateTemperature(double value) {
    _recordChange(state.copyWith(temperature: value));
  }

  void applyFilter(FilterPreset filter) {
    _recordChange(state.copyWith(activeFilter: filter));
  }

  // --- METİN YÖNETİMİ METOTLARI ---
  void addText() {
    final newText = TextElement(id: DateTime.now().millisecondsSinceEpoch.toString());
    final newTexts = List<TextElement>.from(state.texts)..add(newText);
    _recordChange(state.copyWith(texts: newTexts, selectedTextId: () => newText.id));
  }

  void selectText(String? id) {
    _recordChange(state.copyWith(selectedTextId: () => id));
  }

  void deleteSelectedText() {
    if (state.selectedTextId == null) return;
    final newTexts = List<TextElement>.from(state.texts)..removeWhere((text) => text.id == state.selectedTextId);
    _recordChange(state.copyWith(texts: newTexts, selectedTextId: () => null));
  }

  void updateSelectedText(TextElement updatedText) {
    final newTexts = state.texts.map((text) {
      return text.id == state.selectedTextId ? updatedText : text;
    }).toList();
    _recordChange(state.copyWith(texts: newTexts));
  }
}

final editorProvider = StateNotifierProvider.autoDispose.family<EditorStateNotifier, EditorState, File>((
  ref,
  initialImage,
) {
  return EditorStateNotifier(initialImage);
});
