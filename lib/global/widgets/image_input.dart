import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({
    super.key,
    this.onChanged,
  });

  final void Function(String)? onChanged;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;

  void takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) return;

    setState(() {
      selectedImage = File(pickedImage.path);
    });
    widget.onChanged?.call(pickedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = TextButton.icon(
      onPressed: takePicture,
      icon: const Icon(Icons.camera),
      label: const Text('Take picture'),
    );

    if (selectedImage != null) {
      content = GestureDetector(
        onTap: takePicture,
        child: Image.file(
          selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.primary,
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
