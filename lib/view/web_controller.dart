import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebController extends StatelessWidget {

  final title;
  final url;

  WebController({this.title, this.url});

  @override
  Widget build(BuildContext context) {
    return  WebviewScaffold(
      url: url,
      appBar:  AppBar(
        title:  Text(title),
      ), withJavascript: true,
    );
  }
}