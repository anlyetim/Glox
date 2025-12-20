import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/theme_config.dart';
import '../widgets/mute_button.dart';
import '../screens/level_selection_screen.dart';

/// Top bar with level indicator (difficulty colored), theme toggle, and mute button
class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final themeConfig = context.watch<ThemeConfig>();

    return AppBar(
      // Tappable level indicator with difficulty color
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LevelSelectionScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: gameState.isReverseMode 
                  ? Colors.white 
                  : (gameState.isMirrorMode 
                      ? Colors.cyan 
                      : gameState.difficulty.color),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${gameState.levelNumber}',
                style: TextStyle(
                  color: gameState.isReverseMode ? Colors.black : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Level ${gameState.levelNumber}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (gameState.isReverseMode) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.sync,
              size: 20,
            ),
          ],
          if (gameState.isMirrorMode) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.flip,
              size: 20,
            ),
          ],
        ],
      ),
      
      // Theme toggle and mute button on the right
      actions: [
        // Theme toggle with proper icon
        IconButton(
          icon: Icon(themeConfig.currentTheme.icon),
          onPressed: () => themeConfig.cycleTheme(),
          tooltip: 'Change Theme',
        ),
        
        // Mute button (stateful)
        const MuteButton(),
        
        const SizedBox(width: 8),
      ],
    );
  }
}
