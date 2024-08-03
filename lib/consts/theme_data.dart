import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor:

      isDarkTheme ? const Color(0xFF00001a) : const Color(0xFFFFFFFF),
      primaryColor: const Color.fromRGBO(239, 208, 77, 1.0),
      colorScheme: ThemeData().colorScheme.copyWith(
        secondary:
        isDarkTheme ? Color(0xff2c2727) : const Color(0xFFE8FDFD),
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      cardColor:
      isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
    );
  }
}