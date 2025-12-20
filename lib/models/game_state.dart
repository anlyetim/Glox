import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/level.dart';
import '../models/game_mode.dart';
import '../models/reverse_level.dart';
import '../models/mirror_level.dart';
import '../logic/lights_off_logic.dart';
import '../logic/solver.dart';
import '../services/sound_manager.dart';
import '../services/progress_manager.dart';

class _Move {
  final int row;
  final int col;
  final List<List<bool>> gridBefore;
  _Move(this.row, this.col, this.gridBefore);
}

enum AnimationType {
  none,
  levelLoad,      // Yeni level yükleniyor (sağ alt → sol üst)
  restart,        // Restart animasyonu (sağ alt → sol üst)
}

/// Game state with advanced animations
class GameState extends ChangeNotifier {
  late Level _currentLevel;
  late List<List<bool>> _grid;
  int _moveCount = 0;
  (int, int)? _hintTile;
  final List<_Move> _moveHistory = [];
  AnimationType _currentAnimation = AnimationType.none;
  GameMode _currentMode = GameMode.normal;
  int _hintsRemaining = 999; // Start with unlimited
  
  // Invisible mode: track last tap time for each tile
  late List<List<DateTime?>> _lastTapTimes;

  GameState() {
    _initializeGame();
  }

  /// Reset hint limit based on current difficulty
  void _resetHintLimit() {
    if (_currentMode == GameMode.mirror) {
      // Mirror mode always gets 3 hints
      _hintsRemaining = 3;
      return;
    }
    
    // Normal/Reverse mode: difficulty-based
    switch (_currentLevel.difficulty) {
      case Difficulty.veryEasy:
      case Difficulty.easy:
        _hintsRemaining = 999; // Unlimited
        break;
      case Difficulty.medium:
      case Difficulty.hard:
        _hintsRemaining = 3;
        break;
      case Difficulty.veryHard:
        _hintsRemaining = 1;
        break;
    }
  }

