/* user and group to drop privileges to */
static const char *user  = "nobody";
static const char *group = "nogroup";

static const char *colorname[NUMCOLS] = {
	[INIT] =   "#1D2025",   /* after initialization */
	[INPUT] =  "#87BB7C",   /* during input */
	[CAPS] =   "#D5B875",   /* CapsLock on */
	[FAILED] = "#DD7186",   /* wrong password */
};

/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
		{ "color0",       STRING,  &colorname[INIT]   },
		{ "color2",       STRING,  &colorname[INPUT]  },
		{ "color1",       STRING,  &colorname[FAILED] },
		{ "color3",       STRING,  &colorname[CAPS]   },
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;

/* time in seconds to cancel lock with mouse movement */
static const int timetocancel = 5;

/* time in seconds before the monitor shuts down */
static const int monitortime = 10;
