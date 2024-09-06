1.33.1;

Fixed the game not creating a crash log on ANY crash for some users (thank you moxie)

1.33.0;

Note Skipping has been added! (i asked HRK_EXEX before adding this and he gave me permission to add it, and he has been given credit for said feature)
The Achievements menu has been updated to the one seen in Psych Engine 0.7.3
ACHIEVEMENTS OVERHAULED (and you can now actually add softcoded achievements!! check out the JS Engine GitHub wiki for more info)
Game should no longer endlessly get stuck in a vocal resync loop if the Voices file(s) are shorter than the instrumental
Show Debug Info was renamed to "Info Shown:" and 'Show Rendering Time Remaining' has been merged with it
Show MS has been moved to the Optimization menu
(!) Show Ratings & Combo has been split into 2 options. If you find that rating sprites are spawning again, that's why.
Removed the health tween when a song starts (it's cool but people don't need that)
Removed 3 options due to being recreatable in LUA
Note Splashes no longer keep using their shader if you turn off the Enable Color Shader option (should fix the Black Splashes issue)
Fixed notes stretching in EditorPlayState and strums not being colored properly
Fixed the Blocked Glitch Shader not moving if you used it
Tried to fix the game not making a crash log on ANY crash for some users