  Future<void> _initializeGame() async {
    final currentLevel = await ProgressManager().getCurrentLevel();
    final modeString = await ProgressManager().getCurrentMode();
    
    // Parse saved mode
    _currentMode = GameMode.values.firstWhere(
      (e) => e.name == modeString,
      orElse: () => GameMode.normal,
    );
    
    // Load appropriate level based on mode
    if (_currentMode == GameMode.reverse) {
      _currentLevel = ReverseLevel.fromNumber(currentLevel);
    } else if (_currentMode == GameMode.mirror) {
      _currentLevel = MirrorLevel.fromNumber(currentLevel);
    } else {
      _currentLevel = Level.fromNumber(currentLevel);
    }
    
    _grid = _currentLevel.getInitialState();
    _lastTapTimes = List.generate(
      _currentLevel.gridSize,
      (i) => List.filled(_currentLevel.gridSize, null),
    );
    _resetHintLimit();
    
    // İlk yüklemede de animasyon göster
    _currentAnimation = AnimationType.levelLoad;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: _currentLevel.gridSize * 2 * 50 + 300));
    _currentAnimation = AnimationType.none;
    notifyListeners();
  }

  // Getters
  List<List<bool>> get grid => _grid;
  int get levelNumber => _currentLevel.number;
  int get moveCount => _moveCount;
  (int, int)? get hintTile => _hintTile;
  bool get hasWon => _currentMode == GameMode.reverse
      ? ReverseLevel.checkWin(_grid)  // All ON for reverse
      : LightsOffLogic.isWinState(_grid);  // All OFF for normal
  AnimationType get currentAnimation => _currentAnimation;
  int get gridSize => _currentLevel.gridSize;
  Difficulty get difficulty => _currentLevel.difficulty;
  bool get canUndo => _moveHistory.isNotEmpty;
  GameMode get currentMode => _currentMode;
  bool get isReverseMode => _currentMode == GameMode.reverse;
  List<List<DateTime?>> get lastTapTimes => _lastTapTimes;
  int get hintsRemaining => _hintsRemaining;
  bool get canUseHint => _hintsRemaining > 0;
  bool get isMirrorMode => _currentMode == GameMode.mirror;

  /// Load a specific normal mode level
  Future<void> loadLevel(int levelNum) async {
    _currentMode = GameMode.normal;
    _currentLevel = Level.fromNumber(levelNum);
    _grid = _currentLevel.getInitialState();
    _moveCount = 0;
    _hintTile = null;
    _moveHistory.clear();
    _lastTapTimes = List.generate(
      _currentLevel.gridSize,
      (i) => List.filled(_currentLevel.gridSize, null),
    );
    _resetHintLimit(); // Reset hints for new level
    
    // Level yükleme animasyonu
    _currentAnimation = AnimationType.levelLoad;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: _currentLevel.gridSize * 2 * 50 + 300));
    _currentAnimation = AnimationType.none;
    
    await ProgressManager().setCurrentLevel(levelNum);
    await ProgressManager().setCurrentMode(_currentMode.name); // Save mode
    notifyListeners();
  }

  /// Load reverse mode level
  Future<void> loadReverseLevel(int levelNum) async {
    _currentMode = GameMode.reverse;
    _currentLevel = ReverseLevel.fromNumber(levelNum);
    _grid = _currentLevel.getInitialState();
    _moveCount = 0;
    _hintTile = null;
    _moveHistory.clear();
    _lastTapTimes = List.generate(
      _currentLevel.gridSize,
      (i) => List.filled(_currentLevel.gridSize, null),
    );
    _resetHintLimit(); // Reset hints for new level
    
    // Level yükleme animasyonu
    _currentAnimation = AnimationType.levelLoad;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: _currentLevel.gridSize * 2 * 50 + 300));
    _currentAnimation = AnimationType.none;
    await ProgressManager().setCurrentMode(_currentMode.name); // Save mode
    notifyListeners();
  }

  /// Load mirror mode level
  Future<void> loadMirrorLevel(int levelNum) async {
    _currentMode = GameMode.mirror;
    _currentLevel = MirrorLevel.fromNumber(levelNum);
    _grid = _currentLevel.getInitialState();
    _moveCount = 0;
    _hintTile = null;
    _moveHistory.clear();
    _lastTapTimes = List.generate(
      _currentLevel.gridSize,
      (i) => List.filled(_currentLevel.gridSize, null),
    );
    _resetHintLimit();
    
    // Level yükleme animasyonu
    _currentAnimation = AnimationType.levelLoad;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: _currentLevel.gridSize * 2 * 50 + 300));
    _currentAnimation = AnimationType.none;
    await ProgressManager().setCurrentMode(_currentMode.name); // Save mode
    notifyListeners();
  }

  /// Toggle tile
  Future<void> toggleTile(int row, int col) async {
    if (_currentAnimation != AnimationType.none) return;
    
    final gridCopy = _grid.map((r) => List<bool>.from(r)).toList();
    _moveHistory.add(_Move(row, col, gridCopy));

    _hintTile = null;
    
    if (_currentMode == GameMode.mirror) {
      // Mirror mode: Toggle both positions but avoid double-toggling
      // Calculate which tiles need to be toggled
      final tilesToToggle = <(int, int)>{};
      
      // Add tiles from primary toggle
      tilesToToggle.add((row, col));
      if (row > 0) tilesToToggle.add((row - 1, col));
      if (row < gridSize - 1) tilesToToggle.add((row + 1, col));
      if (col > 0) tilesToToggle.add((row, col - 1));
      if (col < gridSize - 1) tilesToToggle.add((row, col + 1));
      
      // Add tiles from mirror toggle
      final mirrorRow = 3 - row;
      if (mirrorRow != row && mirrorRow >= 0 && mirrorRow < gridSize) {
        tilesToToggle.add((mirrorRow, col));
        if (mirrorRow > 0) tilesToToggle.add((mirrorRow - 1, col));
        if (mirrorRow < gridSize - 1) tilesToToggle.add((mirrorRow + 1, col));
        if (col > 0) tilesToToggle.add((mirrorRow, col - 1));
        if (col < gridSize - 1) tilesToToggle.add((mirrorRow, col + 1));
      }
      
      // Toggle all unique tiles once
      for (final tile in tilesToToggle) {
        _grid[tile.$1][tile.$2] = !_grid[tile.$1][tile.$2];
      }
    } else {
      // Normal or reverse mode
      _grid = LightsOffLogic.toggleTile(_grid, row, col);
    }
    
    _moveCount++;

    SoundManager().playTapSound();
    HapticFeedback.lightImpact();

    notifyListeners();

    // Kazanma kontrolü
    if (hasWon) {
      await SoundManager().playWinSound();
      
      // Particle efekt game_screen'de gösterilecek
      // Kısa bekleme sonra yeni level'e geç
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Unlock next level based on mode
      if (_currentMode == GameMode.reverse) {
        await ProgressManager().unlockReverseLevel(_currentLevel.number + 1);
        _currentLevel = ReverseLevel.fromNumber(_currentLevel.number + 1);
      } else if (_currentMode == GameMode.mirror) {
        await ProgressManager().unlockMirrorLevel(_currentLevel.number + 1);
        _currentLevel = MirrorLevel.fromNumber(_currentLevel.number + 1);
      } else {
        await ProgressManager().unlockLevel(_currentLevel.number + 1);
        _currentLevel = Level.fromNumber(_currentLevel.number + 1);
      }
      
      // Yeni level'i SESSİZCE yükle
      _grid = _currentLevel.getInitialState();
      _moveCount = 0;
      _hintTile = null;
      _moveHistory.clear();
      await ProgressManager().setCurrentLevel(_currentLevel.number);
      
      // Level load animasyonu başlat
      _currentAnimation = AnimationType.levelLoad;
      notifyListeners();
      
      // Level load animasyonu bitir
      await Future.delayed(Duration(milliseconds: _currentLevel.gridSize * 2 * 50 + 200));
      
      _currentAnimation = AnimationType.none;
      notifyListeners();
    }
  }

  void undo() {
    if (_moveHistory.isEmpty || _currentAnimation != AnimationType.none) return;

    final lastMove = _moveHistory.removeLast();
    _grid = lastMove.gridBefore;
    _moveCount = _moveCount > 0 ? _moveCount - 1 : 0;
    _hintTile = null;

    HapticFeedback.lightImpact();
    notifyListeners();
  }

  Future<void> resetLevel() async {
    if (_currentAnimation != AnimationType.none) return;
    
    // Restart animasyonu
    _currentAnimation = AnimationType.restart;
    notifyListeners();
    
    await Future.delayed(Duration(milliseconds: _currentLevel.gridSize * 2 * 50 + 300));
    
    _grid = _currentLevel.getInitialState();
    _moveCount = 0;
    _hintTile = null;
    _moveHistory.clear();
    _resetHintLimit(); // Restore hints on restart
    
    _currentAnimation = AnimationType.none;
    notifyListeners();
  }

  void getHint() {
    if (_currentAnimation != AnimationType.none) return;
    if (_hintsRemaining <= 0) return; // No hints left
    
    _hintTile = null;

    if (_currentMode == GameMode.mirror) {
      // Mirror mode: Special hint logic
      // Find a tile that will help turn OFF lights
      // Strategy: Find an ON tile and suggest toggling it
      for (int row = 0; row < gridSize; row++) {
        for (int col = 0; col < gridSize; col++) {
          if (_grid[row][col]) {
            // Found an ON tile, suggest it
            _hintTile = (row, col);
            
            // Only decrement if not unlimited
            if (_hintsRemaining < 999) {
              _hintsRemaining--;
            }
            
            HapticFeedback.selectionClick();
            notifyListeners();
            return;
          }
        }
      }
      
      // If no ON tiles found, just return
      notifyListeners();
      return;
    }

    // For reverse and normal mode, use solver
    final solver = LightsOffSolver(_currentLevel.gridSize);
    List<(int, int)>? solution;
    
    if (_currentMode == GameMode.reverse) {
      // Reverse mode: find solution to turn all ON
      final invertedGrid = _grid.map((row) => 
        row.map((tile) => !tile).toList()
      ).toList();
      solution = solver.solve(invertedGrid);
    } else {
      // Normal mode: find solution to turn all OFF
      solution = solver.solve(_grid);
    }

    if (solution == null || solution.isEmpty) {
      notifyListeners();
      return;
    }

    _hintTile = solution.first;
    
    // Only decrement if not unlimited
    if (_hintsRemaining < 999) {
      _hintsRemaining--;
    }
    
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void clearHint() {
    _hintTile = null;
    notifyListeners();
  }
}
