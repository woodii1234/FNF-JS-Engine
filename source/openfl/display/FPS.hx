package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
import flixel.util.FlxStringUtil;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
import flixel.FlxG;
#if flash
import openfl.Lib;
#end
import external.memory.Memory;
#if openfl
import openfl.system.System;
#end
import Main;
import flixel.util.FlxColor;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public static var instance:FPS;
	public var currentFPS(default, null):Float;

	@:noCompletion private var cacheCount:Float;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public static var mainThing:Main;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("VCR OSD Mono", 12, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	var colorInterp:Float = 0;
	var currentColor:Int = 0;

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		//Literally the stupidest thing i've done for the FPS counter but it allows it to update correctly when on 60 FPS??
		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.framerate) currentFPS = ClientPrefs.framerate;
		if (FlxG.state != null && Type.getClassName(Type.getClass(FlxG.state)) == 'PlayState' && PlayState.instance.playbackRate != 1) currentFPS /= PlayState.instance.playbackRate;

			text = (ClientPrefs.showFPS ? "FPS: " + (ClientPrefs.ffmpegMode ? ClientPrefs.targetFPS : currentFPS) : "");
			if (ClientPrefs.ffmpegMode) {
				text += " (Rendering Mode)";
			}
			
			if (ClientPrefs.showRamUsage) text += "\nMemory: " + CoolUtil.formatBytes(Memory.getCurrentUsage(), false, 2) + (ClientPrefs.showMaxRamUsage ? " / " + CoolUtil.formatBytes(Memory.getPeakUsage(), false, 2) : "");

			if (ClientPrefs.debugInfo) {
				text += '\nState: ${Type.getClassName(Type.getClass(FlxG.state))}';
				if (FlxG.state.subState != null)
					text += '\nSubstate: ${Type.getClassName(Type.getClass(FlxG.state.subState))}';
				text += "\nSystem: " + '${lime.system.System.platformLabel} ${lime.system.System.platformVersion}';
			}

			if (!ClientPrefs.ffmpegMode)
			{

				textColor = 0xFFFFFFFF;
				if (currentFPS <= ClientPrefs.framerate / 2 && currentFPS >= ClientPrefs.framerate / 3)
				{
					textColor = 0xFFFFFF00;
				}
				if (currentFPS <= ClientPrefs.framerate / 3 && currentFPS >= ClientPrefs.framerate / 4)
				{
					textColor = 0xFFFF8000;
				}
				if (currentFPS <= ClientPrefs.framerate / 4)
				{
					textColor = 0xFFFF0000;
				}
			}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += "\n";

		cacheCount = currentCount;
	}
}
