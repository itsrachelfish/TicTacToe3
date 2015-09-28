part of TicTacToe3;

class UI {
	// Collect page elements

	/// Game Over dialog
	static final DialogElement gameOverDialog = querySelector("#gameover");

	/// Navbar
	static final Element navbar = querySelector("nav");

	/// Whether the Konami code is on
	static bool get konami {
		return window.localStorage["ttt3_konami"] != null &&
		       window.localStorage["ttt3_konami"] == "true";
	}

	static set konami(bool value) {
		window.localStorage["ttt3_konami"] = value.toString();
		updateKonami();
	}

	static void updateKonami() {
		if (konami) {
			document.body.classes.add("konami");
		} else {
			document.body.classes.remove("konami");
		}
	}

	/// Header messages
	static final Map<String, Element> _messages = {
		"start": querySelector("#msg-start"),
		"turn": querySelector("#msg-turn"),
		"tie": querySelector("#msg-tie"),
		"win": querySelector("#msg-win")
	};

	/// Resize the table evenly to fit the browser window
	static void sizeTable() {
		void doSizing() {
			// Get the size of the window, leaving space for the navbar
			int toWidth = (window.innerWidth).floor();
			int toHeight = (window.innerHeight - 120).floor();

			// Get the width of each cell by diving the size by 4 (4 cells h/v)
			int cellWidth = toWidth ~/ 4;
			int cellHeight = toHeight ~/ 4;

			// Find the smallest of the width/height to fit the table in
			int cellSize = min(cellWidth, cellHeight);

			// Apply this width/height to every cell
			Grid.cellElements.forEach((TableCellElement tce) {
				tce.style
					..width = "${cellSize.toString()}px"
					..height = "${cellSize.toString()}px";
			});
		}

		// Do it now
		doSizing();
		// Do it again when/if the window resizes
		window.onResize.listen((_) => doSizing());
	}

	/// Update the header messages
	/// @param msg: ID of the message to display (see _messages)
	/// @param fill1: Text to place into the element with class fill1 (if present: required)
	static void displayMessage(String msg, [String fill1]) {
		_messages.forEach((String name, Element element) {
			if (name != msg) {
				// If this is not the desired message, hide it
				element.hidden = true;
			} else {
				// If it is, show it
				element.hidden = false;

				// Fill in fields
				if (fill1 != null && element.querySelector(".fill1") != null) {
					element.querySelector(".fill1").text = fill1;
				} else if (fill1 == null && element.querySelector(".fill1") != null) {
					throw new StateError("Data must be provided for message: $msg");
				}

				// Activate buttons
				if (element.querySelector("button.start") != null) {
					element.querySelector("button.start").onClick.first.then((_) => Game.start());
				}
			}
		});
	}

	/// Fill & open the Game Over modal
	static void displayGameOver(Map win) {
		// Update the footer
		displayMessage("win", Game.getStateString(win["PLAYER"]));

		// Fill in the icon
		gameOverDialog.querySelector(".winner").dataset["winner"] = Game.getStateString(win["PLAYER"], true);

		// Fill in the direction
		gameOverDialog.querySelector(".direction span").text = Cell.getWinDirString(win["DIRECTION"]);

		// Activate the button
		gameOverDialog.querySelector("button.start").onClick.first.then((_) {
			gameOverDialog.open = false;
			Game.start();
		});

		// Show the dialog
		gameOverDialog.open = true;
	}

	/// Mark the listed cells
	static void selectCells(List<int> indices, {Player player}) {
		Grid.cells.values.forEach((Cell c) {
			if (indices.length > 0 && player != null) {
				if (indices.contains(c.index)) {
					// Select given cells
					c.td.classes.add("selected-${Game.getStateString(player, true)}");
				} else {
					// Unselect cells that aren't listed
					c.td.classes.removeAll(["selected-X", "selected-O", "selected-D"]);
				}
			} else {
				// Unselect all cells
				c.td.classes.removeAll(["selected-X", "selected-O", "selected-D"]);
			}
		});
	}
}