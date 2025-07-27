import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_editor_app/core/constants/app_colors.dart';
import 'package:photo_editor_app/features/editor/presentation/providers/editor_providers.dart';
import 'package:photo_editor_app/features/editor/presentation/widgets/editor_bottom_bar.dart';
import 'package:photo_editor_app/features/editor/presentation/widgets/editor_canvas.dart';
import 'package:photo_editor_app/features/editor/presentation/widgets/text_editor_dialog.dart';
import 'package:saver_gallery/saver_gallery.dart';

enum EditorTool { none, filters, adjustments }

class EditorPage extends ConsumerStatefulWidget {
  final File initialImageFile;

  const EditorPage({super.key, required this.initialImageFile});

  @override
  ConsumerState<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends ConsumerState<EditorPage> {
  final GlobalKey _canvasKey = GlobalKey();
  EditorTool _currentTool = EditorTool.none;

  void _openTextTool() {
    ref.read(editorProvider(widget.initialImageFile).notifier).addText();
  }

  void _editSelectedText() async {
    final editorState = ref.read(editorProvider(widget.initialImageFile));
    if (editorState.selectedTextId == null) return;
    final selectedText = editorState.texts.firstWhere((text) => text.id == editorState.selectedTextId);
    final updatedElement = await showTextEditorDialog(context, textElement: selectedText);
    if (updatedElement != null) {
      ref.read(editorProvider(widget.initialImageFile).notifier).updateSelectedText(updatedElement);
    }
  }

  Future<void> _cropImage() async {
    final imageFile = ref.read(editorProvider(widget.initialImageFile)).imageFile;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Kırp & Döndür',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Kırp & Döndür', doneButtonTitle: 'Uygula', cancelButtonTitle: 'İptal'),
      ],
    );
    if (croppedFile != null) {
      ref.read(editorProvider(widget.initialImageFile).notifier).updateImage(File(croppedFile.path));
    }
  }

  Future<void> _saveImage() async {
    ref.read(editorProvider(widget.initialImageFile).notifier).selectText(null);
    await Future.delayed(const Duration(milliseconds: 100));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      RenderRepaintBoundary boundary = _canvasKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final tempFileName = "${DateTime.now().millisecondsSinceEpoch}.png";
      final tempFile = await File('${tempDir.path}/$tempFileName').writeAsBytes(pngBytes);
      final result = await SaverGallery.saveFile(
        filePath: tempFile.path,
        fileName: tempFileName,
        androidRelativePath: "Pictures/FotoEditor",
        skipIfExists: true,
      );
      if (context.mounted) Navigator.pop(context);
      if (result.isSuccess) {
        Fluttertoast.showToast(msg: "Fotoğraf galeriye kaydedildi!");
        if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      Fluttertoast.showToast(msg: "Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorNotifier = ref.watch(editorProvider(widget.initialImageFile).notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Düzenle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: editorNotifier.canUndo ? () => editorNotifier.undo() : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: editorNotifier.canRedo ? () => editorNotifier.redo() : null,
          ),
          IconButton(icon: const Icon(Icons.check), onPressed: _saveImage),
        ],
      ),
      body: EditorCanvas(
        canvasKey: _canvasKey,
        initialImageFile: widget.initialImageFile,
        onEditSelectedText: _editSelectedText,
      ),
      bottomNavigationBar: EditorBottomBar(
        currentTool: _currentTool,
        initialImageFile: widget.initialImageFile,
        onCrop: _cropImage,
        onText: _openTextTool,
        onToolSelected: (tool) => setState(() => _currentTool = tool),
      ),
    );
  }
}
