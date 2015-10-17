/// The app
library TicTacToe3;

import "dart:async";
import "dart:html";
import "dart:math";

import "package:konami_code/konami_code.dart";
import "package:transmit/transmit.dart";

part "package:TicTacToe3/cell.dart";
part "package:TicTacToe3/game.dart";
part "package:TicTacToe3/globals.dart";
part "package:TicTacToe3/grid.dart";
part "package:TicTacToe3/opponent.dart";
part "package:TicTacToe3/settings.dart";
part "package:TicTacToe3/ui.dart";

void main() {
	// Set up the page after it loads
	window.onLoad.first.then((_) {
		// Load settings
		Settings.init();
		// Size table (will be done again when/if the browser window resizes)
		UI.sizeTable();
		// Prompt for starting
		UI.displayMessage(Message.START);
		document.body.hidden = false;
		// Hide the splash screen after 1 more second (to finish initial animations)
		new Timer(new Duration(seconds: 1), () {
			querySelector("#splash").classes.add("away");
		});
	});

	// Initialize cells
	for (int i = 0; i <= 15; i++) {
		new Cell(i);
	}

	// Set up Konami code
	konamiCode.onPerformed.listen((_) => Settings.updateKonami(true));
	window.addEventListener("shake", (_) => Settings.updateKonami(true));
}
