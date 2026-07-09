import 'dart:io';

class ThemeStorage {
  static String? overridePath;

  static Future<bool?> loadIsDarkMode() async {
    try {
      final file = await _themeFile();

      if (!await file.exists()) {
        return null;
      }

      final value = await file.readAsString();
      final normalizedValue = value.trim().toLowerCase();

      if (normalizedValue == 'dark') {
        return true;
      }

      if (normalizedValue == 'light') {
        return false;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveIsDarkMode(bool isDarkMode) async {
    try {
      final file = await _themeFile();
      await file.parent.create(recursive: true);
      await file.writeAsString(isDarkMode ? 'dark' : 'light');
    } catch (_) {
      // Ignore storage failures and keep the theme toggle working.
    }
  }

  static Future<File> _themeFile() async {
    final path = overridePath ?? _defaultPath();
    return File(path);
  }

  static String _defaultPath() {
    final baseDirectory = _baseDirectory();
    return '${baseDirectory.path}${Platform.pathSeparator}theme_mode.txt';
  }

  static Directory _baseDirectory() {
    final home = Platform.environment['HOME'];

    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null && appData.isNotEmpty) {
        return Directory(appData);
      }
    }

    if (Platform.isMacOS) {
      if (home != null && home.isNotEmpty) {
        return Directory('$home/Library/Application Support');
      }
    }

    if (Platform.isLinux) {
      final configHome = Platform.environment['XDG_CONFIG_HOME'];
      if (configHome != null && configHome.isNotEmpty) {
        return Directory(configHome);
      }

      if (home != null && home.isNotEmpty) {
        return Directory('$home/.config');
      }
    }

    if (home != null && home.isNotEmpty) {
      return Directory(home);
    }

    return Directory.current;
  }
}
