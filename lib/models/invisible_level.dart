import 'package:flutter/material.dart';
import 'game_mode.dart';
import 'level.dart';

/// Generates easier invisible mode levels (3x3 only, simpler patterns)
class InvisibleLevel {
  /// Generate invisible mode level - all 3x3, easier than normal progression
  static Level fromNumber(int levelNumber) {
    // All invisible levels are "easy" difficulty for balance
    const difficulty = Difficulty.easy;
    const gameMode = GameMode.invisible;
    
    // Predefined easier patterns for levels 1-20
    if (levelNumber <= 20) {
      return Level(
        gameMode: gameMode,
        number: levelNumber,
        gridSize: 3,
        difficulty: difficulty,
        initialState: _getEasyPattern(levelNumber),
      );
    }
    
    // Levels 21-50: Still easy 3x3 with slightly more complexity
    return Level(
      gameMode: gameMode,
      number: levelNumber,
      gridSize: 3,
      difficulty: difficulty,
      initialState: _getModeratePattern(levelNumber),
    );
  }
  
  /// Easy patterns for first 20 levels (1-2 moves)
  static List<List<bool>> _getEasyPattern(int level) {
    final patterns = [
      // Level 1-5: Single tile or corner patterns
      [[true, false, false], [false, false, false], [false, false, false]],
      [[false, true, false], [false, false, false], [false, false, false]],
      [[false, false, false], [false, true, false], [false, false, false]],
      [[true, false, true], [false, false, false], [false, false, false]],
      [[false, false, false], [true, false, true], [false, false, false]],
      
      // Level 6-10: Simple symmetrical
      [[true, false, true], [false, false, false], [true, false, true]],
      [[false, true, false], [true, false, true], [false, true, false]],
      [[true, true, false], [true, false, false], [false, false, false]],
      [[false, false, true], [false, false, true], [true, true, false]],
      [[true, false, false], [false, true, false], [false, false, true]],
      
      // Level 11-15: Cross patterns
      [[false, true, false], [true, true, true], [false, true, false]],
      [[true, false, true], [false, true, false], [true, false, true]],
      [[false, true, false], [false, true, false], [false, true, false]],
      [[true, true, true], [false, false, false], [false, false, false]],
      [[false, false, false], [true, true, true], [false, false, false]],
      
      // Level 16-20: Slightly more complex
      [[true, false, true], [false, true, false], [false, false, false]],
      [[false, true, false], [true, false, true], [false, false, false]],
      [[true, true, false], [false, true, true], [false, false, false]],
      [[true, false, false], [true, true, false], [true, false, false]],
      [[false, true, true], [true, false, false], [false, false, true]],
    ];
    
    return patterns[(level - 1) % patterns.length];
  }
  
  /// Moderate patterns for levels 21-50 (2-3 moves)
  static List<List<bool>> _getModeratePattern(int level) {
    final patterns = [
      [[true, true, true], [true, false, true], [true, true, true]],
      [[false, true, false], [true, false, true], [false, true, false]],
      [[true, false, true], [true, true, true], [true, false, true]],
      [[true, true, false], [true, false, true], [false, true, true]],
      [[false, true, true], [true, true, false], [true, false, true]],
      [[true, false, true], [false, false, false], [true, false, true]],
      [[false, false, false], [true, true, true], [false, false, false]],
      [[true, true, true], [false, false, false], [true, true, true]],
      [[false, true, false], [true, true, true], [true, false, true]],
      [[true, false, true], [true, false, true], [false, true, false]],
    ];
    
    return patterns[(level - 1) % patterns.length];
  }
}
