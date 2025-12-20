import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../models/theme_config.dart';

/// Game tile with fade animation support for invisible mode
class GameTile extends StatefulWidget {
  final int row;
  final int col;

  const GameTile({
    super.key,
    required this.row,
    required this.col,
  });

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _opacityAnim;
  
  AnimationType _lastAnimType = AnimationType.none;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  int _calculateDelay(int gridSize) {
    // Sağ alttan sol üste: distance from bottom-right
    final distanceFromBottomRight = 
        (gridSize - 1 - widget.row) + (gridSize - 1 - widget.col);
    return distanceFromBottomRight * 50; // 50ms per step
  }

  void _triggerAnimation(AnimationType animType, int gridSize) {
    if (_lastAnimType == animType && _animController.isAnimating) return;
    
    _lastAnimType = animType;
    
    final delayMs = _calculateDelay(gridSize);
    
    Future.delayed(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      
      setState(() {
        if (animType == AnimationType.levelLoad) {
          // Fade in
          _opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut),
          );
        } else if (animType == AnimationType.restart) {
          // Fade out then fade in
          _opacityAnim = TweenSequence<double>([
            TweenSequenceItem(
              tween: Tween<double>(begin: 1.0, end: 0.0)
                  .chain(CurveTween(curve: Curves.easeIn)),
              weight: 50,
            ),
            TweenSequenceItem(
              tween: Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeOut)),
              weight: 50,
            ),
          ]).animate(_animController);
        }
      });
      
      _animController.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();
    final themeConfig = context.watch<ThemeConfig>();
    
    final isOn = gameState.grid[widget.row][widget.col];
    final isHint = gameState.hintTile == (widget.row, widget.col);
    
    // Color based on mode
    final Color accentColor;
    if (gameState.isReverseMode) {
      accentColor = Colors.white;
    } else if (gameState.isMirrorMode) {
      accentColor = Colors.cyan;
    } else {
      accentColor = gameState.difficulty.color;
    }
    
    // Animasyon tetikle
    if (gameState.currentAnimation != AnimationType.none &&
        gameState.currentAnimation != _lastAnimType) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerAnimation(
          gameState.currentAnimation,
          gameState.gridSize,
        );
      });
    }
    
    // Reset when animation done
    if (gameState.currentAnimation == AnimationType.none && 
        _lastAnimType != AnimationType.none) {
      _lastAnimType = AnimationType.none;
      if (_animController.isCompleted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _animController.reset();
          }
        });
      }
    }

    return GestureDetector(
      onTap: () => gameState.toggleTile(widget.row, widget.col),
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          // Level load/restart animation opacity
          double baseOpacity = gameState.currentAnimation == AnimationType.levelLoad ||
                  gameState.currentAnimation == AnimationType.restart
              ? _opacityAnim.value
              : 1.0;

          return Opacity(
            opacity: baseOpacity,
            child: AnimatedScale(
              scale: isOn ? 1.0 : 0.95,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isOn ? accentColor : themeConfig.tileOffColor,
                  borderRadius: BorderRadius.circular(12),
                  border: isHint
                      ? Border.all(
                          // Mode-specific hint colors
                          color: gameState.isReverseMode
                              ? Colors.white  // White for reverse mode
                              : (gameState.isMirrorMode
                                  ? Colors.cyan  // Cyan for mirror mode
                                  : (isOn ? themeConfig.backgroundColor : accentColor)),  // Normal mode
                          width: 3,
                        )
                      : null,
                  boxShadow: isOn
                      ? [
                          BoxShadow(
                            color: accentColor.withValues(alpha: 0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
