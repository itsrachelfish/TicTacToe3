part of TicTacToe3;

/// Global [Random] instance
Random rand = new Random();

/// Returns a String representing a player.
/// [state]: which player to convert
/// [sanitary]: whether to convert Δ to D (for HTML attribute values)
String getStateString(Player state, [bool sanitary = false]) {
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

/// Return a [Difficulty] converted from the given [difficulty] string.
/// [difficulty] can contain "Difficulty.", but it does not have to
Difficulty parseDifficulty(String difficulty) {
	if (!difficulty.contains(".")) {
		difficulty = "Difficulty." + difficulty;
	}

	for (Difficulty value in Difficulty.values) {
		if (value.toString() == difficulty) {
			return value;
		}
	}

	return Difficulty.NULL;
}

/// Return a [Player] converted from the given [player] string.
/// [player] can contain "Player.", but it does not have to
Player parsePlayer(String player) {
	if (!player.contains(".")) {
		player = "Player." + player;
	}

	for (Player value in Player.values) {
		if (value.toString() == player) {
			return value;
		}
	}

	return Player.NULL;
}