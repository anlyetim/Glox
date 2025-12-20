import 'package:flutter/material.dart';
import 'game_mode.dart';
import 'level.dart';

/// Generates reverse mode levels with varied starting patterns
class ReverseLevel {
  /// Generate reverse mode level - varied patterns, some tiles ON/OFF
  static Level fromNumber(int levelNumber) {
    const difficulty = Difficulty.medium;
    const gameMode = GameMode.reverse;
    
    // Get unique pattern for this level
    final pattern = _getPatternForLevel(levelNumber);
    
    return Level(
      gameMode: gameMode,
      number: levelNumber,
      gridSize: 3,
      difficulty: difficulty,
      initialState: pattern,
    );
  }
  
  /// Get unique starting pattern for each level
  static List<List<bool>> _getPatternForLevel(int level) {
    // 50 unique patterns - mix of ON and OFF tiles
    final patterns = [
      // Levels 1-10: Easy start, few tiles ON
      [[false, false, false], [false, false, false], [false, false, false]], // 1
      [[true, false, false], [false, false, false], [false, false, false]],  // 2
      [[false, true, false], [false, false, false], [false, false, false]],  // 3
      [[false, false, false], [false, true, false], [false, false, false]],  // 4
      [[true, false, true], [false, false, false], [false, false, false]],   // 5
      [[false, false, false], [true, false, true], [false, false, false]],   // 6
      [[true, false, false], [false, true, false], [false, false, false]],   // 7
      [[false, true, false], [true, false, false], [false, false, false]],   // 8
      [[true, false, false], [true, false, false], [false, false, false]],   // 9
      [[false, true, false], [false, true, false], [false, false, false]],   // 10
      
      // Levels 11-20: More tiles ON
      [[true, true, false], [false, false, false], [false, false, false]],   // 11
      [[false, false, false], [true, true, false], [false, false, false]],   // 12
      [[true, false, true], [false, false, false], [true, false, false]],    // 13
      [[false, true, false], [true, false, true], [false, false, false]],    // 14
      [[true, false, false], [false, true, false], [false, false, true]],    // 15
      [[false, false, true], [false, true, false], [true, false, false]],    // 16
      [[true, true, false], [true, false, false], [false, false, false]],    // 17
      [[false, true, true], [false, false, true], [false, false, false]],    // 18
      [[true, false, false], [true, true, false], [false, false, false]],    // 19
      [[false, false, true], [true, true, false], [false, false, false]],    // 20
      
      // Levels 21-30: Half ON/OFF
      [[true, false, true], [false, true, false], [false, false, false]],    // 21
      [[false, true, false], [true, false, true], [false, false, false]],    // 22
      [[true, true, false], [false, false, true], [false, false, false]],    // 23
      [[false, false, true], [false, true, false], [true, false, false]],    // 24
      [[true, false, false], [false, true, false], [true, false, true]],     // 25
      [[false, true, false], [true, false, false], [false, true, false]],    // 26
      [[true, false, true], [true, false, false], [false, false, false]],    // 27
      [[false, true, false], [false, true, true], [false, false, false]],    // 28
      [[true, true, false], [false, true, false], [false, false, false]],    // 29
      [[false, false, true], [true, false, true], [false, false, false]],    // 30
      
      // Levels 31-40: More complex
      [[true, false, true], [false, true, false], [true, false, false]],     // 31
      [[false, true, false], [true, false, true], [false, true, false]],     // 32
      [[true, true, false], [false, false, true], [true, false, false]],     // 33
      [[false, false, true], [true, true, false], [false, true, false]],     // 34
      [[true, false, false], [true, true, false], [false, false, true]],     // 35
      [[false, true, true], [false, true, false], [true, false, false]],     // 36
      [[true, false, true], [false, false, false], [true, false, true]],     // 37
      [[false, true, false], [true, true, true], [false, false, false]],     // 38
      [[true, true, false], [true, false, false], [false, false, true]],     // 39
      [[false, false, true], [false, true, false], [true, true, false]],     // 40
      
      // Levels 41-50: Hardest patterns
      [[true, false, true], [true, true, false], [false, false, true]],      // 41
      [[false, true, false], [true, false, true], [false, true, false]],     // 42
      [[true, true, false], [false, true, false], [true, false, true]],      // 43
      [[false, false, true], [true, true, false], [true, false, false]],     // 44
      [[true, false, false], [false, true, true], [false, false, true]],     // 45
      [[false, true, true], [true, false, false], [true, false, false]],     // 46
      [[true, false, true], [false, true, false], [true, false, true]],      // 47
      [[false, true, false], [true, true, true], [false, true, false]],      // 48
      [[true, true, false], [true, false, true], [false, true, false]],      // 49
      [[true, false, true], [false, true, false], [true, true, false]],      // 50
    ];
    
    return patterns[(level - 1) % patterns.length];
  }
  
  /// Win condition for reverse mode: ALL tiles must be ON
  static bool checkWin(List<List<bool>> grid) {
    for (var row in grid) {
      for (var tile in row) {
        if (!tile) return false;
      }
    }
    return true;
  }
}
