package;

import flixel.input.keyboard.FlxKey;

#if VIDEOS_ALLOWED // Modify if i drunk coffee and fucked up! - SyncGit12
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;
import hxvlc.util.Handle;
import hxvlc.openfl.Video;
#end

class StartupState extends MusicBeatState
{
	var logo:FlxSprite;
	var skipTxt:FlxText;

	var maxIntros:Int = 3;
	var date:Date = Date.now();

	var canChristmas = false;

	public function startVideo(name:String, ?callback:Void->Void = null)
		{
			#if VIDEOS_ALLOWED
			inCutscene = true;
	
			var filepath:String = Paths.video(name);
			#if sys
			if(!FileSystem.exists(filepath))
			#else
			if(!OpenFlAssets.exists(filepath))
			#end
			{
				FlxG.log.warn('Couldnt find video file: ' + name);
				return;
			}
	
			vidSprite = new FlxVideoSprite(0, 0);
			vidSprite.active = false;
			vidSprite.antialiasing = true;
			vidSprite.bitmap.onFormatSetup.add(function():Void
			{
				if (video.bitmap != null && video.bitmap.bitmapData != null)
				{
					final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);
	
					vidSprite.setGraphicSize(video.bitmap.bitmapData.width * scale, video.bitmap.bitmapData.height * scale);
					vidSprite.updateHitbox();
					vidSprite.screenCenter();
				}
			});
			vidSprite.bitmap.onEndReached.add(vidSprite.destroy);
			//#if (hxCodec < "3.0.0")
			vidSprite.load(filepath);
	
			/*public function startAndEnd()
			{
				if(endingSong)
					endSong();
				else
					startCountdown();
			}*/
	
			/*public function goToTitle()
			{
				FlxG.switchState(TitleState.new);
		        super.update(elapsed);
			}*/

			
			// Lily, if you're reading this, copy this to the mobile branch, thanks! - SyncGit12
			/*#if mobile
			final file:String = FileSystem.readDirectory('./')[0];
			#else
			final file:String = haxe.io.Path.join(['Paths.video', FileSystem.readDirectory('Paths.video')[0]]);
			#end*/
	
			trace('This might not work! YAY :DDDDD');
	
			if (file != null && file.length > 0)
				video.load(file);
			else
			{		
				return;
			}
	
			/*
			if (callback != null)
				vidSprite.finishCallback = callback;
			else{
				vidSprite.finishCallback = function()
				{
					startAndEnd();
					if (heyStopTrying) openfl.system.System.exit(0);
					return;
				}
			}
			*/
	
			add(vidSprite);
	
