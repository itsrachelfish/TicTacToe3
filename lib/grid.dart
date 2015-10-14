part of TicTacToe3;

class Grid {
	/// Maps row number to cell indices in row
	static Map<int, List<int>> get rows => {
		0: [0, 1, 2, 3],
		1: [4, 5, 6, 7],
		2: [8, 9, 10, 11],
		3: [12, 13, 14, 15]
	};

	/// Maps column number to cell indices in column
	static Map<int, List<int>> get cols => {
		0: [0, 4, 8, 12],
		1: [1, 5, 9, 13],
		2: [2, 6, 10, 14],
		3: [3, 7, 11, 15]
	};

	/// Maps diagonal number to cell indices in diagonal
	static Map<int, List<int>> get diags => {
		0: [0, 5, 10, 15],
		1: [3, 6, 9, 12],
		2: [1, 6, 11],
		3: [4, 9, 14],
		4: [2, 5, 8],
		5: [7, 10, 13]
	};

	/// @return number of cells without moves in them
	static int get emptyCells {
		return emptyCellsList.length;
	}

	static List<int> get emptyCellsList {
		List<int> empty = [];
		cells.values.forEach((Cell c) {
			if (c._state == Player.NULL) {
				empty.add(c._index);
			}
		});
		return empty;
	}

	/// Reference to cells
	static Map<int, Cell> cells = {};

	/// <table> element
	static final Element element = querySelector(".grid");

	/// Whether to disable interaction with the grid
	/// Disabling also adds a blur
	static set disabled(bool disable) {
		if (disable) {
			if (!element.attributes.containsKey("disabled")) {
				element.attributes.addAll(({"disabled": ""}));
			}
		} else {
			element.attributes.remove("disabled");
		}
	}

	/// Updates the cursor on empty cells to the given player
	static set turn(Player player) => element.dataset["turn"] = Game.getStateString(Game.turn, true);

	/// @return: list of all cell elements (<td>s)
	static List<TableCellElement> get cellElements => element.querySelectorAll("td").toList();

	/// Clear all moves and re-enable the grid's mouse interaction
	static void clear() {
		// Clear each cell
		cells.values.forEach((Cell c) => c.state = Player.NULL);
		// Clear selections
		UI.selectCells([]);
		// Enable mouse events
		disabled = false;
	}
}