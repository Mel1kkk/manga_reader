import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ghoul_reader/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _setSystemUI();
    notifyListeners();
  }

  ThemeProvider() {
    _loadTheme(); // Загружаем сохранённую тему при инициализации
  }

  // Метод загрузки темы из SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      _themeData = isDarkTheme ? darkMode : lightMode;
      _setSystemUI();
      notifyListeners();
    } catch (e) {
      print("Ошибка загрузки темы: $e");
    }
  }

  // Метод переключения темы и её сохранения
  Future<void> toggleTheme() async {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkTheme', _themeData == darkMode);
    } catch (e) {
      print("Ошибка сохранения темы: $e");
    }
  }

  void _setSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            _themeData == darkMode ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness:
            _themeData == darkMode ? Brightness.light : Brightness.dark,
      ),
    );
  }
}
