import 'dart:html' as html;

class ThemeStorage {
  static String? overridePath;

  static const String _storageKey = 'theme_is_dark_mode';

  static Future<bool?> loadIsDarkMode() async {
    final value = html.window.localStorage[_storageKey];

    if (value == null) {
      return null;
    }

    if (value == 'dark') {
      return true;
    }

    if (value == 'light') {
      return false;
    }

    return null;
  }

  static Future<void> saveIsDarkMode(bool isDarkMode) async {
    html.window.localStorage[_storageKey] = isDarkMode ? 'dark' : 'light';
  }
}
