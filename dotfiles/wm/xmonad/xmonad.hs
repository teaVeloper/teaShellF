import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce
import XMonad.Hooks.SetWMName
import XMonad.ManageHook
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import Graphics.X11.ExtraTypes.XF86

import XMonad.Actions.CycleWS (nextScreen, shiftNextScreen, shiftPrevScreen)
main = xmonad $ def
    { terminal    = "kitty"
    , modMask     = mod4Mask -- Use Super instead of Alt
    , manageHook  = myManageHook <+> manageHook def
    , startupHook = myStartupHook
    , handleEventHook = docksEventHook
    } `additionalKeysP` myKeys


myStartupHook = do
    spawnOnce "~/.xmonad/screenlayout.sh" -- Set up monitors
    spawnOnce "feh --bg-scale /home/bertold/Pictures/vivek-kumar-JS_ohjocm00-unsplash.jpg" -- Set wallpaper
    spawnOnce "~/.config/polybar/launch.sh" -- Start Polybar
    spawnOnce "nm-applet &" -- Network manager applet
    spawnOnce "~/.config/polybar/launch.sh" -- Start Polybar
    setWMName "LG3D" -- Fix Java apps
    spawnOnce "firefox &" -- Start Firefox
    spawnOnce "thunderbird &" -- Start Thunderbird
    -- spawnOnce "teams &" -- Start MS Teams
    spawnOnce "spotify &" -- Start Spotify

myKeys =
    [ ("M-p", spawn "rofi -show drun") -- Application launcher
    , ("M-r", spawn "rofi -show drun") -- Application launcher
    , ("M-S-l", spawn "i3lock") -- Lock screen
    , ("M-<Return>", spawn "kitty") -- Open terminal
    , ("M-f", spawn "firefox") -- Open Firefox
    , ("M-e", spawn "thunderbird") -- Open Thunderbird
    , ("M-t", spawn "teams") -- Open MS Teams
    , ("M-s", spawn "spotify") -- Open Spotify
    , ("M-z", spawn "zotero") -- Open Zotero
    -- Multi-monitor management
    , ("M-w", nextScreen) -- Move focus to the next screen
    , ("M-S-w", shiftNextScreen) -- Move window to the next screen
    , ("M-S-<Left>", shiftPrevScreen) -- Move window to the previous screen
    , ("M-S-<Right>", shiftNextScreen) -- Move window to the next screen
    -- Multimedia keys
    , ("<XF86AudioPlay>", spawn "playerctl play-pause")
    , ("<XF86AudioNext>", spawn "playerctl next")
    , ("<XF86AudioPrev>", spawn "playerctl previous")
    , ("<XF86AudioStop>", spawn "playerctl stop")
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
    ]


myManageHook = composeAll
    [ title =? "Picture-in-Picture" --> doFloat
    , isDialog --> doFloat
    , manageDocks
    ]
