## Debian and Openbox Restoration Script(s)

![Openbox desktop on Debian](https://madcarters.com/images/alanordic.jpg)



Handy Debian and Openbox desktop wickedness you can quickly set up and use after a net install.

Heh, 'DORiS', because acronyms are fun. Right?

I borrowed from all over the place over the years and attribution has more or less been maintained.

## Get There from Here

Install Debian, a bare solution, from the net installer - root user, system tools only at install software time. 
Reboot, login as root to install sudo, aptitude, and git, then give your user sudo. ( # visudo )
Log out and back in as you and clone the debola repo. Run the restore.sh script and there you go. Have fun.

Usage

```
   ./restore.sh                   # Run full restoration
   ./restore.sh --help            # Show help
   ./restore.sh --skip 01         # Skip a specific task (by number)
   ./restore.sh --only 04         # Run only a specific task
   ./restore.sh --list            # List available tasks
   ./restore.sh --dry-run         # Show what would be done without doing it
```

It's boring because it's Debian and Openbox and it just works. Lots of keybinds, aliases, that kind of thing, few handy scripts and whatnot. 
Pretty good way to go if you enjoy the Linux. Out of your way, light, fast, !Ahem! boring - no whiz-bang at all, like, no ricing, or, whatever.
I don't even know what that is. It's X11, too, so, you know, it works. Heh.

I don't use wifi at home and that is reflected here. If wifi is needed at any point it's simple enough just to install connman; works a charm.

see ya
