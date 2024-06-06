import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      surface: Colors.grey.shade50,
      inverseSurface: Colors.grey.shade900,
      primary: Colors.grey.shade300,
      inversePrimary: Colors.grey.shade600,
      secondary: Colors.grey.shade400,
      tertiary: Colors.blue.shade300,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: Colors.grey.shade800,
          displayColor: Colors.black,
        ),
  );

  final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      inverseSurface: Colors.grey.shade50,
      primary: Colors.grey.shade800,
      inversePrimary: Colors.grey.shade100,
      secondary: Colors.grey.shade700,
      tertiary: Colors.blue.shade300,
    ),
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.grey.shade300,
          displayColor: Colors.white,
        ),
  );

  bool _isDark = false;

  bool get isDark => _isDark;
  ThemeData get theme => _isDark ? _darkTheme : _lightTheme;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
