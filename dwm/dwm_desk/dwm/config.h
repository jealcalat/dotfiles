/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx = 2;				/* border pixel of windows */
static const unsigned int gappx = 10;					/* gaps between windows */
static const unsigned int snap = 32;					/* snap pixel */
static const unsigned int systraypinning = 0; /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 0;	/* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2; /* systray spacing */
static const int systraypinningfailfirst = 1; /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray = 1;							/* 0 means no systray */
static const int showbar = 1;									/* 0 means no bar */
static const int topbar = 1;									/* 0 means bottom bar */
/* ******************** Fonts ******************** */
static const char *fonts[] = {"JetBrainsMono Nerd Font:size=11"};
static const char dmenufont[] = "monospace:size=10";
static const char col_gray1[] = "#222222";
static const char col_gray2[] = "#444444";
static const char col_gray3[] = "#bbbbbb";
static const char col_gray4[] = "#eeeeee";
static const char col_cyan[] = "#00D6D6";
static const char col_black[] = "#2E2E2E";
static const char col_white[] = "#FFFFFF";
static const char col_blue[] = "#3967B0";
static const char col_red[] = "#8E0425";
static const char col_berm[] = "#C24B3B";

#include "gruvbox.h"
// static const char *colors[][3] = {
// 		/*               fg         bg         border   */
// 		[SchemeNorm] = {col_berm, col_black, col_red},
// 		[SchemeSel] = {col_gray4, col_blue, col_cyan},
// };

static char *colors[][4] = {
		/*                        fg                bg                border                float */
		[SchemeNorm] = {normfgcolor, normbgcolor, normbordercolor, normfloatcolor},
		[SchemeSel] = {selfgcolor, selbgcolor, selbordercolor, selfloatcolor},
		[SchemeTitleNorm] = {titlenormfgcolor, titlenormbgcolor, titlenormbordercolor, titlenormfloatcolor},
		[SchemeTitleSel] = {titleselfgcolor, titleselbgcolor, titleselbordercolor, titleselfloatcolor}};

/* tagging */
static char *tags[] = {"", "", "", "", "", "", "", ""};

static const char *tagsel[][2] = {
		{"#1d2021", "#83a598"},
		{"#ffffff", "#ff7f00"},
		{"#000000", "#ffff00"},
		{"#000000", "#fabd2f"},
		{"#ffffff", "#292929"},
		{"#D69821", "#1D2021"},
		{"#3C3836", "#BCAD92"},
		{"#000000", "#ffffff"}};

/* ******************** Window Rules ******************** */
static const Rule rules[] = {
		/* xprop(1):
		 *	WM_CLASS(STRING) = instance, class
		 *	WM_NAME(STRING) = title
		 */
		/* class      			instance    title       tags mask     iscentered   isfloating   monitor */
		{"Gimp", NULL, NULL, 0, 0, 1},
		{"Inkscape", NULL, NULL, 0, 0, 1},
		{"Firefox", NULL, NULL, 1 << 8, 0, 0},
		{"Viewnior", NULL, NULL, 0, 1, 1},
		{"MPlayer", NULL, NULL, 0, 1, 1},
		{"Pcmanfm", NULL, NULL, 0, 1, 1},
		{"Music", NULL, NULL, 0, 1, 1},
		{"Yad", NULL, NULL, 0, 1, 1},
		{"feh", NULL, NULL, 0, 1, 1},
		{"Pavucontrol", NULL, NULL, 0, 1, 1},
		{"Lxappearance", NULL, NULL, 0, 1, 1},
		{"alacritty-float", NULL, NULL, 0, 1, 1},
		{"VirtualBox Manager", NULL, NULL, 0, 1, 1},
		{"Nm-connection-editor", NULL, NULL, 0, 1, 1},
		{"Xfce4-power-manager-settings", NULL, NULL, 0, 1, 1},
};

