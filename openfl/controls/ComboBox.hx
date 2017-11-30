package openfl.controls;

import openfl.core.UIComponent;
import openfl.data.DataProvider;
import openfl.display.XFLSprite;

/**
 * Combo box grid
 */
class ComboBox extends UIComponent {

    public var selectedIndex: Int;
    public var dataProvider: DataProvider;
    public var selectedItem: Dynamic;

    /**
     * Public constructor
     **/
    public function new() {
        super();
    }

    public function move(x: Int, y: Int): Void {
    }

}
