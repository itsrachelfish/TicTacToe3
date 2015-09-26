library TicTacToe3;

import "dart:html";
import "dart:math";

import "package:transmit/transmit.dart";

part "package:TicTacToe3/cell.dart";
part "package:TicTacToe3/game.dart";
part "package:TicTacToe3/ui.dart";

Random rand = new Random();

void main() {
  // Initialize cells
  for (int i = 0; i <= 15; i++) {
    new Cell(i);
  }

  // Size table
  UI.sizeTable();

  // Prompt for starting
  UI.displayMessage("start");
}