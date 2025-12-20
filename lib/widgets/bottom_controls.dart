import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

/// Bottom controls with hint button, restart, and undo buttons
class BottomControls extends StatelessWidget {
  const BottomControls({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hint button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (!gameState.hasWon && gameState.canUseHint) 
                  ? () => gameState.getHint() 
                  : null,
              icon: const Icon(Icons.lightbulb_outline_rounded),
              label: Text(
                gameState.hintsRemaining >= 999
                    ? 'Hint (∞)'
                    : 'Hint (${gameState.hintsRemaining})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Restart and Undo buttons side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Restart button
              IconButton(
                onPressed: () => gameState.resetLevel(),
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Restart Level',
                iconSize: 32,
              ),

              // Undo button
              IconButton(
                onPressed: gameState.canUndo ? () => gameState.undo() : null,
                icon: const Icon(Icons.undo_rounded),
                tooltip: 'Undo (Geri Al)',
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
