import 'package:flutter/material.dart';
import './view/topic_list_controller.dart';

void main() => runApp(ReadhubApp());

class ReadhubApp extends StatefulWidget {
  @override
  _ReadhubAppState createState() => _ReadhubAppState();
}

class _ReadhubAppState extends State<ReadhubApp> {
  // This widget is the root of your application.
  Brightness brightness =  Brightness.dark;

  @override
  Widget build(BuildContext context) {
    brightness ??= Brightness.light;
    final bool isDark = brightness == Brightness.dark;
    return MaterialApp(
      title: 'Readhub',
      theme: ThemeData(
        brightness: brightness,
        primarySwatch:  isDark ? Colors.grey : Colors.blueGrey,
        scaffoldBackgroundColor: isDark ? Color.fromARGB(255, 10, 10, 10) : Color.fromARGB(255, 240, 240, 240),
        cardColor: isDark ? Color.fromARGB(255, 20, 20, 20) : Colors.white,
        hintColor: Colors.white,
        buttonColor: Color.fromARGB(255, 240, 240, 240).withAlpha(200),
        textTheme: TextTheme(
          title: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1,
              color: isDark ? Color.fromARGB(255, 240, 240, 240) : Colors.black),
          overline: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: isDark ? Color.fromARGB(255, 165, 165, 165) : Color.fromARGB(255, 80, 80, 80)),
          caption: TextStyle(
              fontSize: 14,
              height: 1.2,
              fontWeight: FontWeight.normal,
              color: isDark ? Color.fromARGB(255, 235, 235, 235) : Color.fromARGB(255, 10, 10, 10)),
          subhead: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Color.fromARGB(255, 230, 230, 230) : Color.fromARGB(255, 15, 15, 15)),
          button: TextStyle(
              fontSize: 14,
              color: isDark ? Color.fromARGB(255, 240, 240, 240) : Colors.black,
              fontWeight: FontWeight.w500),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Readhub"),
      ),
      body: TopocListController(),
    );
  }
}
