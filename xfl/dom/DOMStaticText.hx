package xfl.dom;

import xfl.geom.Matrix;
import haxe.xml.Fast;

class DOMStaticText {

	public var height: Float;
	public var isSelectable: Bool;
	public var multiLine: Bool;
	public var left: Float;
	public var matrix: Matrix;
	public var textRuns: Array<DOMTextRun>;
	public var width: Float;

	public function new() {
		textRuns = new Array <DOMTextRun> ();
	}

	public static function parse (xml: Fast): DOMStaticText {
		var staticText = new DOMStaticText();
		staticText.height = Std.parseFloat(xml.att.height);
		staticText.width = Std.parseFloat(xml.att.width);
		staticText.multiLine = xml.has.lineType == true && xml.att.lineType == "multiline";
		staticText.left = (xml.has.left == true)?Std.parseFloat(xml.att.left):0;
		staticText.isSelectable = xml.has.isSelectable == false || xml.att.isSelectable == "true";
		for (element in xml.elements) {
			switch (element.name) {
				case "matrix":
					staticText.matrix = Matrix.parse (element.elements.next ());
				case "textRuns":
					for (childElement in element.elements) {
						staticText.textRuns.push (DOMTextRun.parse (childElement));
					}
			}
		}
		return staticText;
	}

}
