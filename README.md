# TicTacToe3

This game is a 3-player version of Tic Tac Toe.

## Playing

The grid is 4x4, not the normal 3x3, but you still only need 3 in a row (horizontal, vertical, or diagonal) to win.

## Running

1. Download and install [Dartium](https://www.dartlang.org/tools/dartium/) (if you don't already have it)
1. Make sure you have the [Dart SDK](https://www.dartlang.org/tools/sdk/) (mainly, you'll need `pub`)
1. Download the code with `git clone` or by downloading the ZIP file from GitHub
1. Run `pub get` from the project directory to get dependencies
1. Open `./web/index.html` in Dartium to play

To play again, just repeat the last step (you'll already have the code and dependencies).
 
### Compiling

If you don't want to have to run Dart code, you can compile it to JavaScript to play in any browser.

1. Follow the steps under **Running** to get everything set up
1. Instead of opening in Dartium, run `pub build` from the project directory to generate a `build` folder with everything in it
1. You can now open `./build/web/index.html` in any browser with JavaScript support to play
    1. If you move the directory, know that everything inside the `./build/web/` folder is required
    
## Help/Bugs

Create an issue on this repository with any requests/bugs and we'll try to work on them.

# Credits

* Written in the [Dart](http://dartlang.org) language from Google (it's great!)
* Depends on the [transmit](https://github.com/ppvk/transmit) library for event routing (it's great, too!)