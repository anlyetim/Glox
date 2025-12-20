import 'package:flutter/material.dart';

/// Theme types supported by the app
enum ThemeType {
  amoledDark,  // Pure black background - Full moon icon 🌕
  dark,        // Dark gray background - Half moon icon 🌓  
  light;       // White background - Sun icon ☀️

  /// Get icon for this theme
  IconData get icon {
    switch (this) {
      case ThemeType.amoledDark:
        return Icons.brightness_2; // Full moon
      case ThemeType.dark:
        return Icons.brightness_3; // Half moon
      case ThemeType.light:
        return Icons.wb_sunny; // Sun
    }
  }

  /// Cycle to next theme
  ThemeType get next {
    switch (this) {
      case ThemeType.amoledDark:
        return ThemeType.dark;
      case ThemeType.dark:
        return ThemeType.light;
      case ThemeType.light:
        return ThemeType.amoledDark;
    }
  }
}

/// Theme configuration for the app
class ThemeConfig extends ChangeNotifier {
  ThemeType _currentTheme = ThemeType.amoledDark; // Start with AMOLED dark

  ThemeType get currentTheme => _currentTheme;
  bool get isDark => _currentTheme != ThemeType.light;

  /// Toggle to next theme in cycle
  void cycleTheme() {
    _currentTheme = _currentTheme.next;
    notifyListeners();
  }

  /// Get background color based on theme
  Color get backgroundColor {
    switch (_currentTheme) {
      case ThemeType.amoledDark:
        return Colors.black; // Pure black #000000
      case ThemeType.dark:
        return const Color(0xFF121212); // Dark gray
      case ThemeType.light:
        return Colors.white; // White #FFFFFF
    }
  }

  /// Get text color based on theme
  Color get textColor => isDark ? Colors.white : Colors.black;

  /// Get tile OFF color based on theme
  Color get tileOffColor {
    switch (_currentTheme) {
      case ThemeType.amoledDark:
        return const Color(0xFF1A1A1A);
      case ThemeType.dark:
        return const Color(0xFF2C2C2C);
      case ThemeType.light:
        return const Color(0xFFF5F5F5);
    }
  }
}
