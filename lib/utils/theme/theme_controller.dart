import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Controller for managing app theme (Light/Dark/System)
class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  /// Local storage instance
  final _storage = GetStorage();

  /// Key for storing theme preference
  static const String _themeKey = 'theme_mode';

  /// Current theme mode (reactive)
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  /// Getter for current theme mode
  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  /// Load theme preference from local storage
  void _loadThemeFromStorage() {
    final savedTheme = _storage.read(_themeKey);
    if (savedTheme != null) {
      switch (savedTheme) {
        case 'light':
          _themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          _themeMode.value = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode.value = ThemeMode.system;
          break;
      }
    }
    // Update the app theme
    Get.changeThemeMode(_themeMode.value);
  }

  /// Save theme preference to local storage
  void _saveThemeToStorage(ThemeMode mode) {
    String themeString;
    switch (mode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      case ThemeMode.system:
        themeString = 'system';
        break;
    }
    _storage.write(_themeKey, themeString);
  }

  /// Switch to light theme
  void setLightTheme() {
    _themeMode.value = ThemeMode.light;
    Get.changeThemeMode(ThemeMode.light);
    _saveThemeToStorage(ThemeMode.light);
  }

  /// Switch to dark theme
  void setDarkTheme() {
    _themeMode.value = ThemeMode.dark;
    Get.changeThemeMode(ThemeMode.dark);
    _saveThemeToStorage(ThemeMode.dark);
  }

  /// Switch to system theme
  void setSystemTheme() {
    _themeMode.value = ThemeMode.system;
    Get.changeThemeMode(ThemeMode.system);
    _saveThemeToStorage(ThemeMode.system);
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode.value == ThemeMode.light) {
      setDarkTheme();
    } else {
      setLightTheme();
    }
  }

  /// Check if current theme is dark
  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  /// Check if current theme is light
  bool get isLightMode {
    if (_themeMode.value == ThemeMode.system) {
      return !Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.light;
  }

  /// Check if current theme is system
  bool get isSystemMode => _themeMode.value == ThemeMode.system;

  /// Get theme mode as string for UI display
  String get themeModeString {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get theme mode icon
  IconData get themeModeIcon {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
