part of TicTacToe3;

enum Player {
	O, X, D, NULL
}

class Game {
	/// Whether the game is running
	static bool playing = false;

	/// Whose turn it is
	static Player turn;

	/// How many moves have been made (used to find the current turn)
	static int _moves = 0;

	/// Order of players' actions
	/// Shuffled when each game starts
	static Map<int, Player> _order = {
		0: Player.O,
		1: Player.X,
		2: Player.D
	};

	/// Listen for events
	static Service clickListener, winListener;

	/// Start the game (will clear any current progress!)
	static void start() {
		void shuffleTurns() {
			List<Player> newOrder = _order.values.toList()
				..shuffle();
			_order
				..[0] = newOrder[0]
				..[1] = newOrder[1]
				..[2] = newOrder[2];
		}

		// Randomize player order
		shuffleTurns();
		// Prevent the same player being listed in every slot
		// (bug due to overloading at load)

		// Clear the board
		Grid.clear();

		// Start the game
		_getNextTurn();
		playing = true;

		winListener = new Service(["GAME_WON"], (Map win) {
			end(winner: win);
		});

		clickListener = new Service(["CELL_CLICKED"], (int index) {
			_moves++;
			if (playing) {
				// Game has not been won
				if (Grid.emptyCells == 0) {
					end(tie: true);
				} else {
					_getNextTurn();
				}
			}
		});
	}

	/// Stop the game (does not clear display, but it cannot be resumed)
	static void end({Map winner, bool tie}) {
		// Reset the game
		playing = false;
		_moves = 0;

		// Stop listening to events
		clickListener.cancel();
		winListener.cancel();

		// Disable the grid
		Grid.disabled = true;

		if (winner != null) {
			// Game Over modal with winner
			UI.displayGameOver(winner);
		} else if (tie != null && tie == true) {
			// Navbar text if a tie has occurred (board filled)
			UI.displayMessage("tie");
		}
	}

	static void _getNextTurn() {
		turn = _order[_moves % 3];
		UI.displayMessage("turn", getStateString(turn));
		Grid.turn = turn;
	}

	/// @return a String representing a player
	/// @param state: which player to convert
	/// @param sanitary: whether to convert Δ to D (for HTML attribute values)
	static String getStateString(Player state, [bool sanitary = false]) {
		switch (state) {
			case Player.O:
				return "O";
			case Player.X:
				return "X";
			case Player.D:
				if (sanitary) {
					return "D";
				}
				return "Δ";
			case Player.NULL:
				return "NULL";
		}
	}
}