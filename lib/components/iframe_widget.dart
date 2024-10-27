import 'dart:html' as html;
import 'package:flutter/material.dart';

class STIframeWidget extends StatelessWidget {
  final html.IFrameElement iframeElement;

  const STIframeWidget({super.key, required this.iframeElement});

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: iframeElement.id); // 使用 iframeElement.id
  }
}