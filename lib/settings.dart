part of TicTacToe3;

class Settings {
	static BooleanSetting iconCursors, cellColours;
	static StringSetting gridColour, bgColour;

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
	static final InputElement _gridColourPicker = _element.querySelector("#gridColour");
	static final InputElement _bgColourPicker = _element.querySelector("#bgColour");
	static final CheckboxInputElement _cursors = _element.querySelector("#cursors");
	static final CheckboxInputElement _cellColours = _element.querySelector("#cellColours");

	static set open(bool setOpen) {
		if (setOpen) {
			// Close button
			_element.querySelector("button.close").onClick.first.then((_) => open = false);
			// Grid colour
			_gridColourPicker
				..value = Settings.gridColour.value
				..onChange.listen((_) => Settings.gridColour.value = _gridColourPicker.value);
			// Background colour
			_bgColourPicker
				..value = Settings.bgColour.value
				..onChange.listen((_) => Settings.bgColour.value = _bgColourPicker.value);
			// Cursors
			_cursors
				..checked = Settings.iconCursors.enabled
				..onChange.listen((_) => Settings.iconCursors.enabled = _cursors.checked);
			// Cell colours
			_cellColours
				..checked = Settings.cellColours.enabled
				..onChange.listen((_) => Settings.cellColours.enabled = _cellColours.checked);
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
	Function callback = (bool newValue){};

	BooleanSetting(String id, {this.callback, bool defaultValue: true}) : _id = id {
		if (window.localStorage["ttt3_$_id"] != null) {
			enabled = (window.localStorage["ttt3_$_id"] == "true");
		} else {
			enabled = defaultValue;
		}
	}

	set enabled(bool newValue) {
		_enabled = newValue;
		Function.apply(callback, [newValue]);
		window.localStorage["ttt3_$_id"] = newValue.toString();
	}

	bool get enabled => _enabled;
}

class StringSetting {
	String _id;
	String _value;
	Function callback = (String newValue){};

	StringSetting(String id, {this.callback, String defaultValue: ""}) : _id = id {
		if (window.localStorage["ttt3_$_id"] != null) {
			value = window.localStorage["ttt3_$_id"];
		} else {
			value = defaultValue;
		}
	}

	set value(String newValue) {
		_value = newValue;
		Function.apply(callback, [newValue]);
		window.localStorage["ttt3_$_id"] = newValue;
	}

	String get value => _value;
}