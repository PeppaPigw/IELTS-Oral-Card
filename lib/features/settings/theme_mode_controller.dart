import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeController extends ChangeNotifier {
  ThemeModeController._(this._prefs, this._themeMode, this._fontScale);

  static const String _themeModeKey = 'theme_mode';
  static const String _fontScaleKey = 'font_scale';
  final SharedPreferences _prefs;

  ThemeMode _themeMode;
  double _fontScale;

  ThemeMode get themeMode => _themeMode;
  double get fontScale => _fontScale;

  static Future<ThemeModeController> create() async {
    final prefs = await SharedPreferences.getInstance();
    final rawMode = prefs.getString(_themeModeKey);
    final rawScale = prefs.getDouble(_fontScaleKey);
    final themeMode = switch (rawMode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final fontScale = (rawScale ?? 1.0).clamp(0.85, 1.35);
    return ThemeModeController._(prefs, themeMode, fontScale);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) {
      return;
    }
    _themeMode = mode;
    notifyListeners();
    final encoded = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _prefs.setString(_themeModeKey, encoded);
  }

  Future<void> updateFontScale(double scale) async {
    final normalized = scale.clamp(0.85, 1.35);
    if ((_fontScale - normalized).abs() < 0.001) {
      return;
    }
    _fontScale = normalized;
    notifyListeners();
    await _prefs.setDouble(_fontScaleKey, normalized);
  }

  Future<void> resetFontScale() async {
    await updateFontScale(1.0);
  }
}
