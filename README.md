# Debian and Openbox Restoration Script

An Openbox desktop on a Debian (Trixie) system that kicks all kinna ass. Read the heads-up below and happy days.

This installs a lightweight, fully functional and completely opinionated desktop following a net install of Debian. No doubt you will install more stuff, but, this is a good place to start. Best for a fresh install, but, script can be run any time and with subsequent users.

![Openbox desktop on Debian](https://madcarters.com/images/alanordic.jpg)

This setup is great for older machines (say, an HP EliteBook 8440p) or low-spec models and is smokin' on newer hardware (a Lenovo p53s, maybe). It has been reliable and functional for (me, others) for a long time. It's out of the way, light, fast, boring - no whiz-bang at all other than handy; no ricing, or, whatever.
I am not even sure what that is. It's pretty, though, and X11. Also uses the fastcompmgr compositor.


# Get There from Here, Simple and Quick

Install Debian from the [net installer](https://www.debian.org/CD/netinst/), choose advanced, expert install

1. opt to give a password to the **root user**
2. choose only **standard system utilities** at the software installation part, un-check the rest.

After the reboot log in as root to install sudo, aptitude, and git

	apt-get install -y sudo aptitude git

Then run **visudo** and add user beneath the root user listing like this:  

	$USER ALL=(ALL:ALL) NOPASSWD:ALL

Following that, log out and log in as your regular user and clone the repo

	git clone https://github.com/rabmach/debola.git

cd into debola:
	
	chmod +x restore.sh

# Run it; usage

```
   ./restore.sh                   # Run full restoration
   ./restore.sh --help            # Show help
   ./restore.sh --skip 01         # Skip a specific task (by number)
   ./restore.sh --only 04         # Run only a specific task
   ./restore.sh --list            # List available tasks
   ./restore.sh --dry-run         # Show what would be done without doing it
```

and there you go; a new Debian and Openbox setup and it's the easiest 13 minutes you will spend today with the biggest return, by miles. Have fun.


# Heads Up - Important Stuff

1. Defaults to an external monitor, *see ~/.config/openbox/autostart*
2. boots to a tty, there is no login/display manager. I install [loginfetch](https://github.com/leomarcov/debian-openbox/tree/master/30_script_loginfetch) modified to negate physlock
3. You may want to install **connman** or **network-manager** if you need wifi
4. you may uncomment:   
```#[ ! "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && PROMPT_COMMAND="startx && exit;"```  
at the bottom of restored ~/.profile in order to log in automatically after you input your credentials.
5. No printing support is installed by default, you may wanna: cups, maybe hplip.


# Post Install Tasks, **The Horror!**

	in ~/.config

		pianobar/config     # add your creds and check line 11
		weather_sh.rc       # your_api and your_city_code
		ALSO --> ~/bin/weather.sh 	  # lines 5 and 6

1. set the weather in the **lxpanel** weather widget
2. <kbd>Win</kbd>+<kbd>H</kbd> for htop, <kbd>Win</kbd>+<kbd>insert</kbd> captures screen

# Your Basic Applications

|Package | Purpose| Handy
|:--------|:--------|:--------:|
|Thunar  | File Manager|<kbd>Win</kbd>+<kbd>F</kbd>|
|lxpanel | panel|
|Alacritty| terminal|<kbd>Win</kbd>+<kbd>T</kbd>|
|Bash    | shell|
|Firefox | browsah|<kbd>Win</kbd>+<kbd>B</kbd>|
|Claws-Mail| email|<kbd>Win</kbd>+<kbd>M</kbd>|
|Gpicview| image viewer|
|Gimp    | art & stuff|
|MPV     | media player|
|Audacious| music|<kbd>Win</kbd>+<kbd>A</kbd>|
|Pianobar| mo music|<kbd>Win</kbd>+<kbd>P</kbd>|
|LibreOffice| office|<kbd>Win</kbd>+<kbd>W</kbd>|
|Sublime-Text| editor|<kbd>Win</kbd>+<kbd>E</kbd>|
|Geany   | all in session|


**see the 02-packages.sh script** in the tasks directory for packages installed

| Couple movin' around keybinds | Control Pianobar|
|:--------|:--------|
|<kbd>Win</kbd>+<kbd>Z</kbd> - custom openbox menu|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Home</kbd> - like the tune|
|<kbd>win</kbd>+<kbd>L</kbd> - locks the desktop|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Left arrow</kbd> - history|
|<kbd>win</kbd>+<kbd>S</kbd> - screenshot menu|<dt><kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Up arrow</kbd> - switch station|
|<kbd>Print</kbd> - xfce4-screenshooter|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Down arrow</kbd> - pause|
|<kbd>Win</kbd>+<kbd>I</kbd> - yad icon browser|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Right arrow</kbd> - next tune|
|<kbd>Win</kbd>+<kbd>K</kbd> - KeepassXC|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Delete</kbd> - quit pianobar|
|<kbd>Win</kbd>+<kbd>R</kbd> - simplescreenrecorder|
|<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>P</kbd> - random movie|












## Maybe you want a different kernel

[Liquorix](https://liquorix.net/) or [XanMod](https://xanmod.org/)


later


<img src="https://madcarters.com/images/logout.jpg">
