-- Standard awesome library

-- {{{ user added requires
require("wicked")
vicious = require("vicious")
require("blingbling")
-- }}}

require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")

-- {{{ user added font
awesome.font = "Inconsolata 10"
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end

do
    local cmds =
    {
	"xcfe4-panel"
    }

    for _,i in pairs(cmds) do
	awful.util.spawn(i)
    end
end

-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/sathyam/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvtc"
browser = "chromium"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "terminal", terminal },
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })
-- }}}

-- {{{ user added functions
function gradient(color, to_color, min, max, value)
    local function color2dec(c)
        return tonumber(c:sub(2,3),16), tonumber(c:sub(4,5),16), tonumber(c:sub(6,7),16)
    end

    local factor = 0
    if (value >= max ) then 
        factor = 1  
    elseif (value > min ) then 
        factor = (value - min) / (max - min)
    end 

    local red, green, blue = color2dec(color) 
    local to_red, to_green, to_blue = color2dec(to_color) 

    red   = red   + (factor * (to_red   - red))
    green = green + (factor * (to_green - green))
    blue  = blue  + (factor * (to_blue  - blue))

    -- dec2color
    return string.format("#%02x%02x%02x", red, green, blue)
end

function read_battery_life(number)
   return function(format)
             local fh = io.popen('acpi')
             local output = fh:read("*a")
             fh:close()

             count = 0
             for s in string.gmatch(output, "(%d+)%%") do
                if number == count then
                   return {s}
                end
                count = count + 1
             end
          end
end

function printf(ch)
    return function(format)
	    return ch
	  end
end

--- }}}

-- {{{ user added widget

sep = widget({
    type = 'textbox',
    name = 'sep'
})
wicked.register(sep, printf(' '), 
    ' <span> </span> ')

datewidget = widget({
    type = 'textbox',
    name = 'datewidget'
})
wicked.register(datewidget, wicked.widgets.date,
    ' <span color="white">  Date:</span> %c ')

--memwidget = widget({
--    type = 'textbox',
--    name = 'memwidget'
--})
--wicked.register(memwidget, wicked.widgets.mem,
--    ' <span color="white"> mem:</span> $1% ', nil, nil, {2, 4, 4})

--cpuwidget = widget({
--    type = 'textbox',
--    name = 'cpuwidget'
--})
--wicked.register(cpuwidget, wicked.widgets.cpu,
--    ' <span color="white"> CPU:</span> $1% ', nil, nil, {2})

--cpu0widget = widget({
--    type = 'textbox',
--    name = 'cpu0widget'
--})
--wicked.register(cpu0widget, wicked.widgets.cpu,
--    ' <span color="white"> cpu0:</span> $2% ', nil, nil, {2})

--cpu1widget = widget({
--    type = 'textbox',
--    name = 'cpu1widget'
--})
--wicked.register(cpu1widget, wicked.widgets.cpu,
--   ' <span color="white"> cpu1:</span> $3% ', nil, nil, {2})

--netwidget = widget({
--    type = 'textbox',
--    name = 'netwidget'
--})
--wicked.register(netwidget, wicked.widgets.net,
--    ' <span color="white"> Down:</span> ${wlan0 down} [${wlan0 rx}] <span color="white"> Up:</span> ${wlan0 up} [${wlan0 tx}]')

--battery = 0
--battwidget = widget({
--    type = 'textbox',
--    name = 'battwidget'
--})
--wicked.register(battwidget, read_battery_life(battery), ' <span color="white"> batt:</span> $1% ')

--batbarwidget = awful.widget.progressbar()
--batbarwidget:set_width(50)
--batbarwidget:set_height(18)
--batbarwidget:set_vertical(false)
--batbarwidget:set_background_color("#000000")
--batbarwidget:set_border_color("#FFFFFF")
----batbarwidget:set_color("#00FF00")
--batbarwidget:set_gradient_colors({"#FF0000", "#FFFF00", "#AFFF00", "#00FF00"})
--vicious.register(batbarwidget, vicious.widgets.bat, "$2", 5, "BAT0")

--cpubarwidget = awful.widget.progressbar()
--cpubarwidget:set_width(11)
--cpubarwidget:set_height(18)
--cpubarwidget:set_vertical(true)
--cpubarwidget:set_background_color("#000000")
--cpubarwidget:set_border_color("#FFFFFF")
--cpubarwidget:set_gradient_colors({"#00FF00", "#FFFF00","#FF0000"})
--vicious.register(cpubarwidget, vicious.widgets.cpu, "$1", 0.75)

--cpu0barwidget = awful.widget.progressbar()
--cpu0barwidget:set_width(11)
--cpu0barwidget:set_height(18)
--cpu0barwidget:set_vertical(true)
--cpu0barwidget:set_background_color("#000000")
--cpu0barwidget:set_border_color("#FFFFFF")
--cpu0barwidget:set_gradient_colors({"#00FF00", "#FFFF00","#FF0000"})
--vicious.register(cpu0barwidget, vicious.widgets.cpu, "$2", 0.75)

--cpu1barwidget = awful.widget.progressbar()
--cpu1barwidget:set_width(11)
--cpu1barwidget:set_height(18)
--cpu1barwidget:set_vertical(true)
--cpu1barwidget:set_background_color("#000000")
--cpu1barwidget:set_border_color("#FFFFFF")
--cpu1barwidget:set_gradient_colors({"#00FF00", "#FFFF00","#FF0000"})
--vicious.register(cpu1barwidget, vicious.widgets.cpu, "$2", 0.75)

--membarwidget = awful.widget.progressbar()
--membarwidget:set_width(50)
--membarwidget:set_height(18)
--membarwidget:set_vertical(false)
--membarwidget:set_background_color("#000000")
--membarwidget:set_border_color("#FFFFFF")
--membarwidget:set_gradient_colors({"#00FF00", "#FFFF00","#FF0000"})
--vicious.register(membarwidget, vicious.widgets.mem, "$1", 1)

-- }}}

