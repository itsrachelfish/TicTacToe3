part of TicTacToe3;

enum WinDirection {
  HORIZONTAL, VERTICAL, DIAGONAL, NONE
}

class Cell {
  /**
   * Number of the cell on the grid
   * (see index.html comment above <table...>)
   */
  int _index;

  int get index => _index;

  /// Reference to the cell's <td> element
  Element _td;

  /// Stores which move is in the cell (X, O, D, or NULL)
  Player _state;

  Player get state => _state;

  /// Updates the player in the cell (including the table's display)
  set state(Player value) {
    // When assigning a value,
    // make sure the cell is not already used,
    // unless the value is being cleared
    if (value == Player.NULL || _state == Player.NULL) {
      // Update the state in memory
      _state = value;
      // Update the table display
      _td.dataset["player"] = Game.getStateString(_state, true);
    } else {
      // Do not allow re-setting of cells (only clearing)
      throw new StateError("Cell has already been filled");
    }
  }

  Cell(this._index, [this._state = Player.NULL]) {
    // Get the element on the page
    _td = UI.grid.querySelectorAll("td").where((TableCellElement tce) => int.parse(tce.dataset["index"]) == _index).first
      ..dataset["player"] = "null";

    // Store a reference
    UI.cells[_index] = this;

    // Set up click listeners
    _td.onClick.listen((_) {
      // Update the state
      state = Game.turn;
      // Check for winning moves
      Map winStatus = checkWins();
      // Check if the game has been won (and how)
      if (
      winStatus["DIRECTION"] != WinDirection.NONE &&
      winStatus["PLAYER"] != Player.NULL
      ) {
        // Notify the game to end
        transmit("GAME_WON", winStatus);
      }
      // Notify the game to move on to the next player
      transmit("CELL_CLICKED", _index);
    });
  }

  /// Check if a given list of cells counts as a win
  Map<String, dynamic> checkWins() {
    // Default result if no wins are present
    Map result = {
      "DIRECTION": WinDirection.NONE,
      "PLAYER": _state
    };

    // Check a list of indices for wins
    bool checkList(List<int> indexes) {
      // Diagonals sometimes return empty lists,
      // which means the cell is not in a diagonal.
      if (indexes.length == 0) {
        return false;
      }

      // Get states of row
      List<Player> states = [];
      indexes.forEach((int i) {
        states.add(UI.cells[i]._state);
      });

      if (states.length == 3) {
        // Make sure every cell in lines of 3 cells has the same player in it
        return states.every((Player s) => _state == s);
      } else {
        /*
         * "Divide & Conquer" to check lines with 4 cells
         * Given an example list of [X, X, X, O], it will be split into
         * two lists, the first being [X, X, X] and the second [X, X, 0]
         * (first and last three items), then each list will be checked for
         * every item being the same. If either list is the same item repeated
         * 3 times, the game has been won.
         */
        return (
            states.sublist(0, 3).every((Player s) => _state == s) ||
            states.sublist(1, 4).every((Player s) => _state == s)
        );
      }
    }

    /// @return a list of cells in the same row as this one
    List<int> getRow() {
      // List of rows and the cells in each
      final Map<int, List<int>> rows = {
        0: [0, 1, 2, 3],
        1: [4, 5, 6, 7],
        2: [8, 9, 10, 11],
        3: [12, 13, 14, 15]
      };

      for (int id in rows.keys) {
        List<int> cells = rows[id];

        if (cells.contains(_index)) {
          return rows[id];
        }
      }

      return [];
    }

    /// @return a list of cells in the same column as this one
    List<int> getCol() {
      // List of columns and the cells in each
      final Map<int, List<int>> cols = {
        0: [0, 4, 8, 12],
        1: [1, 5, 9, 13],
        2: [2, 6, 10, 14],
        3: [3, 7, 11, 15]
      };

      for (int id in cols.keys) {
        List<int> cells = cols[id];

        if (cells.contains(_index)) {
          return cols[id];
        }
      }

      return [];
    }

    /// @return a list of cells in the same diagonal line as this one
    List<int> getDiag() {
      // List of diagonal lines and the cells in each
      final Map<int, List<int>> diags = {
        0: [0, 5, 10, 15],
        1: [3, 6, 9, 12],
        2: [1, 6, 11],
        3: [4, 9, 14],
        4: [2, 5, 8],
        5: [7, 10, 13]
      };

      for (int id in diags.keys) {
        List<int> cells = diags[id];

        if (cells.contains(_index)) {
          return diags[id];
        }
      }

      // Not in a diagonal
      return [];
    }

    // Check row
    if (checkList(getRow())) {
      result["DIRECTION"] = WinDirection.HORIZONTAL;
    }
    // Check column
    if (checkList(getCol())) {
      result["DIRECTION"] = WinDirection.VERTICAL;
    }
    // Check diagonal
    if (checkList(getDiag())) {
      result["DIRECTION"] = WinDirection.DIAGONAL;
    }

    return result;
  }

  /// Turn WinDirection.HORIZONTAL into "horizontal"
  static String getWinDirString(WinDirection direction) => direction.toString().split(".")[1].toLowerCase();

  @override
  String toString() {
    return "<Cell at $_index with value $_state>";
  }
}