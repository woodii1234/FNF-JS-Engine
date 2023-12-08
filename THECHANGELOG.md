1.16.0;

Added back Chart Drawing for the OS 'Engine' fans who like charting that way, along with a delete mode if you hold CTRL
Added character-specific noteskins (WIP, put them in assets/images/noteskins)
All rating types now have pixelated sprites
Added Anti-Crash for the Chart Editor and Character Editor
You can now go past the normal max health, granted you actually figure out how
You can now set if a note bypasses the health limit
You can now have the icons bop every time a note is hit
Optimized some stuff
Improved loading time with Extra Keys Lua songs
Char-Based note colors, Quantized Note Colors and Rainbow Notes now have pixelated assets
Troll Mode now supports Events
The results screen's background color now changes depending on how you played
The credits popup now displays the note count for both sides in a song IF the Rating Counter is turned off
The scoreTxt now shows your maximum NPS in a song!
GPU Caching is no longer forced on?? (Another user reported that)
Removed the Memory Leaks option
Fixed a bug where the Copy Section Loop stepper wouldn't block BACKSPACE presses
Fixed 3 bugs when playing as the opponent:
- icons are no longer incorrectly positioned
- the health bar is no longer just 1 color
- fixed char-based note colors applying to the wrong side
Fixed a bug where having the results screen turned on would cause the first song to loop infinitely
Fixed Char-Based note colors crashing if there's a GF note and GF is hidden
Fixed Double Note Ghosts crashing when triggered with GF notes if GF is hidden