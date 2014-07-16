-- Themed by Sathyam Vellal <http://sathyamvellal.in>

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Other libraries
local vicious = require("vicious")
local blingbling = require("blingbling")

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
awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                       title = "Oops, an error happened!",
                       text = err })
        in_error = false
        end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/sathyam/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
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

-- {{{ Wallpaper
if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, layouts[1])
  end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
{ "manual", terminal .. " -e man awesome" },
{ "edit config", editor_cmd .. " " .. awesome.conffile },
{ "restart", awesome.restart },
{ "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                        { "open terminal", terminal }
                      }
                      })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                   menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Custom Widgets

sep2 = wibox.widget.textbox('  ')

-- cpu0label = wibox.widget.textbox(' C0:')
-- cpu1label = wibox.widget.textbox(' C1:')
-- cpu2label = wibox.widget.textbox(' C2:')
-- cpu3label = wibox.widget.textbox(' C3:')
-- cpu0graph = blingbling.progress_graph.new({height = 18, width = 12, rounded_size = 0.3})
-- cpu1graph = blingbling.progress_graph.new({height = 18, width = 12, rounded_size = 0.3})
-- cpu2graph = blingbling.progress_graph.new({height = 18, width = 12, rounded_size = 0.3})
-- cpu3graph = blingbling.progress_graph.new({height = 18, width = 12, rounded_size = 0.3})
-- vicious.register(cpu0graph, vicious.widgets.cpu,'$2', 2)
-- vicious.register(cpu1graph, vicious.widgets.cpu,'$3', 2)
-- vicious.register(cpu2graph, vicious.widgets.cpu,'$4', 2)
-- vicious.register(cpu3graph, vicious.widgets.cpu,'$5', 2)

-- netwidget = blingbling.net({interface = "wlp2s0", show_text = true, font_size = 13})
-- netwidget:set_ippopup()

-- volume_master = blingbling.volume({height = 18, width = 40, bar =true, font_size = 13, show_text = true, label ="$percent%"})
-- volume_master:update_master()
-- volume_master:set_master_control()

batwidget=blingbling.value_text_box({height = 18, width = 40, font_size = 13, v_margin = 4})
batwidget:set_height(16)
batwidget:set_width(40)
batwidget:set_v_margin(2)
batwidget:set_values_text_color({{"#ff0000",0},
                                {"#ffff00", 0.25},
                                {"#00ff00",0.60}})
batwidget:set_text_color(beautiful.textbox_widget_as_label_font_color)
batwidget:set_rounded_size(0.4)
batwidget:set_label("Batt: $percent")
vicious.register(batwidget, vicious.widgets.bat, "$2", 5, "BAT0")

function split(pString, pPattern)
   local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pPattern
   local last_end = 1
   local s, e, cap = pString:find(fpat, 1)
   while s do
    if s ~= 1 or cap ~= "" then
     table.insert(Table,cap)
   end
   last_end = e+1
   s, e, cap = pString:find(fpat, last_end)
 end
 if last_end <= #pString then
 cap = pString:sub(last_end)
 table.insert(Table, cap)
end
return Table
end

--function read_batt_status()
-- 	local fh = io.popen('acpi')
--	local output = fh:read("*a")
--	fh:close()
--	
--	for s in string.gmatch(output, "(%d+)%%") do
--		i = tonumber(s)
--		if i < 25 then
--			awful.util.spawn("notify-send -u critical -t 4999 'Battery Low' 'Plugin charger now. Battery is low!'")
--		end
--	end
--
--	for s in string.gmatch(output, "%%,?.*") do
--		return s
--	end
--end

