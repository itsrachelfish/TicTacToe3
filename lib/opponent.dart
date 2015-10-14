part of TicTacToe3;

enum Difficulty {
	EASY, HARD, NULL
}

class Opponent {
	Player _player = Player.NULL;
	Player get player => _player;
	Difficulty _difficulty = Difficulty.NULL;
	Difficulty get difficulty => _difficulty;

	Opponent(Player player, Difficulty difficulty) : _player = player, _difficulty = difficulty;

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
		List<int> emptyCells = Grid.emptyCellsList;
		int index = rand.nextInt(emptyCells.length);
		return emptyCells[index];
	}

	int nextMove_hard() {
		// TODO: algorithm to find the best move
		return nextMove_easy();
	}

	bool get isNull => (_player == Player.NULL || _difficulty == Difficulty.NULL);

	@override
	String toString() => "Opponent with ${_difficulty.toString()} for ${_player.toString()}";
}