import 'package:flutter/material.dart';
import 'Pages/home_page.dart';
import 'Theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      home: HomePage(onThemeToggle: toggleTheme),

      theme: lightMode,
      darkTheme: darkMode,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
    );
  }
}
