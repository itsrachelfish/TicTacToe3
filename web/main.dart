library TicTacToe3;

import "dart:async";
import "dart:html";
import "dart:math";

import "package:konami_code/konami_code.dart";
import "package:transmit/transmit.dart";
import "package:shake/shake.dart";

part "package:TicTacToe3/cell.dart";
part "package:TicTacToe3/game.dart";
part "package:TicTacToe3/grid.dart";
part "package:TicTacToe3/settings.dart";
part "package:TicTacToe3/ui.dart";

Random rand = new Random();

void main() {
	// Set up the page after it loads
	window.onLoad.first.then((_) {
		// Load settings
		Settings.init();
		// Size table (will be done again when/if the browser window resizes)
		UI.sizeTable();
		// Prompt for starting
		UI.displayMessage(Message.START);
		// Hide the splash screen after 2 more seconds
		new Timer(new Duration(seconds: 2), () {
			querySelector("#splash").hidden = true;
		});
	});

	// Initialize cells
	for (int i = 0; i <= 15; i++) {
		new Cell(i);
	}

	// Set up Konami code
	konamiCode.onPerformed.listen((_) => Settings.updateKonami(true));
	new Shake(() => Settings.updateKonami(true), threshold: 10, timeout: new Duration(seconds: 2));
}