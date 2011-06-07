 --
 -- Xmonad configuration file
 -- Features:
 --  (*) gnome integration
 --  (*) Multiple workspaces, per-workspace layouts
 --  (*) xmobad + dzen2 for selecting applications to launch
 --  (*) IM layout for skype and pidgin
 --  (*) popup windows for stardict, irssi and terminal

 import XMonad hiding ((|||))
 import XMonad.Operations
 import System.Exit
 import Graphics.X11
 import System.IO 
 
 import qualified XMonad.StackSet as W
 import qualified Data.Map        as M
 
 import XMonad.Hooks.DynamicLog
 import XMonad.Layout.Tabbed
 import XMonad.Layout.NoBorders
 import XMonad.Hooks.ManageDocks
 import XMonad.ManageHook
 import XMonad.Hooks.ManageHelpers
 import XMonad.Actions.CycleWS --(nextWS, prevWS, shiftToNext, shiftToPrev, nextScreen, prevScreen, shiftNextScreen, shiftPrevScreen, toggleWS)
 import XMonad.Actions.PerWorkspaceKeys
 import XMonad.Actions.RotSlaves
 import XMonad.Actions.GridSelect

 import XMonad.Layout.ToggleLayouts
 import XMonad.Layout.IM
 import XMonad.Layout.Grid
 import XMonad.Layout.CenteredMaster
 import XMonad.Layout.Cross
 import XMonad.Layout.Circle
 import XMonad.Layout.Master
 import XMonad.Layout.NoBorders
 import XMonad.Layout.SimpleDecoration
 import XMonad.Layout.NoFrillsDecoration
 import XMonad.Layout.FixedColumn
 import XMonad.Layout.Reflect
 import XMonad.Layout.PerWorkspace
 import XMonad.Layout.Dishes
 import XMonad.Layout.LimitWindows
 import XMonad.Layout.SimpleFloat
 import XMonad.Layout.StackTile
 import XMonad.Util.NamedScratchpad

 
 import XMonad.Layout.LayoutCombinators ((|||))
 import XMonad.Util.Run (spawnPipe)
 import XMonad.Config.Gnome
 import XMonad.Config.Desktop
 import Data.Ratio ((%)) 
 

 ------------------------------------------------------------------------
 -- Common variables
 --
 myTerminal      = "urxvtc"
 myBorderWidth   = 1
 myModMask       = mod4Mask
 myNumlockMask   = mod2Mask
 myWorkspaces    = ["terms","www","emacs","gtd","doc","vm","7","8","im" ]
 myNormalBorderColor  = "#657b83"
 myFocusedBorderColor = "#859900"
 myNormalBg =  "#002b36"
 myNormalFg =  "#657b83"
 myFocusedBg = "#073642"
 myFocusedFg = "#cb4b16"
 myFont = "-*-terminus-*-*-*-*-*-*-*-*-*-*-*-*"

 menuCmd = "dmenu -fn '" ++ myFont ++ "' -nb '" ++ myNormalBg ++ "' -nf '" ++ myNormalFg ++ "' -sb '" ++ myFocusedBg ++ "' -sf '" ++ myFocusedFg ++ "'"
 dzen2 = "dzen2 -p -h 14 -ta l -bg '" ++ myNormalBg ++ "' -fg '" ++ myNormalFg ++ "' -w 600 -sa c -fn '" ++ myFont ++ "'"
 myExtraTerm =  "xterm -bg \"" ++ myNormalBg ++ "\" -fg \"" ++ myNormalFg ++ "\""

 myTabConfig = defaultTheme {
    activeColor = myFocusedBg
   ,activeTextColor = myFocusedFg
   ,inactiveColor = myNormalBg
   ,inactiveTextColor = myNormalFg
 }

 -----------------
 -- Popop terminal(xterm), irc(irssi) and dictionary(stardict) windows
 --
 scratchpads = [ NS "terminal" spawnTerminal findTerminal manageTerminal 
               , NS "dictionary" spawnDict findDict manageDict
               , NS "irc" spawnIRC findIRC manageIRC
               ]
   where
     spawnTerminal =  myExtraTerm ++ " -title \"spawnterm\""
     findTerminal  = title =? "spawnterm"
     manageTerminal = customFloating $ W.RationalRect l t w h
       where
         h = 0.5
         w = 1.0
         t = 0
         l = (1 - w)/2 -- centered left/right


     spawnDict  = "stardict"
     findDict   = className =? "Stardict"
     manageDict = customFloating $ W.RationalRect l t w h
       where
         h = 0.6
         w = 0.6
         t = (1 - h)/2
         l = (1 - w)/2

     spawnIRC  = myExtraTerm ++ " -title \"irssi\" -e irssi"
     findIRC   = title =? "irssi"
     manageIRC = customFloating $ W.RationalRect l t w h
       where
         h = 0.8
         w = 0.8
         t = (1 - h)/2
         l = (1 - w)/2

 ------------------------------------------------------------------------
 -- Key bindings. Add, modify or remove key bindings here.
 --
 myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
     [ ((modMask,               xK_q     ), kill)
     -- select and run application using dmenu
     , ((modMask,               xK_r     ), spawn ("exec `dmenu_path | " ++ menuCmd ++ "`"))
     , ((modMask .|. shiftMask, xK_a     ), spawn "urxvtc")
     -- popup terminal
     , ((modMask .|. shiftMask, xK_t     ), namedScratchpadAction scratchpads "terminal")
     -- popup dictionary
     , ((modMask .|. shiftMask, xK_d     ), namedScratchpadAction scratchpads "dictionary")
     -- popup irc
     , ((modMask .|. shiftMask, xK_s     ), namedScratchpadAction scratchpads "irc")
     , ((modMask,               xK_space ), sendMessage NextLayout)
     , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
     -- toggle to fullscreen
     , ((modMask,               xK_f     ), sendMessage ToggleLayout)
     , ((modMask,               xK_n     ), refresh)
     , ((modMask,               xK_Tab   ), windows W.focusDown)
     , ((modMask,               xK_u     ), windows W.focusDown)
     , ((modMask,               xK_d     ), windows W.focusUp  )
     , ((modMask,               xK_m     ), windows W.focusMaster  )
     , ((modMask,               xK_Return), windows W.swapMaster)
     , ((modMask .|. shiftMask, xK_k     ), windows W.swapDown  )
     , ((modMask .|. shiftMask, xK_j     ), windows W.swapUp    )
     , ((modMask,               xK_h     ), sendMessage Shrink)
     , ((modMask,               xK_l     ), sendMessage Expand)
     , ((modMask,               xK_t     ), withFocused $ windows . W.sink)
     , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))
     , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))
     , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
     -- quickly switch between windows
     , ((modMask .|. shiftMask, xK_w     ), goToSelected defaultGSConfig)
     , ((modMask .|. shiftMask, xK_r     ),
           broadcastMessage ReleaseResources >> restart "xmonad" True)
     ]
   
     ++

     --
     -- mod-[1..9], Switch to workspace N
     -- mod-shift-[1..9], Move client to workspace N
     --
     [((m .|. modMask, k), windows $ f i)
         | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
         , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
     
    ++

    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
          | (key, sc) <- zip [xK_o, xK_p, xK_i] [0..]
          , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


 ------------------------------------------------------------------------
 -- Mouse bindings: default actions bound to mouse events
 --
 myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

     -- mod-button1, Set the window to floating mode and move by dragging
     [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

     -- mod-button2, Raise the window to the top of the stack
     , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

     -- mod-button3, Set the window to floating mode and resize by dragging
     , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

     -- you may also bind events to the mouse scroll wheel (button4 and button5)
     ]

 ------------------------------------------------------------------------
 -- Layouts:

 -- You can specify and transform your layouts by modifying these values.
 -- If you change layout bindings be sure to use 'mod-shift-space' after
 -- restarting (with 'mod-q') to reset your layout state to the new
 -- defaults, as xmonad preserves your old layout settings by default.
 --
 -- The available layouts.  Note that each layout is separated by |||,
 -- which denotes layout choice.
 --

 myTheme = defaultTheme {
     activeColor         = blue
   , inactiveColor       = grey
   , activeBorderColor   = blue
   , inactiveBorderColor = grey
   , activeTextColor     = "white"
   , inactiveTextColor   = "black"
   , decoHeight          = 0
   }
     where
       blue = "#4a708b" -- same color used by pager
       grey = "#cccccc"


 myLayout = avoidStruts $ toggleLayouts Full perWS
   where
     perWS = onWorkspace "terms" termsLayout $
             onWorkspace "www" webLayout $
             onWorkspace "im" imLayout $
             onWorkspace "emacs" emacsLayout $
             onWorkspace "vm" vmLayout $
	     onWorkspace "8" termsLayout
	     Full

     -- Layout for terminals
     -- I find useful to use two terminals with tmux lauched in each one.
     -- So it's tiled layouts with two windows limit.
     -- The first one split workspace vertically, the second one - horizontally
     termsLayout = limitWindows 2 $ (Mirror $ tiled) ||| tiled

     -- Layout for web serfing. There are typically two windows: browser and email client
     -- Tabbed layout is ideally serves almost all my needs.
     -- Tiled layout is used quite rarely.
     webLayout = myTabbed ||| tiled

     -- Layout for full screen emacs
     -- It's very simple StackTile layout with 2 windows limitation.
     -- The master pane is always occupied by main emacs frame.
     -- Bottom part of the workspace (slave pane) is used by
     -- popup helper frame used for temporary buffers(*Help*, *Compilation*, etc)
     emacsLayout = limitWindows 2 $ StackTile 1 (3/100) (4/5)

     --
     -- Layout for virtual machines (kvm, qemu, wmware, virtualbox)
     -- tiled layout to show them all togher
     -- horizontal tiled with centerMaster to easily switch between VM windows
     -- tabbed is great for maximization
     vmLayout = tiled ||| centerMaster (Mirror $ tiled) ||| myTabbed

     --
     -- Instant messangers layout
     -- Pidgin roster on the left side, Skype roster on the right side
     -- Both pidgin and skype chat windows in the middle.
     -- Grid layout is used to show all chat windows
     -- tabbed layout is used to maximize chat window
     imLayout = avoidStruts $ withIM ratio pidginRoster $ reflectHoriz $ withIM skypeRatio skypeRoster (Grid ||| myTabbed)
       where
         chatLayout  = Grid
         ratio = (1%9)
         skypeRatio = (1%8)
         pidginRoster = And (ClassName "Pidgin") (Role "buddy_list")
         skypeRoster = (ClassName "Skype") `And`
                               (Not (Title "Options")) `And`
                                              (Not (Role "Chats")) `And`
                                                             (Not (Role "CallWindowForm")) 
     tiled = Tall nmaster delata ratio
       where
         nmaster = 1
         delata = 3/100
         ratio = 3/5

     myTabbed = tabbed shrinkText myTabConfig


 ------------------------------------------------------------------------
 -- Window rules:

 myManageHook = (composeAll . concat $
	[ [ className =? b --> doCenterFloat | b <- myFloats ]
        , [ className =? b --> doF(W.shift "www") | b <- myWebs ]
        , [ className =? b --> doF(W.shift "im") | b <- myIMs ]
        , [ className =? b --> doF(W.shift "doc") | b <- myDocs ]
        , [ className =? b --> doF(W.shift "vm") | b <- myVMs ]
        , [ resource =? "ORG" --> doF(W.shift "gtd") ]
      -- Always spawnDown second emacs window (helper frame must be on the bottom
        , [ className =? "Emacs" --> doF(W.shift "emacs") <+> doF W.swapDown ]
        , [ className =? "URxvt" --> doF(W.shift "terms") ]
        , [ resource  =? "gnome-panel" --> doIgnore ]
      -- for fullscreen flash
        , [ isFullscreen                    --> doFullFloat ]
	]
        ) <+> manageScratchPads
        where
          myWebs   = [ "Iceweasel", "Icedove" ]
          myIMs    = [ "Pidgin", "Skype" ]
          myDocs   = [ "Evince", "Okular", "Chmsee" ]
          myVMs    = [ "VirtualBox", "Vmware", "Vmware-installer.py", "Vmplayer" ]
          myFloats = [ "Gnome-display-properties" ]
          manageScratchPads = namedScratchpadManageHook scratchpads

 ------------------------------------------------------------------------
 -- Run xmonad with the settings you specify. No need to modify this.
 --
 main =  xmonad $ gnomeConfig
    {
       -- simple stuff
         terminal           = myTerminal,
       --  focusFollowsMouse  = myFocusFollowsMouse,
         borderWidth        = myBorderWidth,
         modMask            = myModMask,
         numlockMask        = myNumlockMask,
         workspaces         = myWorkspaces,
         normalBorderColor  = myNormalBorderColor,
         focusedBorderColor = myFocusedBorderColor,

       -- key bindings
         keys               = myKeys,
         mouseBindings      = myMouseBindings,

       -- hooks, layouts
         layoutHook         = myLayout,
         manageHook         = myManageHook <+> manageHook gnomeConfig
	}
