# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Set $TERM environment variable to xterm-256color, since default for putty is xterm-8color.
if [ "$TERM" = xterm ];
then
		TERM=xterm-256color;
fi

export PATH="$HOME/.cargo/bin:$PATH"

# Adding this in to test out Qt themes.
# https://www.linuxuprising.com/2018/05/use-custom-themes-for-qt-applications.html
#export QT_STYLE_OVERRIDE=kvantum

# Adding this to export the ZDOTDIR to the ~/.config/zsh
export ZDOTDIR="$HOME/.config/zsh"

# The variable XDG_CONFIG_HOME should be set here so it's set globally regardless of the shell, but
# I set it inside the zshrc file.
# export XDG_CONFIG_HOME="${HOME}/.config
