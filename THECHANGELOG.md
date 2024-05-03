1.25.0;

The Chart Editor music RETURNS, and is now toggleable!
Added options that display your combo, and the Botplay watermark
Added an option that allows you to change the encoder that Rendering Mode uses. Every encoder has a difference like speed, quality etc.
Removed Rendering Mode from macOS builds because FFmpeg for macOS doesn't exist.
Fixed note splashes being affected by note colors regardless of whether or not you actually had the color shader turned on
Fixed an issue where if you changed your noteskin to Default when using another noteskin then the notes would use the same noteskin you used before
Fixed some notes having off angles
Fixed character-based colors not working
Fixed Camera Twisting being awkward if you put higher gfSpeeds
Fixed camera shaders stacking on top of each other
Fixed an issue where if you only changed the notes' texture property but not the noteskin property then the note's texture would reset to the default, and vice versa
Fixed a bug where turning on botplay but turning off "Even LESS Botplay Lag" wouldn't make the NPS increase on note hit regardless of whether or not you actually had "Show NPS" turned on