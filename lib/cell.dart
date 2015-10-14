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

	set index(_) => throw new UnsupportedError("Cannot reassign a cell's index");

	/// Reference to the cell's <td> element
	Element _td;

	Element get td => _td;

	set td(_) => throw new UnsupportedError("Cannot reassign a cell's element");

	/// Stores which move is in the cell (X, O, D, or NULL)
	Player _state;

	Player get state => _state;

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
		_td = Grid.element.querySelectorAll("td").where((TableCellElement tce) => int.parse(tce.dataset["index"]) == _index).first
			..dataset["player"] = "null";

		// Store a reference
		Grid.cells[_index] = this;

		// Set up click listeners
		_td.onClick.listen((_) => update());
	}

	/// Update the state (after a click/mark)
	void update() {
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
	}

	/// Check if a given list of cells counts as a win
	Map<String, dynamic> checkWins() {
		// Default result if no wins are present
		Map result = {
			"DIRECTION": WinDirection.NONE,
			"PLAYER": _state
		};

		// Check a list of indices for wins
		bool checkList(List<int> indices) {
			// Diagonals sometimes return empty lists,
			// which means the cell is not in a diagonal.
			if (indices.length == 0) {
				return false;
			}

			// Get states of row
			List<Player> states = [];
			indices.forEach((int i) {
				states.add(Grid.cells[i]._state);
			});

			if (states.length == 3) {
				// Make sure every cell in lines of 3 cells has the same player in it
				if (states.every((Player s) => _state == s)) {
					UI.selectCells(indices, player: _state);
					return true;
				}
			} else {
			/*
		         * "Divide & Conquer" to check lines with 4 cells
		         * Given an example list of [X, X, X, O], it will be split into
		         * two lists, the first being [X, X, X] and the second [X, X, 0]
		         * (first and last three items), then each list will be checked for
		         * every item being the same. If either list is the same item repeated
		         * 3 times, the game has been won.
		         */
				if (states.sublist(0, 3).every((Player s) => _state == s) ||
				    states.sublist(1, 4).every((Player s) => _state == s)
				) {
					UI.selectCells(indices, player: _state);
					return true;
				}
			}

			// No conditions met, no wins
			return false;
		}

		/// @return a list of cells in the same row as this one
		List<int> getRow() {
			// List of rows and the cells in each
			for (int id in Grid.rows.keys) {
				List<int> cells = Grid.rows[id];

				if (cells.contains(_index)) {
					return Grid.rows[id];
				}
			}

			return [];
		}

		/// @return a list of cells in the same column as this one
		List<int> getCol() {
			// List of columns and the cells in each
			for (int id in Grid.cols.keys) {
				List<int> cells = Grid.cols[id];

				if (cells.contains(_index)) {
					return Grid.cols[id];
				}
			}

			return [];
		}

		/// @return a list of cells in the same diagonal line as this one
		List<int> getDiag() {
			// List of diagonal lines and the cells in each
			for (int id in Grid.diags.keys) {
				List<int> cells = Grid.diags[id];

				if (cells.contains(_index)) {
					return Grid.diags[id];
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
	String toString() => "<Cell at $_index with value $_state>";
}
