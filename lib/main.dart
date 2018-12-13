import 'package:flutter/material.dart';
import './view/topicListController.dart';

void main() => runApp(ReadhubApp());

class ReadhubApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readhub',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Color.fromARGB(255, 240, 240, 240),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Readhub"),), body: TopocListController(),);
  }
}