--batremwidget=blingbling.value_text_box({height = 18, width = 40, font_size = 13, v_margin = 4})
--batremwidget:set_height(16)
--batremwidget:set_width(40)
--batremwidget:set_v_margin(2)
-- batremwidget:set_values_text_color({{"#ff0000",0},
--								 {"#ffff00", 0.25},
--                                 {"#00ff00",0.60}})
--batremwidget:set_text_color(beautiful.textbox_widget_as_label_font_color)
--batremwidget:set_rounded_size(0.4)
--batremwidget:set_label("|    $percent ")
--vicious.register(batremwidget, read_batt_status(),"$1", 2)

batremwidget = wibox.widget.textbox()
batremtimer = timer({timeout=5})
--batremtimer:connect_signal("timeout", function() batremwidget:set_text(read_batt_status()) end)
--batremtimer:start()

local awesompd = require("awesompd/awesompd")
musicwidget = awesompd:create() -- Create awesompd widget
musicwidget.font = "Inconsolata" -- Set widget font 
musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
musicwidget.output_size = 30 -- Set the size of widget in symbols
musicwidget.update_interval = 1 -- Set the update interval in seconds
-- Set the folder where icons are located (change username to your login name)
musicwidget.path_to_icons = "/home/sathyam/.config/awesome/awesompd/icons" 
-- Set the default music format for Jamendo streams. You can change
-- this option on the fly in awesompd itself.
-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
musicwidget.jamendo_format = awesompd.FORMAT_MP3
-- If true, song notifications for Jamendo tracks and local tracks will also contain
-- album cover image.
musicwidget.show_album_cover = true
-- Specify how big in pixels should an album cover be. Maximum value
-- is 100.
musicwidget.album_cover_size = 50
-- This option is necessary if you want the album covers to be shown
-- for your local tracks.
musicwidget.mpd_config = "/home/sathyam/.mpdconf"
-- Specify the browser you use so awesompd can open links from
-- Jamendo in it.
musicwidget.browser = "google-chrome"
-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.
musicwidget.ldecorator = " "
musicwidget.rdecorator = " "
-- Set all the servers to work with (here can be any servers you use)
musicwidget.servers = { { server = "localhost",
                          port = 6600 } }
-- Set the buttons of the widget
musicwidget:register_buttons({ { "", awesompd.MOUSE_LEFT, musicwidget:command_toggle() },
                               { "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_prev_track() },
                               { "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_next_track() },
                               { "", awesompd.MOUSE_SCROLL_UP, musicwidget:command_volume_up() },
                               { "", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_volume_down() },
                               { "", awesompd.MOUSE_RIGHT, musicwidget:command_show_menu() },
                               { "", "XF86AudioLowerVolume", musicwidget:command_volume_down() },
                               { "", "XF86AudioRaiseVolume", musicwidget:command_volume_up() },
                               { modkey, "Pause", musicwidget:command_playpause() } })
  musicwidget:run() -- After all configuration is done, run the widget

-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

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
                                          awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                                          awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                                          )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                                           awful.button({ }, 1, function (c)
                                                        if c == client.focus then
                                                          c.minimized = true
                                                        else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons, {bg_focus = beautiful.bg_focus,
                                        bg_normal = beautiful.bg_normal,
                                        bg_urgent = beautiful.bg_urgent,
                                        bg_minimize = beautiful.bg_minimize })
    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons, {bg_focus = beautiful.bg_focus, 
                                          bg_normal = beautiful.bg_normal,
                                          bg_urgent = beautiful.bg_urgent,
                                          bg_minimize = beautiful.bg_minimize })
    -- Create the wibox
    mywibox[s] = awful.wibox({	position = "bottom",
                             screen = s,
                             border_width = beautiful.border_width,
                             border_color = beautiful.border_normal,
                             fg = beautiful.fg_normal,
                             bg = beautiful.bg_normal,
                             opacity = 0.8 })

    newwibox[s] = awful.wibox({ position = "top",
                              screen =s,
                              border_width = beautiful.border_width,
                              border_color = beautiful.border_normal,
                              fg = beautiful.fg_normal,
                              bg = beautiful.bg_normal,
                              opacity = 0.8 })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    local new_left_layout = wibox.layout.fixed.horizontal()
    new_left_layout:add(batwidget)
    new_left_layout:add(batremwidget)
    new_left_layout:add(sep2)
    -- new_left_layout:add(cpu0label)
    -- new_left_layout:add(cpu0graph)
    -- new_left_layout:add(cpu1label)
    -- new_left_layout:add(cpu1graph)
    -- new_left_layout:add(cpu2label)
    -- new_left_layout:add(cpu2graph)
    -- new_left_layout:add(cpu3label)
    -- new_left_layout:add(cpu3graph)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    local new_right_layout = wibox.layout.fixed.horizontal()
    new_right_layout:add(musicwidget.widget)
    -- new_right_layout:add(netwidget)
    new_right_layout:add(sep2)
    new_right_layout:add(sep2)
