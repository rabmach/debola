# Debian and Openbox Restoration Script

An Openbox desktop on a Debian (Trixie) system that kicks all kinna ass.

This installs a lightweight, fully functional and completely opinionated desktop following a net install of Debian. No doubt you will install more stuff, but, this is a good place to start. Best for a fresh install, but, script can be run any time and with subsequent users.

![Openbox desktop on Debian](https://madcarters.com/images/alanordic.jpg)

This setup is great for old(er) machines (say, an HP EliteBook 8440p) or low-spec models and is smokin' on newer hardware (a Lenovo p53s, maybe, which is getting a little old). It has been reliable and functional for (me, others) for a long time. It's out of the way, light, fast, boring, sane - no whiz-bang at all other than handy; no ricing, or, whatever.
I am not even sure what that is. It's pretty, though, and X11. Also uses the fastcompmgr compositor.

## Boring and Reliable
So boring. It's just there all the time working and doing. All the time. It's like in a relationship where you never argue, at all, not even a little. That's weird, right? Debian, man, it's always right there saying, "Yes, of course!" to your chaos. 

And Openbox. Sit DOWN, son. It's already your favorite, you just don't know it, yet. Clone the repo, ./restore.sh, use it a day. Try to be cool.


# Basic Applications, whatnot

| Package | Purpose | Other keybinds|
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
   
```
./restore.sh --help            # Show help
./restore.sh --skip 01         # Skip a specific task (by number)
./restore.sh --only 04         # Run only a specific task
./restore.sh --list            # List available tasks
./restore.sh --dry-run         # Show what would be done without doing it
```


There you go; a new Debian and Openbox setup and it's the easiest 13 minutes you will spend today with the biggest return, by miles. Have fun.

| Heads Up :index_pointing_at_the_viewer:| :point_down: Post Install|
|:--------|:--------|
| Defaults to an external monitor, prompted | edit **~/.config/pianobar/config** to add your creds and check line 11 |
| boots to a tty, so, startx | edit **~/.config/weather_sh.rc** add your_api and your_city_code |
| install **network-manager** if you need wifi | edit **~/bin/weather.sh** look at lines 5 and 6 |
| uncomment last line in restored ~/.profile | config the **lxpanel** weather widget |
| Prompted to include printing support | <kbd>Win</kbd>+<kbd>w</kbd>LO Writer, <kbd>Win</kbd>+<kbd>insert</kbd> captures screen |


## Kernels

[Liquorix](https://liquorix.net/) or [XanMod](https://xanmod.org/)


later


<img src="https://madcarters.com/images/logout.jpg">
