import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:photo_editor_app/features/editor/domain/entities/text_element.dart';

/// Metin özelliklerini (içerik, renk, boyut) düzenlemek için kullanılan diyalog.
Future<TextElement?> showTextEditorDialog(BuildContext context, {required TextElement textElement}) {
  return showDialog<TextElement>(
    context: context,
    builder: (context) {
      return _TextEditorDialogContent(initialTextElement: textElement);
    },
  );
}

class _TextEditorDialogContent extends StatefulWidget {
  final TextElement initialTextElement;

  const _TextEditorDialogContent({required this.initialTextElement});

  @override
  State<_TextEditorDialogContent> createState() => _TextEditorDialogContentState();
}

class _TextEditorDialogContentState extends State<_TextEditorDialogContent> {
  late TextEditingController _controller;
  late Color _currentColor;
  late double _currentFontSize;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTextElement.text);
    _currentColor = widget.initialTextElement.color;
    _currentFontSize = widget.initialTextElement.fontSize;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Metni Düzenle'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Metin'),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text('Renk:'),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Renk Seç'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: _currentColor,
                          onColorChanged: (color) => setState(() => _currentColor = color),
                        ),
                      ),
                      actions: <Widget>[
                        ElevatedButton(child: const Text('Tamam'), onPressed: () => Navigator.of(context).pop()),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Boyut:'),
              Expanded(
                child: Slider(
                  value: _currentFontSize,
                  min: 12.0,
                  max: 120.0,
                  onChanged: (value) => setState(() => _currentFontSize = value),
                ),
              ),
              Text(_currentFontSize.toInt().toString()),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('İptal')),
        TextButton(
          onPressed: () {
            // "Uygula"ya basıldığında güncellenmiş TextElement'i geri döndür.
            final updatedElement = widget.initialTextElement.copyWith(
              text: _controller.text,
              color: _currentColor,
              fontSize: _currentFontSize,
            );
            Navigator.of(context).pop(updatedElement);
          },
          child: const Text('Uygula'),
        ),
      ],
    );
  }
}
