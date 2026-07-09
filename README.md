# Debian and Openbox Restoration Script

An Openbox desktop on a Debian (Trixie) system that kicks all kinna ass. Read the heads-up below and happy days.

This installs a lightweight, fully functional and completely opinionated desktop following a net install of Debian. No doubt you will install more stuff, but, this is a good place to start. Best for a fresh install, but, script can be run any time and with subsequent users.

![Openbox desktop on Debian](https://madcarters.com/images/alanordic.jpg)

This setup is great for older machines (say, an HP EliteBook 8440p) or low-spec models and is smokin' on newer hardware (a Lenovo p53s, maybe). It has been reliable and functional for (me, others) for a long time. It's out of the way, light, fast, boring - no whiz-bang at all other than handy; no ricing, or, whatever.
I am not even sure what that is. It's pretty, though, and X11. Also uses the fastcompmgr compositor.


# Basic Applications, whatnot

|Package | Purpose | Other keybinds|
|:--------|:--------|:--------|
|Thunar  | File Manager <kbd>Win</kbd>+<kbd>F</kbd>|<kbd>Win</kbd>+<kbd>Z</kbd> - menu|
|lxpanel | panel|<kbd>win</kbd>+<kbd>L</kbd> - locks the desktop|
|Alacritty| terminal <kbd>Win</kbd>+<kbd>T</kbd>|<kbd>win</kbd>+<kbd>S</kbd> - screenshot menu|
|Bash    | shell|<kbd>Print</kbd> - xfce4-screenshooter|
|Firefox | browsah <kbd>Win</kbd>+<kbd>B</kbd>|<kbd>Win</kbd>+<kbd>I</kbd> - yad icon browser|
|Claws-Mail| email <kbd>Win</kbd>+<kbd>M</kbd>|<kbd>Win</kbd>+<kbd>K</kbd> - KeepassXC|
|Gpicview| image viewer|<kbd>Win</kbd>+<kbd>R</kbd> - simplescreenrecorder|
|Gimp    | art & stuff|<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>P</kbd> - random movie|
|MPV     | media player|**Control Pianobar**|
|Audacious| music <kbd>Win</kbd>+<kbd>A</kbd>|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Up arrow</kbd> - switch station|
|Pianobar| mo' music <kbd>Win</kbd>+<kbd>P</kbd>|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Home</kbd> - like the tune|
|LibreOffice| office <kbd>Win</kbd>+<kbd>W</kbd>|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Left arrow</kbd> - history|
|Sublime-Text| editor <kbd>Win</kbd>+<kbd>E</kbd>|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Down arrow</kbd> - pause|
|Geany   | all in session|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Right arrow</kbd> - next tune|
|Rsync| backin' stuff up|<kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Delete</kbd> - quit pianobar|



# Get There from Here

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

### then run the script

	./restore.sh                   # Run full restoration
   
	./restore.sh --help            # Show help
	./restore.sh --skip 01         # Skip a specific task (by number)
	./restore.sh --only 04         # Run only a specific task
	./restore.sh --list            # List available tasks
	./restore.sh --dry-run         # Show what would be done without doing it


...And there you go; a new Debian and Openbox setup and it's the easiest 13 minutes you will spend today with the biggest return, by miles. Have fun.


# Heads Up

1. Defaults to an external monitor, *see ~/.config/openbox/autostart*
2. boots to a tty, there is no login/display manager. I install [loginfetch](https://github.com/leomarcov/debian-openbox/tree/master/30_script_loginfetch) modified to negate physlock
3. You may want to install **connman** or **network-manager** if you need wifi
4. you may uncomment:   
```#[ ! "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && PROMPT_COMMAND="startx && exit;"```  
at the bottom of restored ~/.profile in order to log in automatically after you input your credentials.
5. No printing support is installed by default, you may wanna: cups, maybe hplip.


# Post Install

+ edit **~/.config/pianobar/config** to add your creds and check line 11
+ edit **~/.config/weather_sh.rc** add your_api and your_city_code
+ edit **~/bin/weather.sh** look at lines 5 and 6
+ set the weather in the **lxpanel** weather widget
+ <kbd>Win</kbd>+<kbd>H</kbd> for htop, <kbd>Win</kbd>+<kbd>insert</kbd> captures screen


## Kernels

[Liquorix](https://liquorix.net/) or [XanMod](https://xanmod.org/)


later


<img src="https://madcarters.com/images/logout.jpg">
