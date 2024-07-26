@echo off
color 0a
cd ..
@echo on
echo Installing dependencies...
echo This might take a few moments depending on your internet speed.
haxelib install lime
haxelib install openfl
haxelib install flixel 5.6.2
haxelib install flixel-addons 3.2.2
haxelib install flixel-tools 1.5.1
haxelib install flixel-ui
haxelib install hxCodec 2.5.1
haxelib install hscript
haxelib install hxcpp
haxelib install hxcpp-debug-server
haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit master
haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc
echo Finished!
pause
