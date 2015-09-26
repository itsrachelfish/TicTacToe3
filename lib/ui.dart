part of TicTacToe3;

UI ui = new UI();

class UI {
  // Collect page elements
  static Element _grid = querySelector(".grid")
    ..dataset["turn"] = Game.getStateString(Player.NULL);
  static Element get grid => _grid;

  static DialogElement gameOverDialog = querySelector("#gameover");

  // Store cell references
  static Map<int, Cell> cells = {};

  // Prepare header messages
  static Map<String, Element> messages = {
    "start": querySelector("#msg-start"),
    "turn": querySelector("#msg-turn"),
    "tie": querySelector("#msg-tie"),
    "win": querySelector("#msg-win")
  };

  // Resize the table
  static void sizeTable() {
    void doSizing() {
      int toWidth = (window.innerWidth - 20).floor();
      int toHeight = (window.innerHeight - 120).floor();

      int cellWidth = toWidth ~/ 4;
      int cellHeight = toHeight ~/ 4;

      int cellSize = min(cellWidth, cellHeight);

      _grid.querySelectorAll("td").forEach((TableCellElement tce) {
        tce.style
          ..width = "${cellSize.toString()}px"
          ..height = "${cellSize.toString()}px";
      });
    }

    doSizing();
    window.onResize.listen((_) => doSizing());
  }

  // Empty the table
  static void clearGrid() {
    cells.values.forEach((Cell c) {
      c.state = Player.NULL;
    });
    grid.classes.remove("disabled");
  }

  // Update the header messages
  static void displayMessage(String msg, [String fill1]) {
    messages.forEach((String name, Element element) {
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

  // End the game
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

    // Disable the grid
    grid.classes.add("disabled");

    // Show the dialog
    gameOverDialog.open = true;
  }

  // @return number of cells without moves in them
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