			#else
			vidSprite.load(filepath);
			if (callback != null)
				return; // Might crash the game btw
			else{
				return; // Might crash the game btw
			}
			#end
			#else
			FlxG.log.warn('Platform not supported!');
			if (callback != null)
				return; // Might crash the game btw
			else
				return; // Might crash the game btw
			return;
			#end
		}

	override public function create():Void
	{
		#if VIDEOS_ALLOWED maxIntros += 2; #end
		if (date.getMonth() == 11 && date.getDate() >= 16 && date.getDate() <= 31) //Only triggers if the date is between 12/16 and 12/31
		{
			canChristmas = true;
			maxIntros += 1; //JOLLY SANTA!!!
		}

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		logo = new FlxSprite().loadGraphic(Paths.image('sillyLogo', 'splash'));
		logo.scrollFactor.set();
		logo.screenCenter();
		logo.alpha = 0;
		logo.active = true;
		add(logo);

		skipTxt = new FlxText(0, FlxG.height, 0, 'Press ENTER To Skip', 16);
		skipTxt.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		skipTxt.borderSize = 1.5;
		skipTxt.antialiasing = true;
		skipTxt.scrollFactor.set();
		skipTxt.alpha = 0;
		skipTxt.y -= skipTxt.textField.textHeight;
		add(skipTxt);

		FlxTween.tween(skipTxt, {alpha: 1}, 1);

		new FlxTimer().start(0.1, function(tmr:FlxTimer) {
			doIntro();
		});

		super.create();
	}

	function onIntroDone(?fadeDelay:Float = 0) {
		FlxTween.tween(logo, {alpha: 0}, 1, {
			startDelay: fadeDelay,
			ease: FlxEase.linear,
			onComplete: function(_) {
				FlxG.switchState(TitleState.new);
			}
		});
	}

	function doIntro() {
		/*
		#if debug // for testing purposes
			final vidSprite = new MP4Handler(); // it plays but it doesn't show???
			#if (hxCodec < "3.0.0")
			vidSprite.playVideo(Paths.video('broCopiedDenpa', 'splash'), false, false);
			vidSprite.finishCallback = function()
			{
				try { vidSprite.dispose(); }
				catch (e) {}
				FlxG.switchState(TitleState.new);
			};
			#else
			vidSprite.play(Paths.video('broCopiedDenpa', 'splash'));
			vidSprite.onEndReached.add(function(){
				vidSprite.dispose();
				FlxG.switchState(TitleState.new);
			});
			#end
		#else
		*/
		final theIntro:Int = FlxG.random.int(0, maxIntros);
		switch (theIntro) {
			case 0:
				FlxG.sound.play(Paths.sound('startup', 'splash'));
				logo.scale.set(0.1,0.1);
				logo.updateHitbox();
				logo.screenCenter();
				FlxTween.tween(logo, {alpha: 1, "scale.x": 1, "scale.y": 1}, 0.95, {ease: FlxEase.expoOut, onComplete: _ -> onIntroDone()});
			case 1:
				FlxG.sound.play(Paths.sound('startup', 'splash'));
				FlxG.sound.play(Paths.sound('FIREINTHEHOLE', 'splash'));
				logo.loadGraphic(Paths.image('lobotomy', 'splash'));
				logo.scale.set(0.1,0.1);
				logo.updateHitbox();
				logo.screenCenter();
				FlxTween.tween(logo, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.35, {ease: FlxEase.expoOut, onComplete: _ -> onIntroDone()});
			case 2:
				FlxG.sound.play(Paths.sound('screwedEngine', 'splash'));
				logo.loadGraphic(Paths.image('ScrewedLogo', 'splash'));
				logo.scale.set(0.1,0.1);
				logo.updateHitbox();
				logo.screenCenter();
				FlxTween.tween(logo, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.35, {ease: FlxEase.expoOut, onComplete: _ -> onIntroDone(0.6)});
			case 3:
				// secret muaahahhahhahaahha
				FlxG.sound.play(Paths.sound('tada', 'splash'));
				logo.loadGraphic(Paths.image('JavaScriptLogo', 'splash'));
				logo.scale.set(0.1,0.1);
				logo.updateHitbox();
				logo.screenCenter();
				FlxTween.tween(logo, {alpha: 1, "scale.x": 1, "scale.y": 1}, 1.35, {ease: FlxEase.expoOut, onComplete: _ -> onIntroDone(0.6)});
			case 4:
				#if VIDEOS_ALLOWED
					var vidSprite = new FlxVideoSprite(); // it plays but it doesn't show??
					vidSprite.load(Paths.video('bambiStartup', 'splash'));
					vidSprite.finishCallback = function()
					{
						try { vidSprite.dispose(); }
						catch (e) {}
						FlxG.switchState(TitleState.new);
					};
					#else
					vidSprite.load(Paths.video('bambiStartup', 'splash'));
					vidSprite.onEndReached.add(function(){
						vidSprite.dispose();
						FlxG.switchState(TitleState.new);
					});
					#end
				#end
			case 5:
				#if VIDEOS_ALLOWED
					var vidSprite = new MP4Handler(); // it plays but it doesn't show???
					#if (hxCodec < "3.0.0")
					var vidSprite = new FlxVideoSprite(); // it plays but it doesn't show??
					vidSprite.load(Paths.video('broCopiedDenpa', 'splash'));
					vidSprite.finishCallback = function()
					{
						try { vidSprite.dispose(); }
						catch (e) {}
						FlxG.switchState(TitleState.new);
					};
					#else
					vidSprite.load(Paths.video('broCopiedDenpa', 'splash'));
					vidSprite.onEndReached.add(function(){
						vidSprite.dispose();
						FlxG.switchState(TitleState.new);
					});
					#end
				#end
			case 6:
				if (canChristmas)
				{
					FlxG.sound.play(Paths.sound('JollySanta', 'splash'));
					logo.loadGraphic(Paths.image('JollySantaLogo', 'splash'));
					logo.scale.set(0.1,0.1);
					logo.updateHitbox();
					logo.screenCenter();
					FlxTween.tween(logo, {alpha: 1, "scale.x": 1, "scale.y": 1}, 2, {ease: FlxEase.expoOut, onComplete: _ -> onIntroDone(1.5)});
				} else doIntro();
		}
		// #end
	}

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER) FlxG.switchState(TitleState.new);
		super.update(elapsed);
	}
}