part of TicTacToe3;

class Settings {
	static void init() {
		// Set up gridline color
		if (window.localStorage["ttt3_gridColor"] != null) {
			gridColor = window.localStorage["ttt3_gridColor"];
		}

		// Set up background color
		if (window.localStorage["ttt3_bgColor"] != null) {
			bgColor = window.localStorage["ttt3_bgColor"];
		}

		// Set up custom cursors
		if (window.localStorage["ttt3_cursors"] != null) {
			iconCursors = (window.localStorage["ttt3_cursors"] == "true");
		} else {
			iconCursors = true;
		}

		// Load konami
		updateKonami();

		// Enable settings dialog
		querySelector("#settings-btn").onClick.listen((Event e) {
			e.preventDefault();
			SettingsWindow.open = true;
		});
	}

	// Color of the gridlines
	static String _gridColor = "#444444";
	static String get gridColor => _gridColor;
	static set gridColor(String value) {
		_gridColor = value;
		Grid.element.style.borderColor = _gridColor;
		window.localStorage["ttt3_gridColor"] = _gridColor;
	}

	// Color of the gridlines
	static String _bgColor = "#FFFFFF";
	static String get bgColor => _bgColor;
	static set bgColor(String value) {
		_bgColor= value;
		document.body.style.backgroundColor = _bgColor;
		window.localStorage["ttt3_bgColor"] = _bgColor;
	}

	// Custom cursors
	static bool _iconCursors = true;
	static bool get iconCursors => _iconCursors;
	static set iconCursors(bool value) {
		_iconCursors = value;
		if (value) {
			document.body.classes.add("cursors");
		} else {
			document.body.classes.remove("cursors");
		}
		window.localStorage["ttt3_cursors"] = iconCursors.toString();
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
	/// Updates the konami display state, or toggles it (if activate is set to true)
	static void updateKonami([bool activate = false]) {
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
	static final InputElement _gridColorPicker = _element.querySelector("#gridColor");
	static final InputElement _bgColorPicker = _element.querySelector("#bgColor");
	static final CheckboxInputElement _cursors = _element.querySelector("#cursors");

	static set open(bool setOpen) {
		if (setOpen) {
			// Close button
			_element.querySelector("button.close").onClick.first.then((_) => open = false);
			// Grid color
			_gridColorPicker
				..value = Settings.gridColor
				..onChange.listen((_) => Settings.gridColor = _gridColorPicker.value);
			// Background color
			_bgColorPicker
				..value = Settings.bgColor
				..onChange.listen((_) => Settings.bgColor = _bgColorPicker.value);
			// Cursors
			_cursors
				..checked = Settings.iconCursors
				..onChange.listen((_) => Settings.iconCursors = _cursors.checked);
		}
		_element.open = setOpen;
	}
}