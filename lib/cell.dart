part of TicTacToe3;

enum WinDirection {
  HORIZONTAL, VERTICAL, DIAGONAL, NONE
}

class Cell {
  int index;

  Element _td;
  Player _state;

  set state(Player value) {
    // When assigning a value,
    // make sure the cell is not already used,
    // unless the value is being cleared
    if (value == Player.NULL || _state == Player.NULL) {
      _state = value;
      _td.dataset["player"] = Game.getStateString(_state, true);
    } else {
      throw new StateError("Cell has already been filled");
    }
  }

  Cell(this.index, [this._state = Player.NULL]) {
    // Get the element on the page
    _td = UI.grid.querySelectorAll("td").where((TableCellElement tce) => int.parse(tce.dataset["index"]) == index).first
      ..dataset["player"] = "null";

    // Store a reference
    UI.cells[index] = this;

    // Set up click listeners
    _td.onClick.listen((_) {
      state = Game.turn;
      Map winStatus = checkWins();
      if (winStatus["DIRECTION"] != WinDirection.NONE) {
        transmit("GAME_WON", winStatus);
      }
      transmit("CELL_CLICKED", index);
    });
  }

  Map<String, dynamic> checkWins() {
    Map result = {
      "DIRECTION": WinDirection.NONE,
      "PLAYER": Player.NULL
    };

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

      // Make sure they are all the same
      return states.every((Player s) => _state == s);
    }

    // Check row
    if (checkList(getRow())) {
      result["DIRECTION"] = WinDirection.HORIZONTAL;
      result["PLAYER"] = UI.cells[getRow()[0]]._state;
    }
    // Check column
    if (checkList(getCol())) {
      result["DIRECTION"] = WinDirection.VERTICAL;
      result["PLAYER"] = UI.cells[getCol()[0]]._state;
    }
    // Check diagonal
    if (checkList(getDiag())) {
      result["DIRECTION"] = WinDirection.DIAGONAL;
      result["PLAYER"] = UI.cells[getDiag()[0]]._state;
    }

    return result;
  }

  List<int> getRow() {
    Map<int, List<int>> rows = {
      0: [0, 1, 2, 3],
      1: [4, 5, 6, 7],
      2: [8, 9, 10, 11],
      3: [12, 13, 14, 15]
    };

    for (int id in rows.keys) {
      List<int> cells = rows[id];

      if (cells.contains(index)) {
        return rows[id];
      }
    }

    return false;
  }

  List<int> getCol() {
    Map<int, List<int>> cols = {
      0: [0, 4, 8, 12],
      1: [1, 5, 9, 13],
      2: [2, 6, 10, 14],
      3: [3, 7, 11, 15]
    };

    for (int id in cols.keys) {
      List<int> cells = cols[id];

      if (cells.contains(index)) {
        return cols[id];
      }
    }
  }

  List<int> getDiag() {
    Map<int, List<int>> diags = {
      0: [0, 5, 10, 15],
      1: [3, 6, 9, 12]
    };

    for (int id in diags.keys) {
      List<int> cells = diags[id];

      if (cells.contains(index)) {
        return diags[id];
      }
    }

    // Not in a diagonal
    return [];
  }

  // Turn WinDirection.HORIZONTAL into "horizontal"
  static String getWinDirString(WinDirection direction) => direction.toString().split(".")[1].toLowerCase();

  @override
  String toString() {
    return "<Cell at $index with value $_state>";
  }
}