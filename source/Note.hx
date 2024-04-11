package;

import NoteShader.ColoredNoteShader;

using StringTools;

typedef EventNote = {
	strumTime:Float,
	event:String,
	value1:String,
	value2:String
}

typedef PreloadedChartNote = {
	strumTime:Float,
	noteData:Int,
	mustPress:Bool,
	noteType:String,
	animSuffix:String,
	noteskin:String,
	texture:String,
	noAnimation:Bool,
	noMissAnimation:Bool,
	gfNote:Bool,
	isSustainNote:Bool,
	isSustainEnd:Bool,
	sustainLength:Float,
	sustainScale:Float,
	parent:PreloadedChartNote,
	hitHealth:Float,
	missHealth:Float,
	hitCausesMiss:Null<Bool>,
	wasHit:Bool,
	multSpeed:Float,
	wasSpawned:Bool,
	ignoreNote:Bool,
	lowPriority:Bool,
	wasMissed:Bool
}

class Note extends FlxSprite
{
	public var row:Int = 0;
	public var strumTime:Float = 0;
	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var ignoreNote:Bool = false;
	public var hitByOpponent:Bool = false; //For Opponent notes
	public var prevNote:Note;

	public var blockHit:Bool = false; // only works for player

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var noteType:String = null;

	public var eventName:String = '';
	public var eventLength:Int = 0;
	public var eventVal1:String = '';
	public var eventVal2:String = '';

	public var colorSwap:ColorSwap;
	public var inEditor:Bool = Type.getClassName(Type.getClass(FlxG.state)) == 'editors.ChartingState';

	public var animSuffix:String = '';
	public var gfNote:Bool = false;
	public var earlyHitMult:Float = 0.5;
	public var lateHitMult:Float = 1;
	public var lowPriority:Bool = false;

	public static final swagWidth:Float = 160 * 0.7;
	
	public static final colArray:Array<String> = ['purple', 'blue', 'green', 'red'];
	private final pixelInt:Array<Int> = [0, 1, 2, 3];
	public final arrowAngles:Array<Int> = [180, 90, 270, 0];

	// Lua shit
	public var noteSplashDisabled:Bool = false;
	public var noteSplashTexture:String = null;
	public var noteSplashHue:Float = 0;
	public var noteSplashSat:Float = 0;
	public var noteSplashBrt:Float = 0;

	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var offsetAngle:Float = 0;
	public var multAlpha:Float = 1;
	public var multSpeed:Float = 1;

	public var copyX:Bool = true;
	public var copyY:Bool = true;
	public var copyScale:Bool = true;
	public var copyAngle:Bool = true;
	public var copyAlpha:Bool = true;

	public var dumbHitboxThing:Bool = true;

	public var hitHealth:Float = 0.023;
	public var missHealth:Float = 0.0475;
	public var rating:String = 'unknown';
	public var ratingMod:Float = 0; //9 = unknown, 0.25 = shit, 0.5 = bad, 0.75 = good, 1 = sick
	public var ratingDisabled:Bool = false;

	public var texture(default, set):String = null;

	public var sustainScale:Float = 1;

	public var noAnimation:Bool = false;
	public var noMissAnimation:Bool = false;
	public var hitCausesMiss:Bool = false;
	public var distance:Float = 2000; //plan on doing scroll directions soon -bb

	public var hitsoundDisabled:Bool = false;

	inline private function set_texture(value:String):String {
		if (!PlayState.isPixelStage)
		{
			if (!Paths.noteSkinFramesMap.exists(value)) Paths.initNote(4, value);
			frames = @:privateAccess Paths.noteSkinFramesMap.get(value);
			animation.copyFrom(@:privateAccess Paths.noteSkinAnimsMap.get(value));
			antialiasing = ClientPrefs.globalAntialiasing;
			scale.set(0.7, 0.7);
			updateHitbox();
		}
		texture = value;
		return value;
	}

