part of TicTacToe3;

class Settings {
	static BooleanSetting iconCursors, cellColours;
	static StringSetting gridColour, bgColour, opponent;

	static void init() {
		// Whether or not to use the player's symbol as the cursor
		iconCursors = new BooleanSetting("cursors", callback: (bool newValue) {
			if (newValue) {
				document.body.classes.add("cursors");
			} else {
				document.body.classes.remove("cursors");
			}
		});

		// Whether or not to fill in cell backgrounds
		cellColours = new BooleanSetting("cellColours", callback: (bool newValue) {
			if (newValue) {
				document.body.classes.add("cell-colours");
			} else {
				document.body.classes.remove("cell-colours");
			}
		});

		// Color of the gridlines
		gridColour = new StringSetting("gridColour", callback: (String newValue) {
			Grid.element.style.borderColor = newValue;
		}, defaultValue: "#444444");

		// Color of the page background
		bgColour = new StringSetting("bgColour", callback: (String newValue) {
			document.body.style.backgroundColor = newValue;
		}, defaultValue: "#FFFFFF");

		// Computer opponent
		opponent = new StringSetting("computerOpponent", callback: (String opponent) {
			print(opponent);
			Player computer = Player.values.where((Player p) {
				return (p.toString() == opponent.split("_")[1]);
			}).toList().first;
			if (computer != Player.NULL) {
				Difficulty difficulty = Difficulty.values.where((Difficulty d) {
					return (d.toString() == opponent.split("_")[0]);
				});
				Game.computerOpponent = new Opponent(computer, difficulty);
			}
		}, defaultValue: "NULL_NULL");

		// Load konami
		updateKonami();

		// Enable settings dialog
		querySelector("#settings-btn").onClick.listen((Event e) {
			e.preventDefault();
			SettingsWindow.open = true;
		});
	}

	// Konami mode
	static bool get konami {
		return window.localStorage["ttt3_konami"] != null &&
		       window.localStorage["ttt3_konami"] == "true";
	}
	static set konami(bool value) {
		window.localStorage["ttt3_konami"] = value.toString();
		updateKonami();
	}
	static void updateKonami([bool activate = false]) {
		// Updates the konami display state, or toggles it (if activate is set to true)

		if (activate) {
			konami = !konami;
		}

		if (konami) {
			document.body.classes.add("konami");
		} else {
			document.body.classes.remove("konami");
		}
	}
}

class SettingsWindow {
	static final DialogElement _element = querySelector("dialog#settings");

	static set open(bool setOpen) {
		if (setOpen) {
			// Close button
			_element.querySelector("button.close").onClick.first.then((_) => open = false);
			// Disable the grid
			Grid.disabled = true;
			// Show the dialog
			_element.open = setOpen;
		} else {
			if (Game.playing) {
				Grid.disabled = false;
			}
			// Hide the dialog
			_element.open = false;
		}
	}
}

class BooleanSetting {
	String _id;
	bool _enabled;
	CheckboxInputElement _checkbox;
	Function _callback = (bool newValue) {};

	BooleanSetting(String id, {Function callback, bool defaultValue: true}) : _id = id, _callback = callback {
		if (window.localStorage["ttt3_$_id"] != null) {
			enabled = (window.localStorage["ttt3_$_id"] == "true");
		} else {
			enabled = defaultValue;
		}

		_checkbox = (querySelector("#$id") as CheckboxInputElement)
			..onChange.listen((_) => enabled = _checkbox.checked);
		_checkbox.checked = enabled;
	}

	set enabled(bool newValue) {
		_enabled = newValue;
		Function.apply(_callback, [newValue]);
		window.localStorage["ttt3_$_id"] = newValue.toString();
	}

	bool get enabled => _enabled;
}

class StringSetting {
	String _id;
	String _value;
	Element _input;
	Function _callback = (String newValue) {};

	StringSetting(String id, {Function callback, String defaultValue: ""}) : _id = id, _callback = callback {
		if (window.localStorage["ttt3_$_id"] != null) {
			value = window.localStorage["ttt3_$_id"];
		} else {
			value = defaultValue;
		}

		_input = querySelector("#$id")
			..onChange.listen((_) => value = _input.value);
		_input.value = value;
	}

	set value(String newValue) {
		_value = newValue;
		Function.apply(_callback, [newValue]);
		window.localStorage["ttt3_$_id"] = newValue;
	}

	String get value => _value;
}