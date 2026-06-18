## Debian and Openbox Restoration Script(s)

![Openbox desktop on Debian](https://madcarters.com/images/alanordic.jpg)

Handy Openbox desktop wickedness on a Debian system you can run with **just like that** after a net install and never have to worry about this sort of thing again. This installs a minimal desktop and you will probably install more stuff following, but, this is a good place to start. Best for a fresh install, but, scripts can be run any time and with subsequent users. This desktop setup is a pretty good way to go if you enjoy the Linux. It has been reliable anf functional for me for a long time. It's out of your way, light, fast, boring - no whiz-bang at all, like, no ricing, or, whatever.
I don't even know what that is. It's X11, too, so, you know, it's, ahhh, mature.

Basically this is just an easy restore solution for me on a new or formatted drive that works so well I put it up here; have at it. I run it when I reinstall and keep ~/me, too. Just so handy.

Thanks to all the maintainers and devs and clever folk out there because computing with the Linux is (still) the best thing ever.

## What to be aware of out the gate

1. Defaults to an external monitor, *see ~/.config/openbox/autostart*
2. boots to a tty, there is no login/display manager
3. You may want to install connman or network-manager if you need wifi
4. you may uncomment:   
```#[ ! "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && PROMPT_COMMAND="startx && exit;"```  
at the bottom of restored ~/.profile in order to log in automatically after you input your credentials.

## Get There from Here, Simple and quick

Install Debian from the [net installer](https://www.debian.org/CD/netinst/) **root user and 'standard system utilities'** only at install software time.

Reboot

Log in as root to install sudo, aptitude, and git

```apt-get install -y sudo aptitude git```  

Then run **visudo** and add user beneath the root user listing like this:  

```$USER ALL=(ALL:ALL) NOPASSWD:ALL```

Following that, log out and log in as your regular user and clone the repo

```git clone https://github.com/rabmach/debola.git```  

Then, simply cd into debola, chmod +x restore.sh, and then run it: ./restore.sh

and there you go. Have fun.

## Usage

```
   ./restore.sh                   # Run full restoration
   ./restore.sh --help            # Show help
   ./restore.sh --skip 01         # Skip a specific task (by number)
   ./restore.sh --only 04         # Run only a specific task
   ./restore.sh --list            # List available tasks
   ./restore.sh --dry-run         # Show what would be done without doing it
```

## There are some manual steps following this install

	in ~/.config
		pianobar/config      # add your credentials, and check the 'event_command' line
		weather_sh.rc        # replace <...> with the right info

1. run **obconf** and change the theme to Nord-Openbox-Theme-Master
2. set the weather in the **lxpanel** weather widget
3. <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>P</kbd> one time, <kbd>Win</kbd>+<kbd>H</kbd>

## Current menu

<img src="https://madcarters.com/images/menuupd.jpg">


## A few of the keybinds
<dl>
	<dt>
<kbd>Win</kbd>+<kbd>Z</kbd> - custom openbox menu</dt>
<dt><kbd>win</kbd>+<kbd>L</kbd> - locks the desktop</dt>
<dt><kbd>win</kbd>+<kbd>S</kbd> - screenshot menu</dt>
<dt><kbd>Print</kbd> - xfce4-screenshooter</dt>
<dt><kbd>Win</kbd>+<kbd>A</kbd> - Audacity, playing</dt>
<dt><kbd>Win</kbd>+<kbd>P</kbd> - launch pianobar</dt>
	<dd><kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Home</kbd> - like the tune</dd>
	<dd><kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Left arrow</kbd> - history</dd>
	<dd><kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Right arrow</kbd> - next tune</dd>
	<dd><kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Up arrow</kbd> - switch station</dd>
	<dd><kbd>win</kbd>+<kbd>alt</kbd>+<kbd>Down arrow</kbd> - pause</dd>
	<dd><kbd>win</kbd>+<kbd>Delete</kbd> - quit pianobar</dd>
<dt><kbd>Win</kbd>+<kbd>B</kbd> - Firefox</dt>
<dt><kbd>Win</kbd>+<kbd>F</kbd> - x-file-manager</dt>
<dt><kbd>Win</kbd>+<kbd>E</kbd> - x-text-editor</dt>
<dt><kbd>Win</kbd>+<kbd>T</kbd> - x-terminal-emulator</dt>
<dt><kbd>Win</kbd>+<kbd>M</kbd> - Claws-Mail</dt>
<dt><kbd>Win</kbd>+<kbd>H</kbd> - htop</dt>
<dt><kbd>Win</kbd>+<kbd>I</kbd> - yad icon browser</dt>
<dt><kbd>Win</kbd>+<kbd>K</kbd> - KeepassXC</dt>
<dt><kbd>Win</kbd>+<kbd>W</kbd> - LibreOffice Writer</dt>
<dt><kbd>Win</kbd>+<kbd>R</kbd> - ssr, recording</dt>
<dt><kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>P</kbd> - flick picker</dt> </dl>

later


<img src="https://madcarters.com/images/logout.jpg">
