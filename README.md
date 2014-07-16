Bluesome v2.0
=============

My customization and configuration files for Awesome, ArchLinux.

+ X Window system configuration => .Xresources
+ Fonts used => Consolas and Inconsolata
+ awesome config directory => .config/awesome
+ awesome theme used => default theme (tweaked)

Requirements
============

1. rxvt-unicode
2. wicked
3. vicious
4. blingbling-git
5. awesompd

I use the above mentioned libraries to decorate my awesome
ArchLinux users can install vicious and urxvt from the community repository

$ sudo pacman -S vicious rxvt-unicode

The other two can be installed via yaourt from the AUR

$ yaourt --noconfirm -S wicked-git blingbling-git


Configuring and Customizing
===========================

Make sure you have a separate configuration of your own in .config directory
If you don't, create one.

$ mkdir .config/awesome -p

$ cp /etc/xdg/awesome/rc.lua .config/awesome/

$ cp -r /usr/share/awesome/themes .config/awesome/

Copy the fonts (Consolas and Inconsolata) to .fonts directory in your home. If you don't have .fonts, create one.
Now copy the .Xresources file to your home. To use the .Xresources, add this to your .xinitrc at home: 
xrdb -merge ~/.Xresources

Next make sure you have wicked, vicious, blingbling libraries and urxvt installed as per the requirements!
Replace your rc.lua and theme.lua with mine. Make a backup of your original rc.lua and theme.lua files if you like.

Features
========

v2.0 changelog - Bluesome
+ ported to new Lua5.2
+ tweaked upper status bar
+ more blue colors added

v1.2 changelog - Awesome Blue
+ Shows charging/discharging state (Red 0 for discharging and green 1 for charging)
+ Added calendar widget
+ Added udisks-glue widget. Uses udisks for automounting
+ Added icons for use with widgets (themes/default/icons/)

v1.1 changelog
+ blue theme
+ two wiboxes, one at the top and one at the bottom
+ Bottom wibox contains awesome menu, desktop switcher window switcher, date and layout switcher
+ top wibox contains additional widgets mentioned below
+ battery percentage in text and coloured (0-25 red, 25-60 orange, 60-100 green)
+ battery meter
+ CPU meter with text and usage graph.
+ CPU core0 bar
+ CPU core1 bar 
+ popup for CPU meter showing "top" when mouse is over the CPU meter
+ Memory usage with text and graph
+ popup for Mem graph showing "top" when mouse is over the Mem graph
+ rootfs usage with bar
+ homefs usage with bar
+ internet up/down rate
+ popup of few internet details when mouse is over 'NET:' word and network widget
+ volume widget; mouse wheel adjustable, click to mute

v1.0 changelog (initial release)
+ using default theme

Screenshots
===========

http://dl.dropbox.com/u/30013949/awesome.png