	public function new()
	{
		super();

		if (prevNote == null)
			prevNote = this;

		y -= 2000;

		if(noteData > -1) {
			if (ClientPrefs.showNotes)
			{
				frames = @:privateAccess Paths.defaultNoteStuff[0];
				animation.copyFrom(@:privateAccess Paths.defaultNoteStuff[1]);
				antialiasing = ClientPrefs.globalAntialiasing;
				scale.set(0.7, 0.7);
				updateHitbox();
			}
			if (ClientPrefs.enableColorShader && inEditor)
			{
				colorSwap = new ColorSwap();
				shader = colorSwap.shader;
				if (ClientPrefs.noteColorStyle == 'Normal' && noteData < ClientPrefs.arrowHSV.length)
				{
					colorSwap.hue = ClientPrefs.arrowHSV[noteData][0] / 360;
					colorSwap.saturation = ClientPrefs.arrowHSV[noteData][1] / 100;
					colorSwap.brightness = ClientPrefs.arrowHSV[noteData][2] / 100;
				}
				if (ClientPrefs.noteColorStyle == 'Rainbow')
				{
					colorSwap.hue = ((strumTime / 5000 * 360) / 360) % 1;
				}
				if (ClientPrefs.noteColorStyle == 'Char-Based')
				{
					if (PlayState.instance != null) {
						if (!mustPress) !PlayState.opponentChart ? this.shader = new ColoredNoteShader(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2], false, 10) : this.shader = new ColoredNoteShader(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2], false, 10);
						if (mustPress) {
							!PlayState.opponentChart ? this.shader = new ColoredNoteShader(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2], false, 10) : this.shader = new ColoredNoteShader(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2], false, 10);
						}
						if (gfNote) {
							if (PlayState.instance.gf != null) this.shader = new ColoredNoteShader(PlayState.instance.gf.healthColorArray[0], PlayState.instance.gf.healthColorArray[1], PlayState.instance.gf.healthColorArray[2], false, 10);
						}
					}
				}
			}
		}
	}

	var lastNoteOffsetXForPixelAutoAdjusting:Float = 0;
	var lastNoteScaleToo:Float = 1;
	public var originalHeightForCalcs:Float = 6;
	public var correctionOffset:Float = 0; //dont mess with this
	function reloadNote(?prefix:String = '', ?texture:String = '', ?suffix:String = '') {
		if(prefix == null) prefix = '';
		if(texture == null) texture = '';
		if(suffix == null) suffix = '';

		var skin:String = texture;
		if(texture.length < 1) {
			if (PlayState.instance != null) skin = PlayState.SONG.arrowSkin;
			if(skin == null || skin.length < 1) {
				skin = 'NOTE_assets';
			}
		}

		var animName:String = null;
		if(animation.curAnim != null) {
			animName = animation.curAnim.name;
		}

		var arraySkin:Array<String> = skin.split('/');
		arraySkin[arraySkin.length-1] = prefix + arraySkin[arraySkin.length-1] + suffix;

		var lastScaleY:Float = scale.y;
		var blahblah:String = arraySkin.join('/');
		if(PlayState.isPixelStage) {
			if(isSustainNote) {
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'));
				width = width / 4;
				height = height / 2;
				originalHeightForCalcs = height;
				loadGraphic(Paths.image('pixelUI/' + blahblah + 'ENDS'), true, Math.floor(width), Math.floor(height));
			} else {
				loadGraphic(Paths.image('pixelUI/' + blahblah));
				width = width / 4;
				height = height / 5;
				loadGraphic(Paths.image('pixelUI/' + blahblah), true, Math.floor(width), Math.floor(height));
			}
			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			loadPixelNoteAnims();
			antialiasing = false;

			if(isSustainNote) {
				offsetX += lastNoteOffsetXForPixelAutoAdjusting;
				lastNoteOffsetXForPixelAutoAdjusting = (width - 7) * (PlayState.daPixelZoom / 2);
				offsetX -= lastNoteOffsetXForPixelAutoAdjusting;

				/*if(animName != null && !animName.endsWith('end'))
				{
					lastScaleY /= lastNoteScaleToo;
					lastNoteScaleToo = (6 / height);
					lastScaleY *= lastNoteScaleToo;
				}*/
			}
		} else {
			frames = Paths.getSparrowAtlas(blahblah);
			loadNoteAnims();
			if(!isSustainNote)
			{
				centerOffsets();
				centerOrigin();
			}
			antialiasing = ClientPrefs.globalAntialiasing;
		}
		if(isSustainNote) {
			scale.y = lastScaleY;
		}
		updateHitbox();

		if(animName != null)
			animation.play(animName, true);

		if(inEditor) {
			setGraphicSize(editors.ChartingState.GRID_SIZE, editors.ChartingState.GRID_SIZE);
			updateHitbox();
		}
	}

	function loadNoteAnims() {
		animation.addByPrefix(colArray[noteData] + 'Scroll', colArray[noteData] + '0');

		if (isSustainNote)
		{
			animation.addByPrefix('purpleholdend', 'pruple end hold'); // ?????
			animation.addByPrefix(colArray[noteData] + 'holdend', colArray[noteData] + ' hold end');
			animation.addByPrefix(colArray[noteData] + 'hold', colArray[noteData] + ' hold piece');
		}

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
	}

	function loadPixelNoteAnims() {
		if(isSustainNote)
		{
			animation.add(colArray[noteData] + 'holdend', [noteData + 4], 24, true);
			animation.add(colArray[noteData] + 'hold', [noteData], 24, true);
		} else animation.add(colArray[noteData] + 'Scroll', [noteData + 4], 24, true);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			// ok river
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * lateHitMult)
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult) || (PlayState.instance != null && PlayState.instance.cpuControlled))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * earlyHitMult))
			{
				if((isSustainNote && prevNote.wasGoodHit) || strumTime <= Conductor.songPosition)
					wasGoodHit = true;
			}
		}

		if (tooLate && !inEditor)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}

	inline public function followStrum(strum:StrumNote, fakeCrochet:Float, songSpeed:Float = 1):Void
	{
		if (isSustainNote) 
		{
			flipY = strum.downScroll;
			offsetX += width / 2;
			scale.set(0.7, animation != null && animation.curAnim != null && animation.curAnim.name.endsWith('end') ? 1 : Conductor.stepCrochet * 0.0105 * (songSpeed * multSpeed) * sustainScale);
			if (PlayState.isPixelStage) 
			{
				scale.x *= PlayState.daPixelZoom;
				scale.y *= PlayState.daPixelZoom;
			}

			updateHitbox();
			offsetX -= width / 2;
		}
			
		distance = (0.45 * (Conductor.songPosition - strumTime) * songSpeed * multSpeed);
		if (!strum.downScroll) distance *= -1;

		if(animation != null && animation.curAnim != null && animation.curAnim.name.endsWith('end'))
		{
			y -= height-2;
		}

		if(copyScale && isSustainNote)
			if (!dumbHitboxThing)
				updateHitbox();

		if (copyAngle)
			angle = strum.direction - 90 + strum.angle + offsetAngle;

		if(copyAlpha)
			alpha = strum.alpha * multAlpha;

		if(copyX)
			x = strum.x + offsetX + Math.cos(strum.direction * Math.PI / 180) * distance;

		if(copyY)
		{
			y = strum.y + offsetY + correctionOffset + Math.sin(strum.direction * Math.PI / 180) * distance;
			if(strum.downScroll && isSustainNote)
			{
				if(PlayState.isPixelStage)
				{
					y -= PlayState.daPixelZoom * 9.5;
				}
				y -= (frameHeight * scale.y) - (Note.swagWidth / 2);
			}
		}
	}

	public function clipToStrumNote(myStrum:StrumNote)
	{
		final center:Float = myStrum.y + offsetY + Note.swagWidth / 2;
		if(isSustainNote && (mustPress || !ignoreNote) &&
			(!mustPress || (wasGoodHit || (prevNote.wasGoodHit && !canBeHit))))
		{
			final swagRect:FlxRect = clipRect != null ? clipRect : new FlxRect(0, 0, frameWidth, frameHeight);

			if (myStrum.downScroll)
			{
				if(y - offset.y * scale.y + height >= center)
				{
					swagRect.width = frameWidth;
					swagRect.height = (center - y) / scale.y;
					swagRect.y = frameHeight - swagRect.height;
				}
			}
			else if (y + offset.y * scale.y <= center)
			{
				swagRect.y = (center - y) / scale.y;
				swagRect.width = width / scale.x;
				swagRect.height = (height / scale.y) - swagRect.y;
			}
			clipRect = swagRect;
		}
	}
	public function updateRGBColors() {
        	if (Std.isOfType(this.shader, ColoredNoteShader))
		{
			if (mustPress)
	    			!PlayState.opponentChart ? cast(this.shader, ColoredNoteShader).setColors(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]) : cast(this.shader, ColoredNoteShader).setColors(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2]);
	    		else if (!gfNote) 
				!PlayState.opponentChart ? cast(this.shader, ColoredNoteShader).setColors(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2]) : cast(this.shader, ColoredNoteShader).setColors(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2]);
	    		else if (gfNote && PlayState.instance.gf != null) cast(this.shader, ColoredNoteShader).setColors(PlayState.instance.gf.healthColorArray[0], PlayState.instance.gf.healthColorArray[1], PlayState.instance.gf.healthColorArray[2]);
		}
	}
	// this is used for note recycling
	public function setupNoteData(chartNoteData:PreloadedChartNote):Note
	{
		if (ClientPrefs.enableColorShader)
		{
			colorSwap = new ColorSwap();
			shader = colorSwap.shader;
		}
		wasGoodHit = hitByOpponent = tooLate = false; // Don't make an update call of this for the note group

		strumTime = chartNoteData.strumTime;
		if(!inEditor) strumTime += ClientPrefs.noteOffset;
		noteData = inline Std.int(chartNoteData.noteData % 4);
		noteType = chartNoteData.noteType;
		animSuffix = chartNoteData.animSuffix;
		noAnimation = noMissAnimation = chartNoteData.noAnimation;
		mustPress = chartNoteData.mustPress;
		gfNote = chartNoteData.gfNote;
		isSustainNote = chartNoteData.isSustainNote;
		if (chartNoteData.noteskin.length > 0 && chartNoteData.noteskin != '' && chartNoteData.noteskin != texture) texture = 'noteskins/' + chartNoteData.noteskin;
		if (chartNoteData.texture.length > 0 && chartNoteData.texture != texture) texture = chartNoteData.texture;
		sustainLength = chartNoteData.sustainLength;
		sustainScale = chartNoteData.sustainScale;
		lowPriority = chartNoteData.lowPriority;

		hitHealth = chartNoteData.hitHealth;
		missHealth = chartNoteData.missHealth;
		hitCausesMiss = chartNoteData.hitCausesMiss;
		ignoreNote = chartNoteData.ignoreNote;
		multSpeed = chartNoteData.multSpeed;

		if (ClientPrefs.enableColorShader)
		{
			if (ClientPrefs.noteColorStyle == 'Normal' && noteData < ClientPrefs.arrowHSV.length)
			{
				colorSwap.hue = ClientPrefs.arrowHSV[noteData][0] / 360;
				colorSwap.saturation = ClientPrefs.arrowHSV[noteData][1] / 100;
				colorSwap.brightness = ClientPrefs.arrowHSV[noteData][2] / 100;
			}
			if (ClientPrefs.noteColorStyle == 'Quant-Based') CoolUtil.checkNoteQuant(this, isSustainNote ? chartNoteData.parent.strumTime : chartNoteData.strumTime);
			if (ClientPrefs.noteColorStyle == 'Rainbow')
			{
				colorSwap.hue = ((strumTime / 5000 * 360) / 360) % 1;
			}
			if (ClientPrefs.noteColorStyle == 'Char-Based')
			{
				if (PlayState.instance != null) {
					if (!mustPress) !PlayState.opponentChart ? this.shader = new ColoredNoteShader(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2], false, 10) : this.shader = new ColoredNoteShader(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2], false, 10);
					if (mustPress) {
						!PlayState.opponentChart ? this.shader = new ColoredNoteShader(PlayState.instance.boyfriend.healthColorArray[0], PlayState.instance.boyfriend.healthColorArray[1], PlayState.instance.boyfriend.healthColorArray[2], false, 10) : this.shader = new ColoredNoteShader(PlayState.instance.dad.healthColorArray[0], PlayState.instance.dad.healthColorArray[1], PlayState.instance.dad.healthColorArray[2], false, 10);
					}
					if (gfNote) {
						if (PlayState.instance.gf != null) this.shader = new ColoredNoteShader(PlayState.instance.gf.healthColorArray[0], PlayState.instance.gf.healthColorArray[1], PlayState.instance.gf.healthColorArray[2], false, 10);
					}
				}
			}
		}

		if (noteType == 'Hurt Note')
		{
			texture = 'HURTNOTE_assets';
			noteSplashTexture = 'HURTnoteSplashes';
			if (ClientPrefs.enableColorShader)
			{
				colorSwap.hue = colorSwap.saturation = colorSwap.brightness = 0;
			}
		}

		if (PlayState.isPixelStage) reloadNote('', texture);
		animation.play((ClientPrefs.noteColorStyle == 'Normal' || (ClientPrefs.noteStyleThing == 'TGT V4' || PlayState.isPixelStage) ? colArray[noteData % 4] : 'red') + 'Scroll');
		if (isSustainNote) animation.play((ClientPrefs.noteColorStyle == 'Normal' || (ClientPrefs.noteStyleThing == 'TGT V4' || PlayState.isPixelStage) ? colArray[noteData % 4] : 'red') + (chartNoteData.isSustainEnd ? 'holdend' : 'hold'));

		if (isSustainNote) {
			correctionOffset = ClientPrefs.downScroll ? 0 : 55;
			copyAngle = false;
		}

		if (ClientPrefs.doubleGhost && !isSustainNote)
		{
			row = inline Conductor.secsToRow(strumTime);
			if(PlayState.instance.noteRows[mustPress?0:1][row] == null)
				PlayState.instance.noteRows[mustPress?0:1][row] = [];
				PlayState.instance.noteRows[mustPress ? 0 : 1][row].push(this);
		}

		return this;
	}
}