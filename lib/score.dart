part of TicTacToe3;

class Score {
	Score(Player player) : _player = player;

	Player _player = Player.NULL;

	String get _id => "tt3_score_" + getStateString(_player, true);

	int get points {
		if (window.localStorage[_id] != null) {
			return int.parse(window.localStorage[_id]);
		} else {
			return 0;
		}
	}

	set _points(int number) => window.localStorage[_id] = number.toString();

	void increment([int amt = 1]) {
		_points = points + amt;
	}

	void reset() {
		_points = 0;
	}

	static final Map<Player, Score> scores = {
		Player.X: new Score(Player.X),
		Player.O: new Score(Player.O),
		Player.D: new Score(Player.D)
	};

	static void resetAll() {
		scores.values.forEach((Score s) {
			s.reset();
		});

		if (UI.scoresDialog.open) {
			UI.scoresDialog.open = false;
			UI.displayScores();
		}
	}
}