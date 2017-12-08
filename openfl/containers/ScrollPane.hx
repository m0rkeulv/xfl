package openfl.containers;

import openfl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import xfl.XFL;
import xfl.XFLAssets;

/**
 * Scrollpane
 */
class ScrollPane extends UIComponent {

    public var source(get, set): DisplayObject;
    public var scrollY(get, set): Float;

    public var horizontalScrollPolicy: String;
    public var verticalScrollPolicy: String;

    public var verticalScrollPosition: Int;
    public var verticalScrollBar: Dynamic;

    private var _source: DisplayObject;

    /**
     * Public constructor
     **/
    public function new(name: String = null, xflSymbolArguments: XFLSymbolArguments = null)
    {
        super(name, xflSymbolArguments != null?xflSymbolArguments:XFLAssets.getInstance().createXFLSymbolArguments("fl.containers.ScrollPane"));
        var maskSprite: Sprite = new Sprite();
        maskSprite.visible = false;
        addChild(maskSprite);
        mask = maskSprite;
        update();
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
    }

    override public function setSize(_width: Float, _height: Float) : Void {
        super.setSize(_width, _height);
        update();
    }

    public function update() : Void {
        var maskSprite: Sprite = cast(mask, Sprite);
        maskSprite.graphics.clear();
        maskSprite.graphics.beginFill(0x000000);
        maskSprite.graphics.drawRect(0.0, 0.0, _width, _height);
        maskSprite.graphics.endFill();
    }

    private function get_source(): DisplayObject {
        return _source;
    }

    private function set_source(_source: DisplayObject): DisplayObject {
        if (this._source != null) removeChild(this._source);
        this._source = _source;
        addChild(this._source);
        update();
        return this._source;
    }

    public function get_scrollY(): Float {
        return -source.y;
    }

    public function set_scrollY(scrollY: Float): Float {
        source.y = -scrollY;
        if (source.y > 0.0) source.y = 0.0;
        if (source.y < -(source.height - _height)) source.y = -(source.height - _height);
        return source.y;
    }

    private function onMouseWheel(event: MouseEvent): Void {
        source.y+= event.delta;
        if (source.y > 0.0) source.y = 0.0;
        if (source.y < -(source.height - _height)) source.y = -(source.height - _height);
    }

}
