import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// Animated 4x4 grid background for main menu
class AnimatedGridBackground extends StatefulWidget {
  final Color accentColor;
  final double opacity;

  const AnimatedGridBackground({
    super.key,
    required this.accentColor,
    this.opacity = 0.3,
  });

  @override
  State<AnimatedGridBackground> createState() => _AnimatedGridBackgroundState();
}

class _AnimatedGridBackgroundState extends State<AnimatedGridBackground> {
  final List<List<bool>> _grid = List.generate(4, (_) => List.filled(4, false));
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!mounted) return;
      
      setState(() {
        // Randomly toggle 1-2 tiles
        final toggleCount = _random.nextInt(2) + 1;
        for (int i = 0; i < toggleCount; i++) {
          final row = _random.nextInt(4);
          final col = _random.nextInt(4);
          _grid[row][col] = !_grid[row][col];
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 16,
      itemBuilder: (context, index) {
        final row = index ~/ 4;
        final col = index % 4;
        final isOn = _grid[row][col];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isOn
                ? widget.accentColor.withValues(alpha: widget.opacity)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.accentColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        );
      },
    );
  }
}
