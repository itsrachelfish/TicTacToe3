library TicTacToe3;

import "dart:html";
import "dart:math";

import "package:transmit/transmit.dart";

part "package:TicTacToe3/cell.dart";
part "package:TicTacToe3/game.dart";
part "package:TicTacToe3/ui.dart";

Random rand = new Random();

void main() {
  window.console.warn(
      "The world is not perfect. "
      "Expect 404s of script files: "
      "main.dart.js is missing when running Dart code, "
      "and main.dart is missing when deployed."
  );

  // Initialize cells
  for (int i = 0; i <= 15; i++) {
    new Cell(i);
  }

  // Size table (will be done again if the browser window resizes)
  UI.sizeTable();

  // Prompt for starting
  UI.displayMessage("start");
}