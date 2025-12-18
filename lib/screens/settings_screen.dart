import 'package:flutter/material.dart';
import '../main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SwitchListTile(
        title: const Text('Dark Mode'),
        value: isDark,
        onChanged: (value) {
          MyApp.of(context)?.toggleTheme(value);
        },
      ),
    );
  }
}
