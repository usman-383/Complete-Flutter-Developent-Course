import 'package:flutter/material.dart';
import 'Pages/home_page.dart';
import 'Theme/theme.dart';
import 'Theme/theme_storage.dart';

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

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await ThemeStorage.loadIsDarkMode();

    if (!mounted) {
      return;
    }

    setState(() {
      isDarkMode = savedTheme ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final newValue = !isDarkMode;

    await ThemeStorage.saveIsDarkMode(newValue);

    setState(() {
      isDarkMode = newValue;
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
