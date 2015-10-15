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
			UI.displayMessage(Message.TIE);
		}
	}

	static void _getNextTurn() {
		turn = _order[_moves % 3];
		print(computerOpponent);
		if (!computerOpponent.isNull && computerOpponent.player == Game.turn) {
			// Computer opponent's turn
			UI.displayMessage(Message.TURN, "${getStateString(turn)} (computer)");
			Grid.turn = turn;
			Grid.locked = true;
			new Timer(new Duration(milliseconds: 500), () {
				// Wait half a second, then move
				computerOpponent.move();
				Grid.locked = false;
			});
		} else {
			// No computer opponent, or normal turn
			UI.displayMessage(Message.TURN, getStateString(turn));
			Grid.turn = turn;
		}
	}

	/// Computer opponent
	static Opponent computerOpponent = new Opponent();
}