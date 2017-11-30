package xfl.symbol;

import xfl.dom.DOMLayer;
import xfl.dom.DOMTimeline;
import xfl.XFL;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.Lib;


class MovieClip extends xfl.display.MovieClip {

	private static var clips: Array <MovieClip> = new Array <MovieClip>();

	public var children: Array<DisplayObject>;

	public var parametersAreLocked: Bool;

	private var lastFrame: Int;
	private var layers: Array<DOMLayer>;
	private var playing: Bool;
	private var xfl: XFL;

	public function new(xfl: XFL, timeline: DOMTimeline, parametersAreLocked: Bool = false) {
		super();
		this.xfl = xfl;
		this.parametersAreLocked = parametersAreLocked;
		currentLabels = [];
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		lastFrame = -1;
		currentFrame = timeline != null?timeline.currentFrame:1;
		layers = [];
		children = [];
		totalFrames = Shared.init(layers, timeline, currentLabels);
		Shared.createFrames(this.xfl, this, layers, children);
		update();
		if (totalFrames > 1) {
			play();
		}
	}

	private inline function applyTween(start: Float, end: Float, ratio: Float): Float {
		return start + ((end - start) * ratio);
	}

	private function enterFrame(): Void {
		// Workaround: Somehow there seem to be some clips still around whereas removed I guess which having playing enabled
		var parent: DisplayObject = this.parent;
		while(true == true) {
			if (parent == Lib.current.stage) {
				break;
			} else
			if (parent == null) {
				stop();
				return;
			}
			parent = parent.parent;
		}
		if (lastFrame == currentFrame) {
			currentFrame++;
			if (currentFrame > totalFrames) {
				currentFrame = 1;
			}
		}
		update();
	}

	public override function flatten(): Void {
		Shared.flatten(this);
	}

	private function getFrame (frame: Dynamic): Int {
		if (Std.is(frame, Int)) {
			return cast frame;
		} else 
		if (Std.is (frame, String)) {
			for (label in currentLabels) {
				if (label.name == frame) {
					return label.frame + 1;
				}
			}
		}
		return 1;
	}

	public override function gotoAndPlay(frame: Dynamic, scene: String = null): Void {
		currentFrame = getFrame(frame);
		update();
		play();
	}

	public override function gotoAndStop(frame: Dynamic, scene: String = null): Void {
		currentFrame = getFrame(frame);
		update();
		stop();
	}

	public override function nextFrame(): Void {
		var next = currentFrame + 1;
		if (next > totalFrames) {
			next = totalFrames;
		}
		gotoAndStop(next);
	}

	public override function play(): Void {
		if (!playing && totalFrames > 1) {
			playing = true;
			clips.push(this);
		}
	}

	
	public override function prevFrame(): Void {
		var previous = currentFrame - 1;
		if (previous < 1) {
			previous = 1;
		}
		gotoAndStop(previous);
	}

	public override function stop(): Void {
		if (playing == true) {
			playing = false;
			clips.remove(this);
		}
	}

	public override function unflatten(): Void {
		lastFrame = -1;
		update();
	}

	private function update(): Void {
		if (currentFrame != lastFrame) {
			Shared.disableFrames(xfl, this, layers, lastFrame);
			Shared.enableFrame(xfl, this, layers, currentFrame);
			lastFrame = currentFrame;
		}
	}

	private static function onEnterFrame(event: Event): Void {
		for (clip in clips) {
			clip.enterFrame();
		}
	}

}
