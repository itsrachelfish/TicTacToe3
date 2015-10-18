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
		int n = nextMove;
		Grid.cells[n].update();
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
		// Check a set of lists of cells for blanks
		Map<int, int> checkMultilevelSpot(Map<int, List<int>> indices, Function callback) {
			// Return value
			Map<int, int> result = {};
			// Go through each list of cells
			indices.forEach((int id, List<int> cellIndices) {
				// Store the list id and the blank spot value in the return value
				result.addAll(({
					id: Function.apply(callback, [cellIndices])
				}));
			});
			// Return the return value
			return result;
		}

		// Go through the results of the checks and look for possible moves
		int getMove(Map<int, int> data) {
			for (int id in data.keys) {
				int value = data[id];
				if (value != -1 &&
				    Grid.cells[value] != null &&
				    Grid.cells[value].state == Player.NULL
				) {
					return value;
				}
			}
			return -1;
		}

		/// Run the supplied callback algorithm on grid data
		/// Callback must accept a list of indices to process)
		int processData(Function callback) {
			Map<int, int> rows = checkMultilevelSpot(Grid.rows, callback);
			Map<int, int> cols = checkMultilevelSpot(Grid.cols, callback);
			Map<int, int> diags = checkMultilevelSpot(Grid.diags, callback);

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

		/*
		 * Algorithm Outline (RCD = row, column, and diagonal)
		 *   Check 1: Check each RCD for 2 of the computer player in a row
		 *   Check 2: Check each RCD for one open spot
		 *   Check 3: Place an easy mode move
		 *
		 *   Each check should return an int of the cell index to place if found,
		 *   or -1 if not found (will skip to the next)
		 */

		int check_intelligent() {
			// Where to place the move
			int index;
			// List of empty indices
			List<int> emptyCells = Grid.emptyCellsList;

			// Check a list of cells for the compare string, and return the index of a blank
			// iff there is ONE blank (no more, no less)... HOLY SUBROUTINES, WE'RE AT 3 LEVELS!
			int checkForSpot(List<int> indices) {
				// Get moves in cell group
				List<Player> moves = [];
				indices.forEach((int index) {
					moves.add(Grid.cells[index].state);
				});

				// Number of moves the computer has in this list
				int computerMoves = moves.where((Player p) => p == this.player).toList().length;

				if (computerMoves == 3) {
					// 3 of them?

					// Get the index of the empty cell
					int i = 0;
					for (Player p in moves) {
						if (p == Player.NULL) {
							// Found empty cell? Return its index
							window.console.info(i);
							return indices[i];
						}
						// Update the search index
						i++;
					}

					// Default, if, for some strange reason, there was a problem
					return -1;
				} else if (computerMoves == 2) {
					// 2 of them?

					// Locate them!
					bool atFirst = (moves.first == this.player);
					bool atLast = (moves.last == this.player);

					if ((atFirst && atLast) || atFirst) {
						// Computer has a move at the start of the line, OR
						// Computer has moves at both ends of the line,
						// doesn't matter where we place it
						int i = 0;
						for (Player p in moves) {
							if (p == Player.NULL) {
								// Found empty cell? Return its index
								window.console.info(i);
								return indices[i];
							}
							// Update the search index
							i++;
						}

						// Default, if, for some strange reason, there was a problem
						return -1;
					} else if (atLast) {
						// Computer has a move at the end of the line,
						// work backwards to find the LAST empty space
						int i = moves.length - 1;
						for (Player p in moves) {
							if (p == Player.NULL) {
								// Found empty cell? Return its index
								window.console.info(i);
								return indices[i];
							}
							// Update the search index
							i--;
						}

						// Default, if, for some strange reason, there was a problem
						return -1;
					}
				} else {
					// Not enough of them
					return -1;
				}
			}

			return processData(checkForSpot);
		}

		int check_fill() {
			// Where to place the move
			int index;
			// List of empty indices
			List<int> emptyCells = Grid.emptyCellsList;

			// Check a list of cells for any blanks, and return the index of a blank
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

			return processData(checkForSpot);
		}

		// Check #1
		int c1 = check_intelligent();
		if (c1 != -1) {
			return c1;
		}

		// Check #2
		int c2 = check_fill();
		if (c2 != -1) {
			return c2;
		}

		// Check #3
		return nextMove_easy();
	}

	bool get isNull => (_player == Player.NULL || _difficulty == Difficulty.NULL);

	@override
	String toString() => "Opponent with ${_difficulty.toString()} for ${_player.toString()}";
}