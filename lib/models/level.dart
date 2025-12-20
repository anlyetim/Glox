import 'package:flutter/material.dart';
import 'game_mode.dart';

/// Difficulty levels for the game
enum Difficulty {
  veryEasy,
  easy,
  medium,
  hard,
  veryHard;

  /// Get accent color for this difficulty
  Color get color {
    switch (this) {
      case Difficulty.veryEasy:
      case Difficulty.easy:
        return const Color(0xFF4CAF50); // GREEN
      case Difficulty.medium:
        return const Color(0xFFFFC107); // YELLOW (changed from ORANGE)
      case Difficulty.hard:
        return const Color(0xFFF44336); // RED
      case Difficulty.veryHard:
        return const Color(0xFF9C27B0); // PURPLE
    }
  }

  /// Get difficulty based on level number
  static Difficulty fromLevel(int level) {
    if (level <= 3) return Difficulty.veryEasy;
    if (level <= 8) return Difficulty.easy;
    if (level <= 15) return Difficulty.medium;
    if (level <= 25) return Difficulty.hard;
    return Difficulty.veryHard;
  }
}

/// Represents a single level in the game
class Level {
  final int number;
  final int gridSize;
  final List<List<bool>>? initialState; // null means generate from seed
  final int? seed;
  final Difficulty difficulty;
  final GameMode gameMode;

  const Level({
    required this.number,
    this.gridSize = 5,
    this.initialState,
    this.seed,
    required this.difficulty,
    this.gameMode = GameMode.normal,
  });

  /// Create a level based on level number with progressive difficulty
  factory Level.fromNumber(int levelNumber) {
    final difficulty = Difficulty.fromLevel(levelNumber);
    
    // All main progression levels are normal mode
    // Invisible mode is accessed separately
    const gameMode = GameMode.normal;
    
    // First 10 levels: Predefined 3x3 patterns (1-2 moves each)
    // These are designed to teach mechanics gradually
    
    if (levelNumber == 1) {
      // Level 1 (1 move): Tap top-middle
      return Level(
        gameMode: gameMode,
        number: 1,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [true, true, false],   // ON  | ON  | OFF
          [true, false, false],  // ON  | OFF | OFF
          [false, false, false], // OFF | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 2) {
      // Level 2 (1 move): Tap top-middle
      return Level(
        gameMode: gameMode,
        number: 2,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [false, true, false],  // OFF | ON  | OFF
          [true, false, false],  // ON  | OFF | OFF
          [false, false, false], // OFF | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 3) {
      // Level 3 (1 move): Tap center
      return Level(
        gameMode: gameMode,
        number: 3,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [true, false, false],  // ON  | OFF | OFF
          [false, true, false],  // OFF | ON  | OFF
          [false, false, false], // OFF | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 4) {
      // Level 4 (2 moves)
      return Level(
        gameMode: gameMode,
        number: 4,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [false, false, true],  // OFF | OFF | ON
          [false, false, false], // OFF | OFF | OFF
          [true, false, false],  // ON  | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 5) {
      // Level 5 (2 moves)
      return Level(
        gameMode: gameMode,
        number: 5,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [true, false, true],   // ON  | OFF | ON
          [false, false, false], // OFF | OFF | OFF
          [false, true, false],  // OFF | ON  | OFF
        ],
      );
    }
    
    if (levelNumber == 6) {
      // Level 6 (1-2 moves)
      return Level(
        gameMode: gameMode,
        number: 6,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [true, false, false],  // ON  | OFF | OFF
          [false, true, true],   // OFF | ON  | ON
          [false, false, false], // OFF | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 7) {
      // Level 7 (2 moves)
      return Level(
        gameMode: gameMode,
        number: 7,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [false, true, false],  // OFF | ON  | OFF
          [true, false, true],   // ON  | OFF | ON
          [false, false, false], // OFF | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 8) {
      // Level 8 (2 moves)
      return Level(
        gameMode: gameMode,
        number: 8,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [true, false, true],   // ON  | OFF | ON
          [false, false, false], // OFF | OFF | OFF
          [true, false, false],  // ON  | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 9) {
      // Level 9 (1 move): Tap center
      return Level(
        gameMode: gameMode,
        number: 9,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [false, false, true],  // OFF | OFF | ON
          [false, true, false],  // OFF | ON  | OFF
          [false, false, false], // OFF | OFF | OFF
        ],
      );
    }
    
    if (levelNumber == 10) {
      // Level 10 (2 moves)
      return Level(
        gameMode: gameMode,
        number: 10,
        gridSize: 3,
        difficulty: difficulty,
        initialState: const [
          [true, false, false],  // ON  | OFF | OFF
          [false, false, true],  // OFF | OFF | ON
          [false, true, false],  // OFF | ON  | OFF
        ],
      );
    }

    // Progressive grid sizing for levels 11+
    int size;
    if (levelNumber <= 15) {
      size = 3; // Still 3x3 for levels 11-15
    } else if (levelNumber <= 25) {
      size = 4; // 4x4 for levels 16-25
    } else {
      size = 5; // 5x5 for levels 26+
    }

    return Level(
        gameMode: gameMode,
      number: levelNumber,
      gridSize: size,
      difficulty: difficulty,
      seed: levelNumber,
    );
  }

  /// Generate initial state from seed if not predefined
  List<List<bool>> getInitialState() {
    if (initialState != null) {
      return initialState!.map((row) => List<bool>.from(row)).toList();
    }

    // Generate from seed with difficulty-appropriate complexity
    final random = _SeededRandom(seed ?? number);
    
    // For easier levels, use simpler symmetric patterns
    if (difficulty == Difficulty.veryEasy || difficulty == Difficulty.easy) {
      return _generateSymmetricPattern(random);
    }
    
    // For harder levels, use more random patterns
    return List.generate(
      gridSize,
      (i) => List.generate(
        gridSize,
        (j) => random.nextBool(),
      ),
    );
  }

  /// Generate symmetric pattern for easier levels
  List<List<bool>> _generateSymmetricPattern(_SeededRandom random) {
    final grid = List.generate(
      gridSize,
      (i) => List.generate(gridSize, (j) => false),
    );

    // Fill upper-left quadrant randomly
    for (int i = 0; i <= gridSize ~/ 2; i++) {
      for (int j = 0; j <= gridSize ~/ 2; j++) {
        final value = random.nextBool();
        grid[i][j] = value;
        // Mirror to other quadrants
        grid[i][gridSize - 1 - j] = value;
        grid[gridSize - 1 - i][j] = value;
        grid[gridSize - 1 - i][gridSize - 1 - j] = value;
      }
    }

    return grid;
  }
}

/// Simple seeded random generator for consistent level generation
class _SeededRandom {
  int _seed;

  _SeededRandom(int seed) : _seed = seed;

  bool nextBool() {
    _seed = ((_seed * 1103515245) + 12345) & 0x7fffffff;
    return (_seed ~/ 65536) % 2 == 0;
  }

  int nextInt(int max) {
    _seed = ((_seed * 1103515245) + 12345) & 0x7fffffff;
    return _seed % max;
  }
}
