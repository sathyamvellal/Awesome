Awesome
=======

I use this share my awesome config file, rc.lua and the theme file theme.lua. 
The theme I currently use is the default theme

Requirements
============

1. wicked
2. vicious
3. blingbling

I use the above mentioned libraries to decorate my awesome

ArchLinux users can install vicious from the community repository
$ sudo pacman -S vicious

The other two can be installed via yaourt from the AUR
$ yaourt --noconfirm -S wicked-git blingbling-git


Installation
============

Make sure you have a separate configuration of your own in .config
If you don't, create one.
$ mkdir .config/awesome -p
$ cp /etc/xdg/awesome/rc.lua .config/awesome/
$ cp -r /usr/share/awesome/themes .config/awesome/

Next make sure you have wicked, vicious and blingbling libraries installed as per the requirements!
If you have a configuration set of your own, all you need to do is replace your rc.lua and theme.lua with mine. Make a backup of your original rc.lua and theme.lua files if you like.


Features
========

v3.1 changelog (initial release)
+ blue theme
+ two wiboxes, one at the top and one at the bottom
+ Bottom wibox contains awesome menu, desktop switcher window switcher, date and layout switcher
+ top wibox contains additional widgets mentioned below
+ battery percentage in text and coloured (0-25 red, 25-60 orange, 60-100 green)
+ battery meter
+ CPU meter with text and usage graph.
+ CPU core0 bar
+ CPU core1 bar
+ Memory usage with text and graph
+ rootfs usage with bar
+ homefs usage with bar
+ internet up/down rate
+ volume widget; mouse wheel adjustable, click to mute
