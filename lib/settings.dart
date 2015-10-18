part of TicTacToe3;

class Settings {
	static BooleanSetting iconCursors, cellColours;
	static StringSetting gridColour, bgColour;
	static SelectSetting opponent;

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
		opponent = new SelectSetting("computerOpponent", callback: (List<String> result) {
			Difficulty difficulty = parseDifficulty(result[0]);
			Player player = parsePlayer(result[1]);
			Game.computerOpponent = new Opponent(player, difficulty);
		}, defaultValue: "Difficulty.NULL|Player.NULL");

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
	static final DialogElement _element = querySelector("dialog#settings")
		..querySelector(".score_reset").onClick.listen((_) => Score.resetAll());

	static set open(bool setOpen) {
		if (setOpen) {
			// Close button
			_element.querySelector("button.close").onClick.first.then((_) => open = false);
			// Disable the grid
			Grid.disabled = true;
			// Show the dialog
			_element.open = setOpen;
			// Disable the opponent settings if the game is running
			if (Game.playing) {
				Settings.opponent.control
					..disabled = true
					..title = "You cannot change this while the game is running!";
			} else {
				Settings.opponent.control
					..disabled = false
					..title = "";
			}
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
	CheckboxInputElement get control => _checkbox;
	Function _callback = (bool newValue) {};

	BooleanSetting(String id, {Function callback, bool defaultValue: true}) : _id = id, _callback = callback {
		if (window.localStorage["ttt3_$_id"] != null) {
			try {
				enabled = (window.localStorage["ttt3_$_id"] == "true");
			} catch(e) {
				window.console.warn("Error parsing setting $id: $e");
				enabled = defaultValue;
			}
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
	InputElement _input;
	InputElement get control => _input;
	Function _callback = (String newValue) {};

	StringSetting(String id, {Function callback, String defaultValue: ""}) : _id = id, _callback = callback {
		if (window.localStorage["ttt3_$_id"] != null) {
			try {
				value = window.localStorage["ttt3_$_id"];
			} catch(e) {
				window.console.warn("Error parsing setting $id: $e");
				value = defaultValue;
			}
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

class SelectSetting {
	String _id;
	String _value;
	SelectElement _inputSelect;
	SelectElement get control => _inputSelect;
	Function _callback = (List<String> newValue) {};

	SelectSetting(String id, {Function callback, String defaultValue: "NULL|NULL"}) : _id = id, _callback = callback {
		if (window.localStorage["ttt3_$_id"] != null) {
			try {
				value = window.localStorage["ttt3_$_id"];
			} catch(e) {
				window.console.warn("Error parsing setting $id: $e");
				value = defaultValue;
			}
		} else {
			value = defaultValue;
		}

		_inputSelect = querySelector("#$id")
			..onChange.listen((_) => value = _inputSelect.value);
		_inputSelect.value = strValue;
	}

	set value(dynamic newValue) {
		if (newValue is List<String>) {
			_value = buildValue(newValue);
		} else if (newValue is String) {
			_value = newValue;
		}

		Function.apply(_callback, [parseValue(_value)]);
		window.localStorage["ttt3_$_id"] = _value;
	}

	List<String> get value => parseValue(_value);
	String get strValue => _value;

	List<String> parseValue(String value) {
		return value.split("|");
	}

	String buildValue(List<String> value) {
		return value[0] + "|" + value[1];
	}
}