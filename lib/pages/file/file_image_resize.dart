import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class STFileImageResize extends StatefulWidget {
  const STFileImageResize({super.key});

  @override
  State<STFileImageResize> createState() => _STFileImageResizeState();
}

class _STFileImageResizeState extends State<STFileImageResize> {
  Uint8List? _originalImage; // 原始图片的字节数据
  Uint8List? _resizedImage;  // 调整后的图片字节数据
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // 使用 HTML <input> 选择图片
  void _pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);

        reader.onLoadEnd.listen((e) {
          setState(() {
            _originalImage = reader.result as Uint8List;
            print("Image selected: ${file.name}");
          });
        });
      }
    });
  }

  Future<void> _resizeImage() async {
    if (_originalImage == null) {
      print("No image selected for resizing");
      return;
    }

    final int targetWidth = int.tryParse(_widthController.text) ?? 0;
    final int targetHeight = int.tryParse(_heightController.text) ?? 0;

    if (targetWidth <= 0 || targetHeight <= 0) {
      print("Invalid width or height");
      return;
    }

    try {
      final Uint8List? result = await FlutterImageCompress.compressWithList(
        _originalImage!,
        minWidth: targetWidth,
        minHeight: targetHeight,
        format: CompressFormat.png,  // 确保使用 PNG 格式
        quality: 100,
      );

      if (result == null) {
        print("Compression returned null");
        return;
      }

      setState(() {
        _resizedImage = result;
        print("Image resized successfully with transparency");
      });
    } catch (e) {
      print("Error compressing image: $e");
    }
  }

  // 保存图片到本地
  void _saveResizedImage() {
    if (_resizedImage == null) {
      print("No resized image to save");
      return;
    }

    try {
      final blob = html.Blob([_resizedImage!]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "resized_image.png")
        ..click();
      html.Url.revokeObjectUrl(url);
      print("Resized image saved successfully");
    } catch (e) {
      print("Error saving resized image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Select Image'),
          ),
          if (_originalImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.memory(_originalImage!),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _widthController,
            decoration: const InputDecoration(
              labelText: 'Width',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Height',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resizeImage,
            child: const Text('Generate Resized Image'),
          ),
          if (_resizedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.memory(_resizedImage!),
            ),
          if (_resizedImage != null)
            ElevatedButton(
              onPressed: _saveResizedImage,
              child: const Text('Save Resized Image'),
            ),
        ],
      ),
    );
  }
}
