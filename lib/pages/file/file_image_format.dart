import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:js_util' as js_util;

// Function to convert PNG to ICO
Future<Uint8List?> convertPngToIco(Uint8List pngBytes) async {
  try {
    // Call the JavaScript function and pass the PNG bytes
    final jsResult = await js_util.promiseToFuture(
        js_util.callMethod(html.window, 'pngToIco', [pngBytes])
    );

    // Convert jsResult (ArrayBuffer) to Uint8List
    final byteList = Uint8List.view(jsResult);

    return byteList;
  } catch (e) {
    print('Error converting to ICO: $e');
    return null;
  }
}

class STFileImageFormat extends StatefulWidget {
  const STFileImageFormat({super.key});

  @override
  State<STFileImageFormat> createState() => _STFileImageFormatState();
}

class _STFileImageFormatState extends State<STFileImageFormat> {
  Uint8List? _originalImage;
  Uint8List? _convertedImage;
  String _selectedFormat = 'png'; // Default format is PNG

  // Pick an image
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
            print("Selected image: ${file.name}");
          });
        });
      }
    });
  }

  // Convert the image
  Future<void> _convertImage() async {
    if (_originalImage == null) {
      print("No image selected for conversion");
      return;
    }

    try {
      if (_selectedFormat == 'ico') {
        // Convert to ICO format, first ensure it is PNG
        final pngBytes = await _convertToPng(_originalImage!);
        _convertedImage = await convertPngToIco(pngBytes);
        setState(() {
          _convertedImage;
          print("Image successfully converted to $_selectedFormat format");
        });
      } else {
        // Create Canvas element for other format conversions
        final canvas = html.CanvasElement();
        final context = canvas.context2D;

        final originalImage = html.ImageElement();
        originalImage.src = html.Url.createObjectUrl(html.Blob([_originalImage!]));

        await originalImage.onLoad.first;

        canvas.width = originalImage.width;
        canvas.height = originalImage.height;
        context.drawImage(originalImage, 0, 0);

        // Generate image data based on selected format
        final mimeType = 'image/$_selectedFormat';
        final blob = await canvas.toBlob(mimeType);
        final reader = html.FileReader();
        reader.readAsArrayBuffer(blob);

        await reader.onLoad.first;

        setState(() {
          _convertedImage = reader.result as Uint8List?;
          print("Image successfully converted to $_selectedFormat format");
        });
      }
    } catch (e) {
      print("Error converting image: $e");
    }
  }

  // Convert to PNG format if necessary
  Future<Uint8List> _convertToPng(Uint8List imageBytes) async {
    // Create a canvas to convert the image to PNG
    final canvas = html.CanvasElement();
    final context = canvas.context2D;

    final originalImage = html.ImageElement();
    originalImage.src = html.Url.createObjectUrl(html.Blob([imageBytes]));

    await originalImage.onLoad.first;

    canvas.width = originalImage.width;
    canvas.height = originalImage.height;
    context.drawImage(originalImage, 0, 0);

    // Convert canvas to PNG
    final blob = await canvas.toBlob('image/png');
    final reader = html.FileReader();
    reader.readAsArrayBuffer(blob);
    await reader.onLoad.first;

    return reader.result as Uint8List;
  }

  // Save the converted image
  void _saveConvertedImage() {
    if (_convertedImage == null) {
      print("No converted image to save");
      return;
    }

    try {
      final blob = html.Blob([_convertedImage!]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "converted_image.$_selectedFormat")
        ..click();
      html.Url.revokeObjectUrl(url);
      print("Converted image saved successfully");
    } catch (e) {
      print("Error saving converted image: $e");
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
          DropdownButton<String>(
            value: _selectedFormat,
            onChanged: (String? newFormat) {
              setState(() {
                _selectedFormat = newFormat!;
              });
            },
            items: <String>['png', 'jpeg', 'webp', 'ico'] // Added ICO format option
                .map<DropdownMenuItem<String>>((String format) {
              return DropdownMenuItem<String>(
                value: format,
                child: Text(format.toUpperCase()),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _convertImage,
            child: const Text('Convert Image'),
          ),
          if (_convertedImage != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Image.memory(_convertedImage!),
            ),
          if (_convertedImage != null)
            ElevatedButton(
              onPressed: _saveConvertedImage,
              child: const Text('Save Converted Image'),
            ),
        ],
      ),
    );
  }
}
