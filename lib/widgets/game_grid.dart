import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'game_tile.dart';

/// Game grid layout widget
class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final size = gameState.gridSize;

    // Calculate tile size with padding
    const padding = 24.0;
    const spacing = 12.0;

    return Padding(
      padding: const EdgeInsets.all(padding),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Grid
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemCount: size * size,
                  itemBuilder: (context, index) {
                    final row = index ~/ size;
                    final col = index % size;
                    return GameTile(row: row, col: col);
                  },
                ),
                
                // Mirror line for 4x4 mirror mode
                if (gameState.isMirrorMode && size == 4)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: (constraints.maxHeight / 2) - 1.5,
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.withValues(alpha: 0),
                            Colors.cyan.withValues(alpha: 0.9),
                            Colors.cyan.withValues(alpha: 0.9),
                            Colors.cyan.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
