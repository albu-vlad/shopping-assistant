import 'package:flutter/material.dart';
import 'package:shopping_assistant/ui/assistant_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Assistant"),
        backgroundColor: Colors.black54,
      ),
      body: new AssistantScreen(),
    );
  }
}
