import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/theme_config.dart';
import '../widgets/animated_grid_background.dart';
import '../utils/slide_page_route.dart';
import '../screens/game_screen.dart';
import '../screens/level_selection_screen.dart';

/// Main menu screen with animated background
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final themeConfig = context.watch<ThemeConfig>();
    // Use mode-specific colors
    final accentColor = gameState.isReverseMode 
        ? Colors.white 
        : (gameState.isMirrorMode 
            ? Colors.cyan 
            : gameState.difficulty.color);

    return Scaffold(
      body: Stack(
        children: [
          // Animated grid background
          Container(
            color: themeConfig.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: AnimatedGridBackground(
                accentColor: accentColor,
                opacity: 0.3,
              ),
            ),
          ),

          // Semi-transparent overlay
          Container(
            color: themeConfig.backgroundColor.withValues(alpha: 0.7),
          ),

          // Menu content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'GLOX',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                      letterSpacing: 8,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Lights Off Puzzle',
                    style: TextStyle(
                      fontSize: 18,
                      color: themeConfig.textColor.withValues(alpha: 0.6),
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 80),

                  // Continue Button
                  _MenuButton(
                    label: 'CONTINUE',
                    icon: Icons.play_arrow,
                    color: accentColor,
                    onTap: () {
                      Navigator.of(context).push(
                        SlidePageRoute(page: const GameScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Level Select Button
                  _MenuButton(
                    label: 'LEVEL SELECT',
                    icon: Icons.grid_3x3,
                    color: themeConfig.textColor.withValues(alpha: 0.8),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LevelSelectionScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Exit Button
                  _MenuButton(
                    label: 'EXIT',
                    icon: Icons.exit_to_app,
                    color: themeConfig.textColor.withValues(alpha: 0.6),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),

                  const SizedBox(height: 60),

                  // Level info
                  Text(
                    'Level ${gameState.levelNumber}',
                    style: TextStyle(
                      fontSize: 14,
                      color: themeConfig.textColor.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu button widget
class _MenuButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