--    new_right_layout:add(volume_master)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    local new_layout = wibox.layout.align.horizontal()
    new_layout:set_left(new_left_layout)
    new_layout:set_right(new_right_layout)

    mywibox[s]:set_widget(layout)
    newwibox[s]:set_widget(new_layout)
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
                                   awful.key({ }, "XF86MonBrightnessUp", function() awful.util.spawn("xbacklight -inc 8") end),
                                   awful.key({ }, "XF86MonBrightnessDown", function() awful.util.spawn("xbacklight -dec 13") end),
    --awful.key({ }, "XF86MonRaiseVolume", function() awful.util.spawn("amixer set Master 5%+") end),
    --awful.key({ }, "XF86MonLowerVolume", function() awful.util.spawn("amxier set Master 5%-") end),
    awful.key({ modkey			  }, "c", function() awful.util.spawn("google-chrome") end),
    awful.key({ modkey			  }, "e", function() awful.util.spawn("eclipse") end),
    awful.key({ modkey			  }, "v", function() awful.util.spawn("gvim") end),
    awful.key({ modkey			  }, "a", function() awful.util.spawn("adt") end),
    awful.key({ modkey			  }, "s", function() awful.util.spawn("subl") end),
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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),

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
                end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
    )

clientkeys = awful.util.table.join(
                                   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
                                   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
                                   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
                                   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
                                   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
                                   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
                                   awful.key({ modkey, "Shift"   }, "t",      function (c) c.sticky = not c.sticky            end),
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

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = awful.util.table.join(globalkeys,
                                     awful.key({ modkey }, "#" .. i + 9,
                                               function ()
                                                local screen = mouse.screen
                                                local tag = awful.tag.gettags(screen)[i]
                                                if tag then
                                                 awful.tag.viewonly(tag)
                                               end
                                               end),
                                     awful.key({ modkey, "Control" }, "#" .. i + 9,
                                               function ()
                                                local screen = mouse.screen
                                                local tag = awful.tag.gettags(screen)[i]
                                                if tag then
                                                 awful.tag.viewtoggle(tag)
                                               end
                                               end),
                                     awful.key({ modkey, "Shift" }, "#" .. i + 9,
                                               function ()
                                                local tag = awful.tag.gettags(client.focus.screen)[i]
                                                if client.focus and tag then
                                                  awful.client.movetotag(tag)
                                                end
                                                end),
                                     awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                                               function ()
                                                local tag = awful.tag.gettags(client.focus.screen)[i]
                                                if client.focus and tag then
                                                  awful.client.toggletag(tag)
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
    focus = awful.client.focus.filter,
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
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
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

      local titlebars_enabled = false
      if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                                              awful.button({ }, 1, function()
                                                           client.focus = c
                                                           c:raise()
                                                           awful.mouse.client.move(c)
                                                           end),
                                              awful.button({ }, 3, function()
                                                           client.focus = c
                                                           c:raise()
                                                           awful.mouse.client.resize(c)
                                                           end)
                                              )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)
        
        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
      end
      end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
