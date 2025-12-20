import 'package:shared_preferences/shared_preferences.dart';

/// Manages level progress persistence
class ProgressManager {
  static final ProgressManager _instance = ProgressManager._internal();
  factory ProgressManager() => _instance;
  ProgressManager._internal();

  static const String _currentLevelKey = 'current_level';
  static const String _unlockedLevelsKey = 'unlocked_levels';

  /// Get current level (default 1)
  Future<int> getCurrentLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentLevelKey) ?? 1;
  }

  /// Set current level
  Future<void> setCurrentLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentLevelKey, level);
  }

  /// Get highest unlocked level
  Future<int> getUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_unlockedLevelsKey) ?? 1;
  }

  /// Unlock a new level
  Future<void> unlockLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getUnlockedLevel();
    if (level > current) {
      await prefs.setInt(_unlockedLevelsKey, level);
    }
  }

  /// Check if a level is unlocked
  Future<bool> isLevelUnlocked(int level) async {
    final unlocked = await getUnlockedLevel();
    return level <= unlocked;
  }

  /// Get highest unlocked reverse mode level
  Future<int> getReverseUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('reverse_unlocked_level') ?? 1;
  }

  /// Unlock a reverse mode level
  Future<void> unlockReverseLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getReverseUnlockedLevel();
    if (level > current) {
      await prefs.setInt('reverse_unlocked_level', level);
    }
  }

  /// Save current game mode
  Future<void> setCurrentMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_mode', mode);
  }

  /// Get current game mode (default 'normal')
  Future<String> getCurrentMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_mode') ?? 'normal';
  }

  /// Get highest unlocked mirror mode level
  Future<int> getMirrorUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('mirror_unlocked_level') ?? 1;
  }

  /// Unlock a mirror mode level
  Future<void> unlockMirrorLevel(int level) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getMirrorUnlockedLevel();
    if (level > current) {
      await prefs.setInt('mirror_unlocked_level', level);
    }
  }
}
