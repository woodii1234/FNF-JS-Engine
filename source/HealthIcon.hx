package;

import flixel.math.FlxMath;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;

using StringTools;

enum abstract IconType(Int) to Int from Int //abstract so it can hold int values for the frame count
{
    var SINGLE = 0;
    var DEFAULT = 1;
    var WINNING = 2;
}
class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var canBounce:Bool = false;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var type:IconType = DEFAULT;

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);

		if(canBounce) {
			var mult:Float = FlxMath.lerp(1, scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			scale.set(mult, mult);
			updateHitbox();
		}
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	public var offsets(default, set):Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:FlxGraphic = Paths.image(name);

			type = (file.width < 200 ? SINGLE : ((file.width > 199 && file.width < 301) ? DEFAULT : WINNING));

			loadGraphic(file, true, Math.floor(file.width / (type+1)), file.height);
			offsets[0] = offsets[1] = (width - 150) / (type+1);
			var frames:Array<Int> = [];
			for (i in 0...type+1) frames.push(i);
			animation.add(char, frames, 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			//Earlier Version Icon Control Support
			antialiasing = !char.endsWith('-pixel');
			updateHitbox();
			animation.play(char);
			this.char = char;

			if (antialiasing) antialiasing = ClientPrefs.globalAntialiasing;
		}
	}

	public function bounce() {
		if(canBounce) {
			var mult:Float = 1.2;
			scale.set(mult, mult);
			updateHitbox();
		}
	}

	override function updateHitbox()
	{
		if (ClientPrefs.iconBounceType != 'Golden Apple' && ClientPrefs.iconBounceType != 'Dave and Bambi' || Type.getClassName(Type.getClass(FlxG.state)) != 'PlayState')
		{
		super.updateHitbox();
		offset.x = offsets[0];
		offset.y = offsets[1];
		} else {
		super.updateHitbox();
		}
	}

	function set_offsets(newArr:Array<Float>):Array<Float>
	{
		offsets = newArr;
		offset.x = offsets[0];
		offset.y = offsets[1];
		return offsets;
	}

	public function getCharacter():String {
		return char;
	}
}
