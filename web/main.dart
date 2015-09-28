library TicTacToe3;

import "dart:html";
import "dart:math";

import "package:konami_code/konami_code.dart";
import "package:transmit/transmit.dart";

part "package:TicTacToe3/cell.dart";
part "package:TicTacToe3/game.dart";
part "package:TicTacToe3/grid.dart";
part "package:TicTacToe3/ui.dart";

Random rand = new Random();

void main() {
	// Set up the page after it loads
	window.onLoad.first.then((_) {
		// Test konami state
		UI.updateKonami();
		// Size table (will be done again when/if the browser window resizes)
		UI.sizeTable();
		// Prompt for starting
		UI.displayMessage("start");
		// Display the board
		Grid.hidden = false;
	});

	// Initialize cells
	for (int i = 0; i <= 15; i++) {
		new Cell(i);
	}

	// Set up Konami code
	konamiCode.onPerformed.listen((_) => UI.konami = !UI.konami);
}