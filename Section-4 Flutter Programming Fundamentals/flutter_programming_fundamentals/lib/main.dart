import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());

  print(
    "Hello, World!",
  ); // Print statement to display a message in the console.
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  //Variables: Used for storing different data types and values in the application.
  String name = "Usman dev";
  int age = 20;
  double height = 5.9;
  bool isStudent = true;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}
