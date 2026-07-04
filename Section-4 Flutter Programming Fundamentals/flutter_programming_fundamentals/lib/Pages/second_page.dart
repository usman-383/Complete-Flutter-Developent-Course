// ignore_for_file: sort_child_properties_last
// import 'package:flutter_programming_fundamentals/Pages/first_page.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Second Page")),
        backgroundColor: Colors.blueAccent,
      ),

      body: Center(
        child: Container(
          child: Center(child: Text("Hello")),
          height: 200,
          width: 200,
          color: Colors.lightGreen,
        ),
      ),
    );
  }
}
