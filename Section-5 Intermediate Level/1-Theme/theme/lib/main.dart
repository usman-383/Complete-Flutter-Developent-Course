import 'package:flutter/material.dart';
import 'Pages/home_page.dart';
import 'Theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      home: const HomePage(),

      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