--- {{{ blingbling widgets

--battbarwidget_root=blingbling.value_text_box.new()
--battbarwidget_root:set_height(18)
--battbarwidget_root:set_width(100)
--battbarwidget_root:set_v_margin(2)
--battbarwidget_root:set_filled(true)
--battbarwidget_root:set_filled_color("#000099")
--battbarwidget_root:set_values_text_color({{"#88aaff",0},{"#d4aaff", 0.5},{"#d455ff",0.75}})
--battbarwidget_root:set_default_text_color(beautiful.textbox_widget_as_label_font_color)
--battbarwidget_root:set_rounded_size(0.4)
--battbarwidget_root:set_background_color("#000044")
--battbarwidget_root:set_label("/root usage:$percent %")
--vicious.register(battbarwidget_root, vicious.widgets.fs, "${/ used_p}", 120)

cpulabel = widget({ type = 'textbox' })
cpulabel.text = ' CPU: '
cpugraph=blingbling.classical_graph.new()
cpugraph:set_height(18)
cpugraph:set_width(75)
cpugraph:set_tiles_color("#000022")
cpugraph:set_graph_color("#01A9DB")
cpugraph:set_graph_line_color("#0099FF")
cpugraph:set_show_text(true)
cpugraph:set_label(" $percent %")
blingbling.popups.htop(cpugraph.widget, {
	title_color = "#00DDFF", 
        user_color = "#FFFFFF", 
        root_color = "#CCCCCC", 
        terminal = "urxvt"})
vicious.register(cpugraph, vicious.widgets.cpu,'$1', 1)
core0label = widget({ type = 'textbox' })
core0label.text = ' C0: '
cpucore0=blingbling.progress_graph.new()
cpucore0:set_height(18)
cpucore0:set_width(10)
cpucore0:set_graph_color("#019ADB")
cpucore0:set_graph_line_color("#0099FF")
cpucore0:set_filled(true)
cpucore0:set_h_margin(1)
cpucore0:set_filled_color("#000000")
vicious.register(cpucore0, vicious.widgets.cpu, "$2")
core1label = widget({ type = 'textbox' })
core1label.text = ' C1: '
cpucore1=blingbling.progress_graph.new()
cpucore1:set_height(18)
cpucore1:set_width(10)
cpucore1:set_graph_color("#019ADB")
cpucore1:set_graph_line_color("#0099FF")
cpucore1:set_filled(true)
cpucore1:set_h_margin(1)
cpucore1:set_filled_color("#000000")
vicious.register(cpucore1, vicious.widgets.cpu, "$3")

memlabel = widget({ type = 'textbox' })
memlabel.text = 'MEM: '
memgraph=blingbling.classical_graph.new()
memgraph:set_height(18)
memgraph:set_width(75)
memgraph:set_tiles_color("#000022")
memgraph:set_graph_color("#01A9DB")
memgraph:set_graph_line_color("#0099FF")
memgraph:set_show_text(true)
memgraph:set_label(" $percent %")
blingbling.popups.htop(memgraph.widget, {
	title_color = "#00DDFF", 
        user_color = "#FFFFFF", 
        root_color = "#CCCCCC", 
        terminal = "urxvt"})
vicious.register(memgraph, vicious.widgets.mem,'$1', 2)

netlabel = widget({ type = "textbox", name = "netlabel" })
netlabel.text=' NET: '
blingbling.popups.netstat(netlabel, { 
    title_color = "#00DDFF",
    established_color = "#FFFFFF",
    listen_color = "#CCCCCC"
})
netwidget = blingbling.net.new()
netwidget:set_interface("wlan0")
netwidget:set_height(18)
netwidget:set_ippopup()
netwidget:set_graph_color("#019ADB")
netwidget:set_graph_line_color("#0099FF")
netwidget:set_show_text(true)
netwidget:set_font_size(12)
netwidget:set_v_margin(3)

volwidget = blingbling.volume.new()
volwidget:set_height(18)
volwidget:set_width(30)
volwidget:update_master()
volwidget:set_master_control()
volwidget:set_graph_color("#019ADB")
volwidget:set_bar(false)
--vicious.register(volwidget, volwidget:update_master(), nil)

battlabel = widget({ type = "textbox", name = "battlabel" })
battlabel.text = ' BATT:'
battbarwidget=blingbling.progress_bar.new()
battbarwidget:set_height(18)
battbarwidget:set_width(50)
battbarwidget:set_show_text(false)
battbarwidget:set_horizontal(true)
battbarwidget:set_background_color("#001122")
battbarwidget:set_graph_color("#019ADB")
vicious.register(battbarwidget, vicious.widgets.bat, "$2", 5, "BAT0")
batttextwidget = blingbling.value_text_box.new()
batttextwidget:set_height(18)
batttextwidget:set_width(20)
batttextwidget:set_label("$percent %")
batttextwidget:set_font_size(12)
batttextwidget:set_background_color("#000000")
batttextwidget:set_values_text_color({{"#FF0000",0},
				    {"#FAAF00", 0.25},
				    {"#00FF00",0.60}})
vicious.register(batttextwidget, vicious.widgets.bat, "$2", 5, "BAT0")

fsrootlabel = widget({ type = 'textbox' })
fsrootlabel.text = '   root: '
fsrootwidget = blingbling.progress_bar.new()
fsrootwidget:set_height(18)
fsrootwidget:set_width(50)
fsrootwidget:set_show_text(false)
fsrootwidget:set_horizontal(true)
fsrootwidget:set_show_text(true)
fsrootwidget:set_background_color("#001122")
fsrootwidget:set_graph_color("#019ADB")
vicious.register(fsrootwidget, vicious.widgets.fs, "${/ used_p}", 120)

fshomelabel = widget({ type = 'textbox' })
fshomelabel.text = ' home: '
fshomewidget = blingbling.progress_bar.new()
fshomewidget:set_height(18)
fshomewidget:set_width(50)
fshomewidget:set_show_text(false)
fshomewidget:set_horizontal(true)
fshomewidget:set_show_text(true)
fshomewidget:set_background_color("#001122")
fshomewidget:set_graph_color("#019ADB")
vicious.register(fshomewidget, vicious.widgets.fs, "${/home used_p}", 120)

udisks_glue=blingbling.udisks_glue.new(beautiful.dialog_ok)
udisks_glue:set_mount_icon(beautiful.dialog_ok)
udisks_glue:set_umount_icon(beautiful.dialog_cancel)
udisks_glue:set_detach_icon(beautiful.dialog_cancel)
udisks_glue:set_Usb_icon(beautiful.usb_iconn)
udisks_glue:set_Cdrom_icon(beautiful.cdrom_icon)

reboot=blingbling.system.rebootmenu(beautiful.reboot, beautiful.dialog_ok, beautiful.dialog_cancel)

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
newwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({
	position = "bottom",
	screen = s,
	border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	fg = beautiful.fg_normal,
	bg = beautiful.bg_normal,
	opacity = theme.opacity
    })
    newwibox[s] = awful.wibox({
	position = "top",
	screen = s,
	border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	fg = beautiful.fg_normal,
	bg = beautiful.bg_normal,
	opacity = theme.opacity
    })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
	datewidget,
        --mytextclock,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
    newwibox[s].widgets = {
	--widgetlist
	{
	    battlabel,
	    batttextwidget,
	    battbarwidget,
	    cpulabel,
	    cpugraph,
	    core0label,
	    cpucore0,
	    core1label,
	    cpucore1,
	    sep,
	    memlabel,
	    memgraph,
	    fsrootlabel,
	    fsrootwidget,
	    fshomelabel,
	    fshomewidget,
	    --battbarwidget_root.widget,
	    layout = awful.widget.layout.horizontal.leftright
	},
	volwidget.widget,
	sep, sep,
	netwidget.widget,
	netlabel,
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "t",      function () awful.util.spawn("konsole") end),
    awful.key({ modkey,           }, "c",      function () awful.util.spawn("chromium") end),
    awful.key({ modkey,           }, "v",      function () awful.util.spawn("vim -g") end),
    awful.key({ modkey,           }, "e",      function () awful.util.spawn("eclipse") end),
    awful.key({ }, "XF86AudioRaiseVolume",    function () awful.util.spawn("amixer set Master playback 1+") end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
		     size_hints_honor = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
