/// Core Lights Off game logic
/// Handles toggle mechanics where tapping a tile toggles itself and its 4 neighbors
class LightsOffLogic {
  /// Toggle a tile and its neighbors (up, down, left, right)
  /// Returns new grid state
  static List<List<bool>> toggleTile(
    List<List<bool>> grid,
    int row,
    int col,
  ) {
    final size = grid.length;
    final newGrid = grid.map((r) => List<bool>.from(r)).toList();

    // Toggle the tapped tile
    newGrid[row][col] = !newGrid[row][col];

    // Toggle top neighbor
    if (row > 0) {
      newGrid[row - 1][col] = !newGrid[row - 1][col];
    }

    // Toggle bottom neighbor
    if (row < size - 1) {
      newGrid[row + 1][col] = !newGrid[row + 1][col];
    }

    // Toggle left neighbor
    if (col > 0) {
      newGrid[row][col - 1] = !newGrid[row][col - 1];
    }

    // Toggle right neighbor
    if (col < size - 1) {
      newGrid[row][col + 1] = !newGrid[row][col + 1];
    }

    return newGrid;
  }

  /// Check if all tiles are OFF (win condition)
  static bool isWinState(List<List<bool>> grid) {
    for (final row in grid) {
      for (final tile in row) {
        if (tile) return false;
      }
    }
    return true;
  }

  /// Create an empty grid of given size
  static List<List<bool>> createEmptyGrid(int size) {
    return List.generate(size, (_) => List.generate(size, (_) => false));
  }
}
