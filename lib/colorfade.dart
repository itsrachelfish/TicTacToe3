part of TicTacToe3;

class ColorFader {
	/// Element to update the color of
	Element _element;

	Element get element => _element;

	set element(Element value) {
		if (_element == null) {
			_element = value;
			_element.classes.add("colorfade");
		}
	}

	/// How often to do it (only manually if not set)
	Duration interval;

	/// Whether to get random colors or go in order
	bool random;

	/// Store the current color
	int onColor = 0;

	/// Choose the next color
	String get nextColor {
		if (random) {
			// If we're getting random colors, get one
			onColor = rand.nextInt(ColorFader.colors.length);
		} else {
			if (onColor != colors.length && onColor != null) {
				// If we're going in order, get the next color
				onColor++;
			} else {
				// If we've reached the end, start over
				onColor = 0;
			}
		}
		return colors[onColor];
	}

	/// Update the element with the next color
	void updateColor() {
		element.style.backgroundColor = nextColor;
	}

	ColorFader(Element updateElement, {this.random: false, this.interval}) {
		element = updateElement;
		if (interval != null) {
			new Timer.periodic(interval, (_) => updateColor());
		}
	}

	/// List of all possible colors (grouped by hue)
	static List<String> colors = [
		"#EF5350",
		"#F44336",
		"#E53935",
		"#D32F2F",
		"#C62828",
		"#B71C1C",
		"#FF5252",
		"#FF1744",
		"#D50000",
		"#F06292",
		"#EC407A",
		"#E91E63",
		"#D81B60",
		"#C2185B",
		"#AD1457",
		"#880E4F",
		"#FF4081",
		"#F50057",
		"#C51162",
		"#BA68C8",
		"#AB47BC",
		"#9C27B0",
		"#8E24AA",
		"#7B1FA2",
		"#6A1B9A",
		"#4A148C",
		"#E040FB",
		"#D500F9",
		"#AA00FF",
		"#9575CD",
		"#7E57C2",
		"#673AB7",
		"#5E35B1",
		"#512DA8",
		"#4527A0",
		"#311B92",
		"#7C4DFF",
		"#651FFF",
		"#6200EA",
		"#7986CB",
		"#5C6BC0",
		"#3F51B5",
		"#3949AB",
		"#303F9F",
		"#283593",
		"#1A237E",
		"#536DFE",
		"#3D5AFE",
		"#2196F3",
		"#1E88E5",
		"#1976D2",
		"#1565C0",
		"#0D47A1",
		"#448AFF",
		"#2979FF",
		"#039BE5",
		"#0288D1",
		"#0277BD",
		"#01579B",
		"#0091EA",
		"#0097A7",
		"#00838F",
		"#006064",
		"#009688",
		"#00897B",
		"#00796B",
		"#00695C",
		"#004D40",
		"#43A047",
		"#388E3C",
		"#2E7D32",
		"#1B5E20",
		"#689F38",
		"#558B2F",
		"#33691E",
		"#EF6C00",
		"#E65100",
		"#FF5722",
		"#F4511E",
		"#E64A19",
		"#D84315",
		"#BF360C",
		"#FF3D00",
		"#DD2C00",
		"#A1887F",
		"#8D6E63",
		"#795548",
		"#6D4C41",
		"#5D4037",
		"#4E342E",
		"#3E2723",
		"#757575",
		"#616161",
		"#424242",
		"#212121",
		"#78909C",
		"#607D8B",
		"#546E7A",
		"#455A64",
		"#37474F",
		"#263238"
	];
}