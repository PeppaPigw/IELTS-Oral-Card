import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ielts_oral_reviser/features/settings/theme_mode_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeModeController', () {
    test('reads existing theme from preferences', () async {
      SharedPreferences.setMockInitialValues(
        <String, Object>{'theme_mode': 'dark'},
      );

      final controller = await ThemeModeController.create();
      expect(controller.themeMode, ThemeMode.dark);
    });

    test('reads existing font scale from preferences', () async {
      SharedPreferences.setMockInitialValues(
        <String, Object>{'font_scale': 1.2},
      );

      final controller = await ThemeModeController.create();
      expect(controller.fontScale, 1.2);
    });

    test('persists updated theme mode', () async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final controller = await ThemeModeController.create();

      await controller.updateThemeMode(ThemeMode.light);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_mode'), 'light');
      expect(controller.themeMode, ThemeMode.light);
    });

    test('persists updated font scale', () async {
      SharedPreferences.setMockInitialValues(const <String, Object>{});
      final controller = await ThemeModeController.create();

      await controller.updateFontScale(1.15);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getDouble('font_scale'), 1.15);
      expect(controller.fontScale, 1.15);
    });
  });
}
