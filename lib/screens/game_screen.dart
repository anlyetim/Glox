import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/top_bar.dart';
import '../widgets/game_grid.dart';
import '../widgets/bottom_controls.dart';

/// Main game screen with win glow border
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _lastWinState = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    
    // Kazanma anında glow başlat
    if (gameState.hasWon && !_lastWinState) {
      _glowController.forward();
      _lastWinState = true;
    } else if (!gameState.hasWon && _lastWinState) {
      _glowController.reverse();
      _lastWinState = false;
    }

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: gameState.difficulty.color.withValues(
                alpha: _glowAnimation.value * 0.8,
              ),
              width: 4,
            ),
            boxShadow: _glowAnimation.value > 0.1
                ? [
                    BoxShadow(
                      color: gameState.difficulty.color.withValues(
                        alpha: _glowAnimation.value * 0.6,
                      ),
                      blurRadius: 20 * _glowAnimation.value,
                      spreadRadius: 5 * _glowAnimation.value,
                    ),
                  ]
                : null,
          ),
          child: Scaffold(
            appBar: const TopBar(),
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Game grid (centered)
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: const GameGrid(),
                      ),
                    ),
                  ),

                  // Bottom controls
                  const BottomControls(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
