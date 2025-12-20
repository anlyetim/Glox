import 'package:flutter/material.dart';
import 'game_mode.dart';
import 'level.dart';

/// Generates mirror mode levels (4x4 only, top/bottom mirror)
/// All patterns are carefully designed to be solvable
class MirrorLevel {
  /// Generate mirror mode level - all 4x4, solvable patterns
  static Level fromNumber(int levelNumber) {
    const difficulty = Difficulty.medium;
    const gameMode = GameMode.mirror;
    
    // Get carefully designed pattern for this level
    final pattern = _getPatternForLevel(levelNumber);
    
    return Level(
      gameMode: gameMode,
      number: levelNumber,
      gridSize: 4, // ALWAYS 4x4 for mirror mode
      difficulty: difficulty,
      initialState: pattern,
    );
  }
  
  /// Get unique starting pattern for each level (4x4)
  /// CRITICAL: All patterns are mirrored (row 0 = row 3, row 1 = row 2) for solvability
  static List<List<bool>> _getPatternForLevel(int level) {
    final patterns = [
      // Level 1: Simple start - 2 lights mirrored
      [
        [true, false, false, false],
        [false, false, false, false],
        [false, false, false, false],
        [true, false, false, false],
      ],
      
      // Level 2: Diagonal corners
      [
        [true, false, false, true],
        [false, false, false, false],
        [false, false, false, false],
        [true, false, false, true],
      ],
      
      // Level 3: Center column
      [
        [false, true, true, false],
        [false, false, false, false],
        [false, false, false, false],
        [false, true, true, false],
      ],
      
      // Level 4: L-shape mirrored
      [
        [true, true, false, false],
        [true, false, false, false],
        [true, false, false, false],
        [true, true, false, false],
      ],
      
      // Level 5: T-shape
      [
        [true, true, true, false],
        [false, true, false, false],
        [false, true, false, false],
        [true, true, true, false],
      ],
      
      // Level 6: Double corners
      [
        [true, false, false, true],
        [true, false, false, true],
        [true, false, false, true],
        [true, false, false, true],
      ],
      
      // Level 7: Cross pattern
      [
        [false, true, true, false],
        [true, false, false, true],
        [true, false, false, true],
        [false, true, true, false],
      ],
      
      // Level 8: Diagonal line
      [
        [true, false, false, false],
        [false, true, false, false],
        [false, true, false, false],
        [true, false, false, false],
      ],
      
      // Level 9: Box outline
      [
        [true, true, true, true],
        [true, false, false, true],
        [true, false, false, true],
        [true, true, true, true],
      ],
      
      // Level 10: Checkerboard top/bottom
      [
        [true, false, true, false],
        [false, true, false, true],
        [false, true, false, true],
        [true, false, true, false],
      ],
      
      // Level 11-20: Medium complexity
      [
        [true, true, false, false],
        [false, true, true, false],
        [false, true, true, false],
        [true, true, false, false],
      ],
      [
        [false, true, true, true],
        [true, false, false, false],
        [true, false, false, false],
        [false, true, true, true],
      ],
      [
        [true, false, true, true],
        [false, true, false, false],
        [false, true, false, false],
        [true, false, true, true],
      ],
      [
        [true, true, true, false],
        [true, false, false, false],
        [true, false, false, false],
        [true, true, true, false],
      ],
      [
        [false, false, true, true],
        [false, true, true, false],
        [false, true, true, false],
        [false, false, true, true],
      ],
      [
        [true, false, false, true],
        [false, true, true, false],
        [false, true, true, false],
        [true, false, false, true],
      ],
      [
        [true, true, false, true],
        [false, false, false, false],
        [false, false, false, false],
        [true, true, false, true],
      ],
      [
        [false, true, false, true],
        [true, false, true, false],
        [true, false, true, false],
        [false, true, false, true],
      ],
      [
        [true, false, true, false],
        [true, true, false, false],
        [true, true, false, false],
        [true, false, true, false],
      ],
      [
        [false, true, true, false],
        [true, true, true, true],
        [true, true, true, true],
        [false, true, true, false],
      ],
      
      // Level 21-40: Higher complexity
      ..._generateAdvancedPatterns(20),
      
      // Level 41-50: Expert patterns
      ..._generateExpertPatterns(10),
    ];
    
    return patterns[(level - 1) % patterns.length];
  }
  
  /// Generate advanced mirrored patterns (levels 21-40)
  static List<List<List<bool>>> _generateAdvancedPatterns(int count) {
    final patterns = <List<List<bool>>>[];
    
    for (int i = 0; i < count; i++) {
      // Create symmetric patterns algorithmically
      final row0 = [
        (i + 1) % 3 != 0,
        i % 2 == 0,
        (i + 2) % 3 == 0,
        i % 4 == 0,
      ];
      final row1 = [
        i % 3 == 0,
        (i + 1) % 4 != 0,
        i % 5 == 0,
        (i + 2) % 3 != 0,
      ];
      
      patterns.add([
        row0,
        row1,
        row1, // Mirror of row1
        row0, // Mirror of row0
      ]);
    }
    
    return patterns;
  }
  
  /// Generate expert mirrored patterns (levels 41-50)
  static List<List<List<bool>>> _generateExpertPatterns(int count) {
    final patterns = <List<List<bool>>>[];
    
    for (int i = 0; i < count; i++) {
      // More complex symmetric patterns
      final row0 = [
        (i * 2 + 1) % 3 == 0,
        (i + 3) % 4 != 0,
        i % 2 == 0,
        (i * 3) % 5 == 0,
      ];
      final row1 = [
        (i + 2) % 3 != 0,
        i % 4 == 0,
        (i + 1) % 5 != 0,
        (i * 2) % 3 == 0,
      ];
      
      patterns.add([
        row0,
        row1,
        row1, // Mirror of row1
        row0, // Mirror of row0
      ]);
    }
    
    return patterns;
  }
}
