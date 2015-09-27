part of TicTacToe3;

class UI {
  // Collect page elements

  /// Grid <table...>
  static final Element grid = querySelector(".grid")
    ..dataset["turn"] = Game.getStateString(Player.NULL);

  /// Game Over dialog
  static final DialogElement _gameOverDialog = querySelector("#gameover");

  /// Map index to cell
  static Map<int, Cell> cells = {};

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
      grid.querySelectorAll("td").forEach((TableCellElement tce) {
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

  /// Clear all moves and re-enable the grid's mouse interaction
  static void clearGrid() {
    // Clear each cell
    cells.values.forEach((Cell c) {
      c.state = Player.NULL;
    });
    // Enable mouse events
    grid.classes.remove("disabled");
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
    _gameOverDialog.querySelector(".winner").dataset["winner"] = Game.getStateString(win["PLAYER"], true);

    // Fill in the direction
    _gameOverDialog.querySelector(".direction span").text = Cell.getWinDirString(win["DIRECTION"]);

    // Activate the button
    _gameOverDialog.querySelector("button.start").onClick.first.then((_) {
      _gameOverDialog.open = false;
      Game.start();
    });

    // Show the dialog
    _gameOverDialog.open = true;
  }

  /// @return number of cells without moves in them
  static int countEmptyCells() {
    int number = 0;
    cells.values.forEach((Cell c) {
      if (c._state == Player.NULL) {
        number++;
      }
    });
    return number;
  }
}