part of TicTacToe3;

enum Difficulty {
	_EASY, HARD, NULL
}

class Opponent {
	Player _player;
	Player get player => _player;

	Difficulty _difficulty;
	Difficulty get difficulty => _difficulty;

	Opponent([Player player = Player.NULL, Difficulty difficulty = Difficulty.NULL])
	: _player = player, _difficulty = difficulty;

	void move() {
		Grid.cells[nextMove].update();
	}

	int get nextMove {
		if (difficulty == Difficulty.HARD) {
			return nextMove_hard();
		} else {
			return nextMove_easy();
		}
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
		/**
		 * Algorithm Outline (RCD = row, column, and diagonal)
		 *   Check 1: Check each RCD for 2 of the computer player in a row
		 *   Check 2: Check each RCD for 2 of the computer player
		 *   Check 3: Check each RCD for one open spot
		 *   Check 4: Place an easy mode move
		 *
		 *   Each check should return an int of the cell index to place if found,
		 *   or -1 if not found (will skip to the next)
		 */

		int check1() {
			// TODO: Check each RCD for 2 of the computer player in a row
			return -1;
		}

		int check2() {
			// TODO: Check each RCD for 2 of the computer player
			return -1;
		}

		int check3() {
			// Where to place the move
			int index;
			// List of empty indices
			List<int> emptyCells = Grid.emptyCellsList;
			// Check for 2 of the computer player in a row
			String compareString = "${_player.toString()}, ${_player.toString()}";

			// Check a list of cells for any blanks, and will return the index of a blank
			// iff there is ONE blank (no more, no less)... HOLY SUBROUTINES, WE'RE AT 3 LEVELS!
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
				return -1;
			}
		}

		int check4() {
			return nextMove_easy();
		}

		// Check #1
		int c1 = check1();
		if (c1 != -1) {
			print("Check 1: ${c1.toString()}");
			return c1;
		}

		// Check #2
		int c2 = check2();
		if (c2 != -1) {
			print("Check 2: ${c2.toString()}");
			return c2;
		}

		// Check #3
		int c3 = check3();
		if (c3 != -1) {
			print("Check 3: ${c3.toString()}");
			return c3;
		}

		// Check #4
		print("Check 4: Difficulty.EASY");
		return check4();
	}

	bool get isNull => (_player == Player.NULL || _difficulty == Difficulty.NULL);

	@override
	String toString() => "Opponent with ${_difficulty.toString()} for ${_player.toString()}";
}