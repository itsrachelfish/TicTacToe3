part of TicTacToe3;

enum Player {
  O, X, D, NULL
}

class Game {
  static Player turn;

  static int _moves = 0;

  static Map<int, Player> _order = {
    0: Player.O,
    1: Player.X,
    2: Player.D
  };

  static void start() {
    // Randomize the move order
    List<Player> newOrder = _order.values.toList()
      ..shuffle();
    _order
      ..[0] = newOrder[0]
      ..[1] = newOrder[1]
      ..[2] = newOrder[2];

    // Clear the board
    UI.clearGrid();

    // Start the game
    _getNextTurn();

    new Service(["GAME_WON"], (Map win) {
      end(winner: win);
    });

    new Service(["CELL_CLICKED"], (int index) {
      _moves++;
      if (UI.countEmptyCells() == 0) {
        end(tie: true);
      } else {
        _getNextTurn();
      }
    });
  }

  static void end({Map winner, bool tie}) {
    if (winner != null) {
      UI.displayGameOver(winner);
    } else if (tie != null && tie == true) {
      UI.displayMessage("tie");
    }
  }

  static void _getNextTurn() {
    turn = _order[_moves % 3];
    UI.displayMessage("turn", getStateString(turn));
    UI.grid.dataset["turn"] = getStateString(turn, true);
  }

  static String getStateString(Player state, [bool sanitary = false]) {
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
}