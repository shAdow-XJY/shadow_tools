import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'dart:ui_web' as ui_web;

import '../../components/iframe_widget.dart';

class STOtherCSSPreview extends StatefulWidget {
  const STOtherCSSPreview({super.key});

  @override
  State<STOtherCSSPreview> createState() => _STOtherCSSPreviewState();
}

class _STOtherCSSPreviewState extends State<STOtherCSSPreview> {
  String code = '''
<!DOCTYPE html>
<html>
<head>
<style>
  body {
    background-color: #f0f0f0;
  }
  .container {
    border: 1px solid #ccc;
    border-radius: 5px;
    background-color: #fff;
    padding: 20px;
  }
</style>
</head>
<body>
  <div class="container">
    <h1>Hello, World!</h1>
    <p>This is a simple HTML preview.</p>
  </div>
</body>
</html>
''';

  late html.IFrameElement _iframeElement;

  @override
  void initState() {
    super.initState();
    _iframeElement = html.IFrameElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.border = 'none';

    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _iframeElement.id,
          (int viewId) => _iframeElement,
    );

    _updatePreview();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('HTML & CSS Code',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextField(
                  maxLines: 15,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    // 直接将输入内容设置为 IFrame 的 srcdoc
                    code = value;
                    _updatePreview();
                  },
                  controller: TextEditingController(text: code),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 1,
          child: Container(
            height: 400,
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: STIframeWidget(iframeElement: _iframeElement), // 使用自定义 Widget
          ),
        ),
      ],
    );
  }

  void _updatePreview() {
    _iframeElement.srcdoc = code;
  }
}
