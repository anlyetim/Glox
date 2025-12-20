import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/game_mode.dart';
import '../models/theme_config.dart';
import '../models/level.dart';
import '../services/progress_manager.dart';

/// Level selection screen with normal and invisible mode tabs
class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  int _unlockedLevel = 1;
  int _reverseUnlockedLevel = 1;
  int _mirrorUnlockedLevel = 1;
  int _selectedTab = 0; // 0 = Normal, 1 = Reverse, 2 = Mirror

  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
  }

  Future<void> _loadUnlockedLevels() async {
    final normalUnlocked = await ProgressManager().getUnlockedLevel();
    final reverseUnlocked = await ProgressManager().getReverseUnlockedLevel();
    final mirrorUnlocked = await ProgressManager().getMirrorUnlockedLevel();
    setState(() {
      _unlockedLevel = normalUnlocked;
      _reverseUnlockedLevel = reverseUnlocked;
      _mirrorUnlockedLevel = mirrorUnlocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeConfig = context.watch<ThemeConfig>();
    final gameState = context.read<GameState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Mode tabs
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeConfig.tileOffColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0
                            ? themeConfig.textColor.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.grid_3x3,
                            size: 20,
                            color: themeConfig.textColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Normal',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeConfig.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1
                            ? themeConfig.textColor.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sync,
                            size: 20,
                            color: themeConfig.textColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Reverse',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeConfig.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedTab == 2
                            ? themeConfig.textColor.withValues(alpha: 0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flip,
                            size: 20,
                            color: themeConfig.textColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Mirror',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeConfig.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Level grid
          Expanded(
            child: _selectedTab == 0
                ? _buildNormalLevels(gameState, themeConfig)
                : (_selectedTab == 1
                    ? _buildInvisibleLevels(gameState, themeConfig)
                    : _buildMirrorLevels(gameState, themeConfig)),
          ),
        ],
      ),
    );
  }

  Widget _buildNormalLevels(GameState gameState, ThemeConfig themeConfig) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: 50,
      itemBuilder: (context, index) {
        final levelNum = index + 1;
        final isUnlocked = levelNum <= _unlockedLevel;
        final difficulty = Difficulty.fromLevel(levelNum);
        final color = isUnlocked 
            ? difficulty.color 
            : difficulty.color.withValues(alpha: 0.3);

        return GestureDetector(
          onTap: isUnlocked
              ? () {
                  gameState.loadLevel(levelNum);
                  Navigator.pop(context);
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: gameState.levelNumber == levelNum && gameState.currentMode == GameMode.normal
                  ? Border.all(
                      color: themeConfig.textColor,
                      width: 3,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                '$levelNum',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvisibleLevels(GameState gameState, ThemeConfig themeConfig) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: 50, // 50 reverse mode levels
      itemBuilder: (context, index) {
        final levelNum = index + 1;
        // Separate progress tracking for reverse mode
        final isUnlocked = levelNum <= _reverseUnlockedLevel;
        final color = isUnlocked 
            ? Colors.white 
            : Colors.grey.shade700;

        return GestureDetector(
          onTap: isUnlocked
              ? () {
                  gameState.loadReverseLevel(levelNum);
                  Navigator.pop(context);
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: gameState.levelNumber == levelNum && gameState.currentMode == GameMode.reverse
                  ? Border.all(
                      color: themeConfig.textColor,
                      width: 3,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                '$levelNum',
                style: TextStyle(
                  color: isUnlocked ? Colors.black : Colors.grey.shade500,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMirrorLevels(GameState gameState, ThemeConfig themeConfig) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: 50, // 50 mirror mode levels
      itemBuilder: (context, index) {
        final levelNum = index + 1;
        // Separate progress tracking for mirror mode
        final isUnlocked = levelNum <= _mirrorUnlockedLevel;
        final color = isUnlocked 
            ? Colors.cyan 
            : Colors.cyan.withValues(alpha: 0.3);

        return GestureDetector(
          onTap: isUnlocked
              ? () {
                  gameState.loadMirrorLevel(levelNum);
                  Navigator.pop(context);
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: gameState.levelNumber == levelNum && gameState.currentMode == GameMode.mirror
                  ? Border.all(
                      color: themeConfig.textColor,
                      width: 3,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                '$levelNum',
                style: TextStyle(
                  color: isUnlocked ? Colors.white : Colors.cyan.withValues(alpha: 0.5),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
