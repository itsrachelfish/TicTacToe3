part of TicTacToe3;

enum Difficulty {
	EASY, HARD, NULL
}

class Opponent {
	Player _player;
	Player get player => _player;

	Difficulty _difficulty;
	Difficulty get difficulty => _difficulty;

	Opponent([Player player = Player.NULL, Difficulty difficulty = Difficulty.NULL])
	: _player = player, _difficulty = difficulty;

	void move() {
		int index;
		if (_difficulty == Difficulty.HARD) {
			index = nextMove_hard();
		} else {
			index = nextMove_easy();
		}
		Grid.cells[index].update();
	}

	int nextMove_easy() {
		// List of empty indices
		List<int> emptyCells = Grid.emptyCellsList;
		// Random empty cell
		int index = rand.nextInt(emptyCells.length);
		// Index of the chosen cell
		return emptyCells[index];
	}

	int nextMove_hard() {
		// Where to place the move
		int index;
		// List of empty indices
		List<int> emptyCells = Grid.emptyCellsList;

		// Check a list of cells for any blanks, and will return the index of a blank
		// iff there is ONE blank (no more, no less)
		int checkForSpot(List<int> indices) {
			// Count blanks
			int blanks = indices.where((int index) => Grid.cells[index].state == Player.NULL).toList().length;
			if (blanks == 1) {
				// One blank
				return indices.where((int index) => Grid.cells[index].state == Player.NULL).toList().first;
			} else {
				// More or less than one blank
				return -1;
			}
		}

		// Check a set of lists of cells for blanks
		Map<int, int> checkMultilevelSpot(Map<int, List<int>> indices) {
			// Return value
			Map<int, int> result = {};
			// Go through each list of cells
			indices.forEach((int id, List<int> cellIndices) {
				// Store the list id and the blank spot value in the return value
				result.addAll(({
					id: checkForSpot(cellIndices)
				}));
			});
			// Return the return value
			return result;
		}

		// Go through the results of the checks and look for possible moves
		int getMove(Map<int, int> data) {
			for (int id in data.keys) {
				int value = data[id];
				if (value != -1) {
					return value;
				}
			}
			return -1;
		}

		Map<int, int> rows = checkMultilevelSpot(Grid.rows);
		Map<int, int> cols = checkMultilevelSpot(Grid.cols);
		Map<int, int> diags = checkMultilevelSpot(Grid.diags);

		int rowMove = getMove(rows);
		int colMove = getMove(cols);
		int diagMove = getMove(diags);

		if (rowMove != -1) {
			return rowMove;
		} else if (colMove != -1) {
			return colMove;
		} else if (diagMove != -1) {
			return diagMove;
		} else {
			return nextMove_easy();
		}
	}

	bool get isNull => (_player == Player.NULL || _difficulty == Difficulty.NULL);

	@override
	String toString() => "Opponent with ${_difficulty.toString()} for ${_player.toString()}";
}