part of TicTacToe3;

/// @return a String representing a player
/// @param state: which player to convert
/// @param sanitary: whether to convert Δ to D (for HTML attribute values)
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