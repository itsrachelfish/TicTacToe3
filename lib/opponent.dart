part of TicTacToe3;

enum Difficulty {
	EASY, HARD, NULL
}

class Opponent {
	Player _player = Player.NULL;
	Difficulty _difficulty;

	Opponent(Player player, Difficulty difficulty) : _player = player, _difficulty = difficulty {
		new Service(["TURN"], (Player turn) {
			if (turn == _player) {
				move();
			}
		});
	}

	void move() {
		int index;
		if (_difficulty == Difficulty.HARD) {
			index = nextMove_hard();
		} else {
			index = nextMove_easy();
		}
		Grid.cells[index].mark(_player);
	}

	int nextMove_easy() {
		List<int> emptyCells = Grid.emptyCellsList;
		int index = rand.nextInt(emptyCells.length);
		return emptyCells[index];
	}

	int nextMove_hard() {

	}
}