# My Work-In-Progress Dotfiles and Configs.

## Mainly using this as an insurance policy/offiste backup and to install on my other computers.

This repo is primarily just intended for my own off-site backups, but the 'bin/tc' [truecolors] script
is very handy for testing different $TERM color modes, and whether or not truecolor/24bit color
is active and if your terminal is capable of 24bit color mode.

The specific declarations of the $TERM variable in .zshrc, and setting default-terminal settings
in .tmux.conf were very finicky getting to work properly with 24bit color mode specifically
retaining the settings in tmux sessions, however every terminal emulator I've run the tc script on
has worked with the current configurations (except for urxvt/rxvt-unicode due to the way it
approximates to 256 colors).
