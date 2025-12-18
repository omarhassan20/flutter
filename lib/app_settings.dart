import 'package:flutter/material.dart';

class AppSettings {
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));
}
