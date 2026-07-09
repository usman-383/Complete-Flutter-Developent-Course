import 'package:flutter/material.dart';
import 'package:theme/Components/button.dart';
import '../Components/box.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const HomePage({super.key, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text(isDarkMode ? 'Dark Mode' : 'Light Mode')),
      body: Center(
        child: MyBox(
          color: Theme.of(context).colorScheme.primary,
          child: MyButton(
            color: Theme.of(context).colorScheme.secondary,
            onTap: onThemeToggle,
          ),
        ),
      ),
    );
  }
}
