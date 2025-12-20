/// Lights Off puzzle solver using Gaussian elimination over GF(2)
/// 
/// Theory:
/// The Lights Off puzzle can be modeled as a system of linear equations over GF(2)
/// (the binary field, where 1+1=0). Each tile's final state is the XOR of:
/// - its initial state
/// - all button presses affecting it
/// 
/// We want all tiles to be OFF (0), so we solve: A*x = b (mod 2)
/// where:
/// - A is the coefficient matrix (which buttons affect which tiles)
/// - x is the solution vector (which buttons to press)
/// - b is the initial state vector
class LightsOffSolver {
  final int gridSize;

  LightsOffSolver(this.gridSize);

  /// Solve the puzzle and return the sequence of tiles to press
  /// Returns list of (row, col) coordinates
  List<(int, int)>? solve(List<List<bool>> initialState) {
    final n = gridSize * gridSize;

    // Build coefficient matrix A (n x n)
    // A[i][j] = 1 if pressing button j affects tile i
    final matrix = List.generate(n, (_) => List.generate(n, (_) => 0));

    for (int btnRow = 0; btnRow < gridSize; btnRow++) {
      for (int btnCol = 0; btnCol < gridSize; btnCol++) {
        final btnIdx = btnRow * gridSize + btnCol;

        // Pressing this button affects:
        // 1. Itself
        matrix[btnIdx][btnIdx] = 1;

        // 2. Top neighbor
        if (btnRow > 0) {
          final topIdx = (btnRow - 1) * gridSize + btnCol;
          matrix[topIdx][btnIdx] = 1;
        }

        // 3. Bottom neighbor
        if (btnRow < gridSize - 1) {
          final bottomIdx = (btnRow + 1) * gridSize + btnCol;
          matrix[bottomIdx][btnIdx] = 1;
        }

        // 4. Left neighbor
        if (btnCol > 0) {
          final leftIdx = btnRow * gridSize + (btnCol - 1);
          matrix[leftIdx][btnIdx] = 1;
        }

        // 5. Right neighbor
        if (btnCol < gridSize - 1) {
          final rightIdx = btnRow * gridSize + (btnCol + 1);
          matrix[rightIdx][btnIdx] = 1;
        }
      }
    }

    // Build initial state vector b
    final b = <int>[];
    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        b.add(initialState[row][col] ? 1 : 0);
      }
    }

    // Solve A*x = b using Gaussian elimination over GF(2)
    final solution = _gaussianEliminationGF2(matrix, b);
    if (solution == null) return null;

    // Convert solution vector to tile coordinates
    final moves = <(int, int)>[];
    for (int i = 0; i < n; i++) {
      if (solution[i] == 1) {
        final row = i ~/ gridSize;
        final col = i % gridSize;
        moves.add((row, col));
      }
    }

    return moves;
  }

  /// Gaussian elimination over GF(2) to solve A*x = b
  /// Returns solution vector x, or null if no solution exists
  List<int>? _gaussianEliminationGF2(List<List<int>> a, List<int> b) {
    final n = a.length;
    
    // Create augmented matrix [A | b]
    final augmented = List.generate(
      n,
      (i) => [...a[i], b[i]],
    );

    // Forward elimination
    int pivotRow = 0;
    for (int col = 0; col < n; col++) {
      // Find pivot
      int? pivot;
      for (int row = pivotRow; row < n; row++) {
        if (augmented[row][col] == 1) {
          pivot = row;
          break;
        }
      }

      if (pivot == null) continue; // No pivot in this column

      // Swap rows
      if (pivot != pivotRow) {
        final temp = augmented[pivotRow];
        augmented[pivotRow] = augmented[pivot];
        augmented[pivot] = temp;
      }

      // Eliminate
      for (int row = 0; row < n; row++) {
        if (row != pivotRow && augmented[row][col] == 1) {
          // XOR row with pivot row
          for (int c = 0; c <= n; c++) {
            augmented[row][c] ^= augmented[pivotRow][c];
          }
        }
      }

      pivotRow++;
    }

    // Back substitution to find solution
    final solution = List.generate(n, (_) => 0);
    for (int row = n - 1; row >= 0; row--) {
      // Find leading 1
      int? leadingCol;
      for (int col = 0; col < n; col++) {
        if (augmented[row][col] == 1) {
          leadingCol = col;
          break;
        }
      }

      if (leadingCol == null) {
        // Row is all zeros
        if (augmented[row][n] == 1) {
          // Inconsistent system
          return null;
        }
        continue;
      }

      // Set solution
      solution[leadingCol] = augmented[row][n];
    }

    return solution;
  }
}