/* layout(s) */
static const float mfact = 0.55;		 /* factor of master area size [0.05..0.95] */
static const int nmaster = 1;				 /* number of clients in master area */
static const int resizehints = 1;		 /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1 /* nrowgrid layout: force two clients to always split vertically */
#include "functions.h"

static const Layout layouts[] = {
		/* symbol     arrange function */
		{"[]=", tile}, /* first entry is default */
		{"><>", NULL}, /* no layout function means floating behavior */
		{"|+|", tatami},
		{"[M]", monocle}};

/* ******************** Key definitions ******************** */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY, TAG)                                        \
	{MODKEY, KEY, view, {.ui = 1 << TAG}},                         \
			{MODKEY | ControlMask, KEY, toggleview, {.ui = 1 << TAG}}, \
			{MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},          \
			{MODKEY | ControlMask | ShiftMask, KEY, toggletag, {.ui = 1 << TAG}},

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd)                                       \
	{                                                      \
		.v = (const char *[]) { "/bin/sh", "-c", cmd, NULL } \
	}

/* ******************** Commands ******************** */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {"dmenu", NULL};

/* Launch Apps */
static const char *stcmd[] = {"/home/mrrobot/.config/dwm/dwmterm.sh", NULL};
static const char *termcmd[] = {"/home/mrrobot/.config/dwm/dwmterm.sh", NULL};
static const char *floatterm[] = {"/home/mrrobot/.config/dwm/dwmterm.sh", "--float", NULL};
static const char *fmcmd[] = {"/home/mrrobot/.config/dwm/dwmapps.sh", "--file", NULL};
static const char *editcmd[] = {"/home/mrrobot/.config/dwm/dwmapps.sh", "--editor", NULL};
static const char *webcmd[] = {"/home/mrrobot/.config/dwm/dwmapps.sh", "--web", NULL};

/* Rofi Menus */
static const char *rofi_cmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/launcher", NULL};
static const char *rofi_rootcmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/asroot", NULL};
static const char *rofi_layoutcmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/layouts", NULL};
static const char *rofi_mpdcmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/mpd", NULL};
static const char *rofi_nmcmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/network_menu", NULL};
static const char *rofi_powercmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/powermenu", NULL};
static const char *rofi_shotcmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/screenshot", NULL};
static const char *rofi_wincmd[] = {"/home/mrrobot/.config/dwm/rofi/bin/windows", NULL};

/* Misc */
static const char *cpickcmd[] = {"/home/mrrobot/.local/bin/color-gpick", NULL};
static const char *lockcmd[] = {"/home/mrrobot/.local/bin/betterlockscreen", "--lock", NULL};
static const char *layoutswitcher[] = {"/home/mrrobot/.config/dwm/bin/layoutmenu.sh", NULL};

/* Hardware keys for volume and brightness */
#include <X11/XF86keysym.h>
static const char *mutevol[] = {"/home/mrrobot/.local/bin/volume", "--toggle", NULL};
static const char *upvol[] = {"/home/mrrobot/.local/bin/volume", "--inc", NULL};
static const char *downvol[] = {"/home/mrrobot/.local/bin/volume", "--dec", NULL};
static const char *upbl[] = {"/home/mrrobot/.local/bin/brightness", "--inc", NULL};
static const char *downbl[] = {"/home/mrrobot/.local/bin/brightness", "--dec", NULL};

/* Screenshot */
static const char *shotnow[] = {"/home/mrrobot/.local/bin/takeshot", "--now", NULL};
static const char *shotin5[] = {"/home/mrrobot/.local/bin/takeshot", "--in5", NULL};
static const char *shotin10[] = {"/home/mrrobot/.local/bin/takeshot", "--in10", NULL};
static const char *shotwin[] = {"/home/mrrobot/.local/bin/takeshot", "--win", NULL};
static const char *shotarea[] = {"/home/mrrobot/.local/bin/takeshot", "--area", NULL};

