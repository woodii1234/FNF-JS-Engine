1.32.2;

Fixed Splash Skin defaulting to "Psych Engine" (an option that has been removed)

1.32.1;

The Startup screen is now toggleable
Added Classic Notesplashes (to match with the Classic Noteskin)
Added legacy Hurt Notes as a fallback to fix a crash that would occur if you turned off "Enable Color Shader" and added a Hurt Note
Reverted the Playable Character system as it made it harder to make playable characters
Fixed a ton of bugs

Note Color menu-specific:
The engine will now actively refuse to load Pixel Note sprites if the engine can't find any for your specific noteskin.
The RGB shaders now actually update according to whether or not you're in Pixel Mode

1.32.0;

Removed the Results Screen (Unused and broken in the latest versions.)

(!) The Note Color System has been upgraded to the 0.7.X system!! (YOU WILL NEED TO ENTER THE VISUALS & UI MENU TO RESET YOUR NOTESKIN AND SPLASH SKINS TO DEFAULT AS MOST OF THE OPTIONS YOU ALREADY USE HAVE BEEN REMOVED!) this will slow down rendering speeds a bit. however if you don't want to use the RGB Shaders the Classic noteskin is also available!

(almost) All of the num1 sprites (and their pixel variants) have been updated to their 0.3.X version
Botplay is now automatically enabled if you turn on Rendering Mode
Fixed a possible issue where if you went into another state or paused the game immediately after a big lag spike, a resync would trigger forcing the song to keep playing anyway (However an oversight from this is you have to wait slightly longer when unpausing before a song actually starts playing again. I will try to fix this in the future!)
Fixed Blammed Erect having the incorrect events
Fixed bf-christmas having funky offsets for the Left & Down animations
Fixed texts made using LUA going to camGame
Fixed vocal resync not working in EditorPlayState

Important note about the RGB shader colors: IF YOUR CHARACTER HAS A SPECIFIC NOTESKIN ATTACHED TO IT, THAT NOTESKIN WILL NOT BE AFFECTED BY THE RGB COLORS