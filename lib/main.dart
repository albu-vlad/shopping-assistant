import 'package:flutter/material.dart';
import 'package:shopping_assistant/ui/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Shopping Assistant',
      home: new Home(),
    );
  }
}