/* ******************** Keybindings ******************** */
static Key keys[] = {
		/* modifier 				key 						function 		argument */

		// Hardware Keys -----------
		{0, XF86XK_AudioMute, spawn, {.v = mutevol}},
		{0, XF86XK_AudioLowerVolume, spawn, {.v = downvol}},
		{0, XF86XK_AudioRaiseVolume, spawn, {.v = upvol}},
		{0, XF86XK_MonBrightnessUp, spawn, {.v = upbl}},
		{0, XF86XK_MonBrightnessDown, spawn, {.v = downbl}},

		// Print Keys -----------
		{0, XK_Print, spawn, {.v = shotnow}},
		{ALTKEY, XK_Print, spawn, {.v = shotin5}},
		{ShiftMask, XK_Print, spawn, {.v = shotin10}},
		{ControlMask, XK_Print, spawn, {.v = shotwin}},
		{ALTKEY | ControlMask, XK_Print, spawn, {.v = shotarea}},

		// Terminals -----------
		{MODKEY, XK_Return, spawn, {.v = stcmd}},
		{MODKEY | ShiftMask, XK_Return, spawn, {.v = floatterm}},
		{MODKEY | ControlMask, XK_Return, spawn, {.v = termcmd}},

		// Launch Apps -----------
		{MODKEY | ShiftMask, XK_f, spawn, {.v = fmcmd}},
		{MODKEY | ShiftMask, XK_e, spawn, {.v = editcmd}},
		{MODKEY | ShiftMask, XK_w, spawn, {.v = webcmd}},

		// Rofi Menus -----------
		{ALTKEY, XK_F1, spawn, {.v = rofi_cmd}},
		{MODKEY, XK_m, spawn, {.v = rofi_mpdcmd}},
		{MODKEY, XK_n, spawn, {.v = rofi_nmcmd}},
		{MODKEY, XK_r, spawn, {.v = rofi_rootcmd}},
		{MODKEY, XK_x, spawn, {.v = rofi_powercmd}},
		{MODKEY, XK_s, spawn, {.v = rofi_shotcmd}},
		{MODKEY, XK_w, spawn, {.v = rofi_wincmd}},

		// Misc -----------
		{MODKEY, XK_p, spawn, {.v = cpickcmd}},
		{ALTKEY | ControlMask, XK_l, spawn, {.v = lockcmd}},

		// Tags -----------
		TAGKEYS(XK_1, 0)
				TAGKEYS(XK_2, 1)
						TAGKEYS(XK_3, 2)
								TAGKEYS(XK_4, 3)
										TAGKEYS(XK_5, 4)
												TAGKEYS(XK_6, 5)
														TAGKEYS(XK_7, 6)
																TAGKEYS(XK_8, 7)
																		TAGKEYS(XK_9, 8)

		// DWM Session	-----------
		{MODKEY | ControlMask, XK_q, quit, {0}}, // Quit DWM
		{MODKEY | ShiftMask, XK_r, quit, {1}},	 // Restart DWM

		// Border and Gaps -----------
		/* Borders */
		//{ MODKEY|ShiftMask, 		XK_equal, 					setborderpx, {.i = +1 } }, // Increase border width
		//{ MODKEY|ShiftMask, 		XK_minus, 					setborderpx, {.i = -1 } }, // Decrease border width
		//{ MODKEY|ShiftMask, 		XK_BackSpace, 				setborderpx, {.i = default_border } },

		/* Gaps */
		{MODKEY, XK_comma, focusmon, {.i = -1}},
		{MODKEY, XK_period, focusmon, {.i = +1}},
		{MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
		{MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},
		{MODKEY, XK_minus, setgaps, {.i = -1}},
		{MODKEY, XK_equal, setgaps, {.i = +1}},
		{MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0}},

		// Window Management -----------
		/* Murder */
		{MODKEY, XK_c, killclient, {0}},						// Kill window
		{MODKEY, XK_Escape, spawn, SHCMD("xkill")}, // xkill

		/* Switch */
		{MODKEY, XK_j, focusstack, {.i = +1}}, // Cycle window
		{MODKEY, XK_k, focusstack, {.i = -1}},
		{MODKEY | ShiftMask, XK_j, movestack, {.i = +1}}, // Switch master
		{MODKEY | ShiftMask, XK_k, movestack, {.i = -1}},

		{MODKEY, XK_Left, focusstack, {.i = +1}}, // Cycle window
		{MODKEY, XK_Right, focusstack, {.i = -1}},
		{MODKEY | ShiftMask, XK_Left, movestack, {.i = +1}}, // Switch master
		{MODKEY | ShiftMask, XK_Right, movestack, {.i = -1}},

		{MODKEY, XK_i, incnmaster, {.i = +1}}, // Verticle
		{MODKEY, XK_u, incnmaster, {.i = -1}}, // Horizontal

		/* Resize */
		{MODKEY, XK_h, setmfact, {.f = -0.05}}, // Shrink left
		{MODKEY, XK_l, setmfact, {.f = +0.05}}, // Shrink right

		{MODKEY | ControlMask, XK_Left, setmfact, {.f = -0.05}},	// Shrink left
		{MODKEY | ControlMask, XK_Right, setmfact, {.f = +0.05}}, // Shrink right

		/* Misc */
		{MODKEY, XK_b, togglebar, {0}}, // Toggle bar
		{MODKEY, XK_Tab, zoom, {0}},		// Switch to master
		{ALTKEY, XK_Tab, view, {0}},		// Switch to last tag
		//{ MODKEY, 					XK_d, 						hidewin, {0} }, // Hide window
		//{ MODKEY|ShiftMask, 		XK_d, 						restorewin, {0} }, // Restore window
		{MODKEY, XK_0, view, {.ui = ~0}},
		{MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},

		// Layouts -----------
		{ALTKEY | ControlMask, XK_space, spawn, {.v = rofi_layoutcmd}},

		//{ MODKEY|ControlMask, 		XK_comma, 					cyclelayout, {.i = -1 } },
		//{ MODKEY|ControlMask, 		XK_period, 					cyclelayout, {.i = +1 } },
		{MODKEY | ShiftMask, XK_space, togglefloating, {0}},
		//{ MODKEY, 					XK_f, 						togglefullscr, {0} },

		{MODKEY, XK_space, setlayout, {0}},
		{MODKEY, XK_t, setlayout, {.v = &layouts[0]}},							// Tile
		{MODKEY, XK_g, setlayout, {.v = &layouts[10]}},							// Grid
		{MODKEY | ShiftMask, XK_m, setlayout, {.v = &layouts[1]}},	// Monocle
		{MODKEY | ShiftMask, XK_s, setlayout, {.v = &layouts[2]}},	// Spiral
		{MODKEY | ShiftMask, XK_t, setlayout, {.v = &layouts[5]}},	// Stack
		{MODKEY | ShiftMask, XK_c, setlayout, {.v = &layouts[11]}}, // Centered master
		{MODKEY | ShiftMask, XK_x, setlayout, {.v = &layouts[13]}}, // Tatami

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
		/* click                event mask      button          function        argument */
		{ClkLtSymbol, 0, Button1, setlayout, {0}},
		{ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
		{ClkWinTitle, 0, Button2, zoom, {0}},
		{ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
		{ClkClientWin, MODKEY, Button1, movemouse, {0}},
		{ClkClientWin, MODKEY, Button2, togglefloating, {0}},
		{ClkClientWin, MODKEY, Button3, resizemouse, {0}},
		{ClkTagBar, 0, Button1, view, {0}},
		{ClkTagBar, 0, Button3, toggleview, {0}},
		{ClkTagBar, MODKEY, Button1, tag, {0}},
		{ClkTagBar, MODKEY, Button3, toggletag, {0}},
};

static Signal signals[] = {
		/* signum           function */
		{"focusstack", "focusstack"},
		{"killclient", "killclient"},
		{"quit", "quit"},
};