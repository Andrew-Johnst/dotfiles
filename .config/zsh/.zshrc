####################################################################################################
####################################################################################################
####################################################################################################
#### [WARNING THAT APPLIES TO ANY ENVIRONMENT VARIABLES PERTAINING TO SSH IP ADDRESSES]:
#### SET THEM MANUALLY OR HAVE A CHECK BECAUSE OTHERWISE IF BEING SSH'D INTO VIA ANOTHER SSH
#### CONNECTION, IT WILL USE THE INFO OF THE NEAREST HOP/LINK UPWARDS IN THE SSH CHAIN SETTING
#### FALSE INFORMATION FOR ENVIRONMENT VARIABLES. (NAMELY THE DISPLAY AND PULSE_SERVER VARIABLES).
####################################################################################################
####################################################################################################
####################################################################################################

# Exports the ZDOTDIR into ~/.config/zsh rather than cluttering up the home directory wtih dotfiles.
#export ZDOTDIR="$HOME/.config/zsh"
# Exports the oh-my-zsh directory.
#export ZSH="$HOME/.config/zsh/.oh-my-zsh"
 # [Using the oh-my-zsh plugin (make sure to push current changes before doing so, just in case
 # something breaks.]
#export ZSH="$HOME/.config/zsh/.oh-my-zsh"

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[cyan]%}%n%{$fg[magenta]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Another stupid fix for being able to use aliases with sudo.
# [Link]:
# 	https://unix.stackexchange.com/a/185005
#type -a startapp | grep -o -P "(?<=\`).*(?=')" | xargs sudo

####################################################################################################
######################################### Source oh-my-zsh #########################################
####################################################################################################
# Using this stackexchange.com post since bracketed-paste-magic was causing pasting into WSL shell
# to insert "[[~201" characters.
# 	https://apple.stackexchange.com/a/315515
#	https://stackoverflow.com/a/40799717
DISABLE_MAGIC_FUNCTIONS=true
#source $ZDOTDIR/.oh-my-zsh/oh-my-zsh.sh

####################################################################################################
##################### Source Custom ZSH/Shell Helper Scripts and Config Files. #####################
####################################################################################################
# Exports the ZDOTDIR into ~/.config/zsh rather than cluttering up the home directory wtih dotfiles.
export ZDOTDIR="$HOME/.config/zsh"
export ZSH="$ZDOTDIR/.zshrc"

# Checks for the presence of the "Shell-Helpers" directory in the zsh config directory, source all
# the files in there if the directory exists. This contains the "aliasrc" and "functionrc" files
# that are each a large laundry-list of custom shell aliases and functions.
# Export global ZSH environment variable to dictate where the ZSH configuration files are located.
ShellShortcutDir="$HOME/.config/zsh/Shell-Shortcuts/"
[ -d "$ShellShortcutDir" ] && \
	for f in ${ShellShortcutDir}*; do source "$f"; done && \
	export ZSH_SHORTCUTS="$HOME/.config/zsh/Shell-Shortcuts/"

# Check if a directory named "Scripts" is available in the current $ZDOTDIR directory, if it is then
# export a variable for $ZSHSCRIPTS pointing to that directory, so that some scripts may be
# called more conveniently.
[ -d "$ZDOTDIR/Scripts" ] && \
	export ZSHSCRIPTS="$ZDOTDIR/Scripts"

# Check if a local (host specific) aliasrc file exists; if it does then source it, otherwise ignore
# it.
[[ -f "$HOME/.local/zsh/local-aliases" ]] && export ZSH_LOCAL="$HOME/.local/zsh" && \
	source "$HOME/.local/zsh/local-aliases"


# If the Shell-Helpers directory is not present, then export ZSH environment variable to the
# previous location for the ZSH shell helper scripts--like aliasrc and functionrc.
[ ! -d "$ShellShortcutDir" ] && \
	export ZSH_AFRC="$HOME/.config/zsh/"

# Check if there is a directory named "Filters" in the main "$ZDOTDIR" directory path, export an
# environment variable "ZSH_PROGRAM_FILTERS" if so.
[ -d "$ZDOTDIR/Filters/" ] && \
	export ZSH_PROGRAM_FILTERS="$ZDOTDIR/Filters/"

# Check if certain scripts located in the user's ".local" directory in their home directory; source
# it if so. (Currently only checking for one script in this directory).
[ -f "$HOME/.local/bin/ManualScripts/bfg" ] && source "$HOME/.local/bin/ManualScripts/bfg"

# Check if a directory named "Shell-Helpers is located in the $ZDOTDIR directory, if it is then
# export an environment variable pointing to that directory.
#ShellHelperDir="$Home/.config/zsh/Shell-Helpers/"
#[ -d "$ShellHelperDir" ] && export ZSH_HELPERSCRIPTS="$ShellHelperDir"

####################################################################################################
################# Scripts, Functions, Etc. To Run During Each Shell Instance Spawn #################
####################################################################################################


# This automatically allows ZSH to determine if a link has been pasted into the terminal/shell and
# automatically handles the special characters appropriately by escaping them.
# [Link]: https://forum.endeavouros.com/t/tip-better-url-pasting-in-zsh/6962
autoload -U url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -U compinit
# [This was taken from VirtualBox Debian 11 64-Bit which was written at latest of [3-16-2020]]:
#zstyle ':completion:*' menu select
zstyle ':completion:*:*:-command-:*:*' tag-order 'functions:-non-comp *' functions
zstyle ':completion:*:functions-non-comp' ignored-patterns '_*'
zmodload zsh/complist
compinit

# Include hidden files in autocomplete:
_comp_options+=(globdots)

# Commenting Luke's bindkey settings for now.
#    Use vim keys in tab complete menu:
#   bindkey -M menuselect 'h' vi-backward-char
#   bindkey -M menuselect 'k' vi-up-line-or-history
#   bindkey -M menuselect 'l' vi-forward-char
#   bindkey -M menuselect 'j' vi-down-line-or-history
#   bindkey -v '^?' backward-delete-char

# Keybinds, using vikeys option, manually binding <C-v> to <Esc> for congruency with my vim config.
bindkey -r "^[/"
bindkey -v

export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# This function fixes the issue with ranger and oh-my-zsh:
# "maximum nested function level reached; increase FUNCNEST?"
# [Solution taken from this post]:
# 	https://stackoverflow.com/a/42822796
#function gr

# Taken from the official ranger github repo; keeps your shell in the same directory ranger was
# in before quitting.
#bind '"\C-o":"ranger_cd\C-m"'


# Presumably, this is what was causing <C-v> binding to fail.
#
# zle-line-init() {
#    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#    echo -ne "\e[5 q"
#}
#zle -N zle-line-init



# Use beam shape cursor on startup.
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
function preexec() { echo -ne '\e[5 q' ;}

### [BREAKS compinit APPARENTLY].
#	# Add ZSH ${fpath} list variable item that includes the "lf" function that the "lfcd" function from
#	# Luke Smith's (at the time) LARBS config had, and "lf" was not already installed or installed as a
#	# dependency.
#	fpath=("${ZDOTDIR}/Scripts/lf" "${fpath}")

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir"
            fi
        fi
    fi
}

####################################################################################################
############################################# Keybinds #############################################
####################################################################################################
# bindkey -s '^o' 'lfcd\n'					# ZSH (lfcd is a function provided for common shells 
											# used to change the pwd on quit).
bindkey '^[f' vi-cmd-mode					# Binds <M-F> to return to vi normal mode (<Esc>) 
											# becuase I'm lazy.
bindkey -s '^[l' '^L'						# Binds <M-L> to clear screen (added for easier screen
											# clearing in tmux.
autoload -U edit-command-line				# Load the required zsh module to allow editing the
zle -N edit-command-line					# current command in a tmp file with $EDITOR.
bindkey -M vicmd '^[v' edit-command-line	# Binds <M-v> to edit the command-line in a vim buffer.

### COMMENTING OUT THIS <ESC> KEYBIND SINCE I HAVE NO USE FOR <ESC> BEING EXCLUSIVE TO VIM'S "x" ###
### BUTTON.
## Not sure if this will have much effect since tmux prolly captures special keycombos like this and
## would take precedence since they already do with <C-L> and clear command.
#bindkey 	'^['	delete-char

# This fixes the issue of pressing the numberpad/tenkey "Enter" key while "Number Lock" is not
# enabled (which inserts an "OM" instead of a Carriage Return).
bindkey	'^[OM'	accept-line



# Manual environment variables.
export EDITOR=nvim
export FILEMANAGER=pcmanfm-qt

# This environment variable needs to be exported as well so that when using sudo,
# (I specifically noticed during "systemctl edit" command--among a few other programs) the editor is
# either plain Vim--without my, or ANY ".vimrc" or "init.vim" file loaded--despite root and my
# account sharing the same Vim/NeoVim configuration file via a symlink.
# [Found this fix from this stackexchange post]:
# 	https://unix.stackexchange.com/a/408419
export SYSTEMD_EDITOR="$EDITOR"


# Apparently, despite countless warnings online against exporting TERM variable in shell profile,
# this is what fixed it lol. (Have yet to start new SSH instance, or X11 session however).
# Removing this for now.
	# Temporarily commenting this out/changing the "$TERM" env back to "tmux-256color" as per
	# instructions of running a ":checkhealth" in neovim.
	#export TERM=xterm-256color
export TERM=tmux-256color
#export TERM=mintty
#export TERM=tmux-256color
#export TERM=tmux

# Checks whether or not the current session is from SSH, exports the DISPLAY variable to the IP
# address of the SSH client if so, and if the current session doesn't appear to originate from an
# SSH session, it will default to setting the DISPLAY variable to the standard (on-board/localhost)
# display address.
#if [[ -n "$SSH_CONNECTION" ]]
if ([ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] || [ -n "$SSH_CONNECTION" ])
then
    export DISPLAY="$(echo $SSH_CLIENT | awk '{print $1}'):0.0"
    #export SSH_CLIENT_IP="$(echo $SSH_CLIENT | awk '{print $1}')"
    # Old variable export that defaulted to my desktop IP.
    #DISPLAY=192.168.1.30:0.0
	
	# This defaults to the current $SSH_CONNECTION IP address; this is used while accessing from WAN
	# and utilizing X11Forwarding through connection to the NAS's LAN via connecting to
	# AsusWRT-Merlin (OpenVPN Server)'s LAN.
	#
	# (This below line for whatever reason only as of 8-7-2021 started setting the DISPLAY to the
	# default gateway [192.168.1.1] so commenting this out since the first word in $SSH_CONNECTION
	# is the default gateway).
	#
    #	DISPLAY="$(echo $SSH_CONNECTION | awk '{print $1}'):0.0"
	#
    # Below conditional checks to see if current SSH Client IP address has valid IPv4 address
    # (general IP check).
    #	[[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} ]] &&
	#
    # Below conditional checks to see if network is on "192.168.1.0/24" network.
    #	[[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.1\.[0-9]\{1,3\} ]]
	#
	# Below conditional checks to see if current network interface LAN IP is on 192.168.200.0/24
	# subnet ("Temporary" subnet/network for KVM virtual-network until I setup subnetting/VLANs with
	# Cisco router and switch).
    #[[ "$SSH_CLIENT_IP" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] && \
	#
	# (2-2-2023) Below is the tested and proven method of getting the proper SSH Client address and
	# assigning it to the $DISPLAY variable while being (mostly) POSIX compliant.
	[[ "$(echo $SSH_CONNECTION | cut -d ' ' -f1)" =~		\
		^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$	\
		]] &&												\
		export DISPLAY="$(echo $SSH_CONNECTION | cut -d " " -f1):0.0"
        #export DISPLAY="$SSH_CLIENT_IP:0.0"
        #export DISPLAY="192.168.1.30:0.0"
    #export DISPLAY="192.168.1.30:0.0"

# Manually adding this here for this specific VM so that X11 is forwarded to the Windows 10
# Host/Hypervisor machine.
#export DISPLAY="192.168.1.30:0.0"
	# (8-7-2021)
	
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	# !!! [4-4-2022 11:13PM] I changed this below setting (LIBGL_ALWAYS_INDIRECT=1 to 0) and before,
	# !!! glxgears would NEVER spin, but after changing the value to a 0, the gears spun. This could
	# !!! very well be because I purged all nvidia drivers (after switching from a GTX 750Ti to a
	# !!! Radeon 400 series and installed OpenGL version 4+).
	# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	# Sets OpenGL rendering to indirect, meant for rendering over network.
	# https://unix.stackexchange.com/questions/1437/what-does-libgl-always-indirect-1-actually-do
	export LIBGL_ALWAYS_INDIRECT=0
else
	export DISPLAY=:0
fi
# Change later (1-8-21 8:41PM).
#export DISPLAY="192.168.1.30:0.0"
# 	### Addendum ###
# 		The above line manually overrides the check to determine and set the DISPLAY variable based
# 		on SSH connection; while testing things with remote access over WAN and X11 Forwarding, it
# 		IS possible to forward X11 over WAN (provided the client is connected to the router's
# 		OpenVPN server).

# Commenting these below lines out in-favor of using an actual if function so that the DISPLAY
# variable will be set to whatever IP address the SSH connection is sourced from, whereas the old
# method only checked if it was using SSH and would just default/assume IP address: 192.168.1.30
# which is my Windows 10 Desktop (running modified pulseaudio server and VcXsrv for X11 Forwarding).
# Checks whether current session is a SSH or TTY to set the DISPLAY variable appropriately for X11
# forwarding to Desktop VcXsrv server. Default is set to the default display of :0
#export DISPLAY=:0
#[[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] && DISPLAY=192.168.1.30:0.0
#[[ "$HOST" == "Drew-PC" ]] && DISPLAY=localhost:0
#[[ -z "$SSH_CLIENT" || -z "$SSH_TTY" ]] && DISPLAY=:0

# Sets OpenGL rendering to indirect, meant for rendering over network.
# https://unix.stackexchange.com/questions/1437/what-does-libgl-always-indirect-1-actually-do
# export LIBGL_ALWAYS_INDIRECT=1

# Adding this in 5-6-2021 as per the link below that needs to be added into the shell rc file in
# order to get PulseAudio to work.
# Sets the default HOST_IP to the local IP; then checks if an SSH session is being used to
# connect, if so then set the HOST_IP to the IP of the SSH client that is connecting to the host.
export HOST_IP=$(ip -o -4 route get 1.1.1.1 | sed -nr 's/.*src ([^\ ]+).*/\1/p')
[[ "$SSH_CLIENT" ]] && export HOST_IP="$(echo $SSH_CLIENT | awk '{print $1}')"
export PULSE_SERVER="tcp:$HOST_IP"

# Fuzzy Finder settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add this to the zshrc file if required to login to ACC system, so that programs can be installed
# to my local user bin directory.
#
#			(ZSH)
#	path+=('$HOME/bin')
#	export PATH
#
#			(BASH)
#	export PATH="$HOME/bin:$PATH"

# Automatic colorization of man pages.
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Specify a manual file for less command that uses some customized keybinds.
export LESSKEY="${ZSH_PROGRAM_FILTERS}Less/lesskey"

# Setting grep to always use color
#export GREP_OPTIONS="--color=always"

# Adding this for colorized `less` command output via pygmentize.
#export LESS='-R'
#export LESSOPEN='|~/.config/zsh/lessfilter %s'

# Adding this to test PulseAudio forwarding over X11.
#export PULSE_SERVER="tcp:localhost:24713"

####################################################################################################
### ADDING THIS FROM A STACKEXCHANGE POST THAT CONTAINS THE SAME LESS COMMAND COLORS AND CONFIGS ###
###                      https://unix.stackexchange.com/a/147/401241                             ###
####################################################################################################
# Get color support for 'less'
export LESS="--RAW-CONTROL-CHARS"

# Use colors for less, man, etc.
[[ -f "~/.config/zsh/lessfilter" ]] && . "~/.config/zsh/lessfilter"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ -z "$(echo "${PATH}" | grep -o "${HOME}/perl5/bin")" ]] && PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# Adding this in for fuck command (extremely useful correcting previously entered incorrect command.)
eval $(thefuck --alias f)



####################################################################################################
############################### Genearl Environment Variable Exports ###############################
####################################################################################################
#
# Exporting QT and GTK environment variables.
#export QT_QPA_PLATFORMTHEME=qt5ct
# Changing the QT_QPA_PLATFORMTHEME variable to gtk2 as per the arch wiki.
# (Apparently this did the trick, along with installing LXAppearance, and the required
# dependencies.)

#export QT_QPA_PLATFORMTHEME=gtk2
export QT_STYLE_OVERRIDE=kvantum

# The below QT env variable causes issues with the qt5ct program so it is commented out; unless this
# profile is loaded on the Debian-Bitcoin virtual machine since bitcoin-qt requires this environment
# variable to use the QT style correctly.
[[ "$HOST" == "Debian-Bitcoin" || "$HOST_IP" == "192.168.0.1" ]] && \
	export QT_STYLE_OVERRIDE=kvantum

# Adding this global user ENV variable for the documentation program "tldr" (if installed) to set
# color mode to on.
#[[ $(command -v tldr) ]] && 


# Adding directories to the PATH variable.
# (This needs to be cleaned up since there are several PATH declarations already listed above for
# various other programs that need it).
# This PATH addition is for pywal (used for GTK theming).
[[ ! "$(echo "${PATH}" | grep -i "${HOME}/.local/bin/")" ]] && \
	export PATH="${PATH}:${HOME}/.local/bin/"

# Set the path for manual scripts that are more suited to a specific user's bin directory rather
# than a system-wide "/usr/local/bin/" directory.
[[ ! "$(echo "${PATH}" | grep -i "${HOME}/.local/bin/ManualScripts/")" ]] && \
	export PATH="${PATH}:${HOME}/.local/bin/ManualScripts/"

# Sets the XDG environment variables
# (The XDG_CONFIG_HOME variable is already defined in debian's /etc/profile, however it wasn't
# exporting a variable on users since I didn't have an environment variable for XDG_CONFIG_HOME).
# (This XDG_CONFIG_HOME variable SHOULD be set in the ~/.profile, but I'm setting it here).
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_RUNTIME_DIR="/tmp/runtime-${USER}"
#export XDG_CACHE_HOME="${HOME}/.cache"
#export XDG_DATA_DIRS="${PATH}"

# Environment variables used to configure ffmpeg-bar display settings.
# 	https://github.com/sidneys/ffmpeg-progressbar-cli
#BAR_FILENAME_LENGTH=7
#BAR_BAR_SIZE_RATIO=0.5

# Adding this option on [11-2-2021 9:30AM] because for some reason (presumably something to do with
# either FZF change or ZSH autocompletion or another ZSH plugin interfering), something is
# preventing neovim from being able to <C-r> (aka, "Redo" after an <u> "Undo") and this solution was
# found on the fzf github issues.
[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'

# Adding this to ZSHRC file to make sure that Ruby has the proper GEM_HOME and PATH since during
# original installation (installing dependencies, namely: "ruby-jquery-ui-rails=6.0.1+dfsg-6" to be
# able to install OBS which is a prerequisite/build-dependency for glava).
# [When looking into these directories there was no bin directory, so I changed the group of the
# /var/lib/gems directories to one I was a part of and gave the group write permissions so I have
# less likelyhood of messing something up with only a group change].
[[ "$(command -v ruby)" ]] && \
	export GEM_HOME="$(ruby -e 'puts Gem.user_dir')" && \
	[[ ! "$(echo "${PATH}" | grep -i "${GEM_HOME}/bin")" ]] && \
		export PATH="$PATH:$GEM_HOME/bin"

# For whatever reason, when installing programs with the Rust package manager "cargo" as a non-root
# user, running a "cargo install <PACKAGE_NAME>" command results in an error:
# "error: failed to fetch `URL`" "Caused by: error reading from the zlib stream; class=Zlib (5)"
# (However I am convinced this is just some permissions issue cargo is running into issues with; but
# for the time being, I am adding the root user's ".cargo" directory ["/root/.cargo/"] to the $PATH
# variable--only if not already present, which would be the case if already logged in as root user,
# wherein sudo doesn't count as it doesn't modify env variables/values.
#
# Both this .zshrc file (as well as the other ZSH config files), and the one used by root user have
# a line that adds "${HOME}/.cargo/bin" to the "$PATH" env variable; and since cargo sometimes
# throws errors listed above and needs sudo/root user to install packages, this will check if
# "~/.cargo/bin" is in the "$PATH" env variable for the current user and root user (if not logged in
# as root).
#
# First checks if not logged into root account, then checks that the "~/.cargo/bin" (User) directory
# exists, and if so proceed to check that the directory is not already present in the $PATH env
# variable, lastly exporting the $PATH env variable with the "~/.cargo/bin" directory appended.
[[ "$EUID" -ne 0 ]] && \
	[[ -d "${HOME}/.cargo/bin" ]] && \
	[[ ! "$(echo "${PATH}" | grep "${HOME}/.cargo/bin")" ]] && \
		export PATH="${PATH}:${HOME}/.cargo/bin"
# Checks if the root user's ".cargo/bin" is in the current env "$PATH" variable; if not, then append
# it to current working "$PATH" env variable.
[[ ! "$(echo "${PATH}" | grep "/root/.cargo/bin")" ]]  && \
	export PATH="${PATH}:/root/.cargo/bin"

####################################################################################################
## Installing and sourcing various ZSH Plugins (downloading and installing if not already present ##
####################################################################################################
# Set a global environment variable for the default ZSH Plugin directory. Create directory if not
# already present.
export ZSH_PLUGINS="$ZDOTDIR/Plugins"
[[ ! -d "$ZSH_PLUGINS" ]] && mkdir -p "$ZSH_PLUGINS"

# Sourcing various ZSH plugins.
# "Znap" - ZSH plugin manager
#source "$ZSH_PLUGINS/zsh-snap/install.zsh"

# ZSH-Syntax-Highlighting for a Fish shell-like syntax highlighting.
[[ -f "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]] && \
	source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
[[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
	source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ZSH-Navigation-Tools.
[[ -f "$ZSH_PLUGINS/.oh-my-zsh/plugins/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh" ]] && \
	source "$ZSH_PLUGINS/.oh-my-zsh/plugins/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh"

### [Commenting this one out because it was EXTREMELY irritating (and I'm too lazy to remove it at
### this point since it doesn't even matter when porting this config file to other hosts anyways].
#
# ZSH-Auto-Suggestions for automatically showing suggestions in the terminal.
#	[[ -f "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]] && \
#		source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

# zsh-autosuggestions configuration.
#bindkey '\t' end-of-line
#bindkey '^[d' autosuggest-accept
#zstyle ':completion:*' special-dirs true
#zstyle ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'

# [This is the reply from this thread on how to tab-complete case-insensitive matches]:
# 	https://stackoverflow.com/a/24237590
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# As of [5-28-2022 !2:20PM] (or at least the time I noticed, zsh tab autocompletion has stopped
# working, and still using the same stackoverflow thread listed above, however using the answer
# below it with the green check mark



# Source the plugins.
plugins=(
	#zsh-autosuggestions
	zsh-syntax-highlighting
	zsh-navigation-tools
)

# Function to more easily manage plugins by containing all of them inside this function.
#function GETPLUGINS(){
#	# Verify that git is installed, if it isn't then just exit the function without error, and
#	# logging into $ZDOTDIR/Plugin-Error.log with a brief error message.
#	[[ ! $(command -v git) ]] && echo -e "[`date`]:\nGit program is missing, please install it." \
#		&& exit 0

	# Create a git command that takes n number of arguments passed to this function that are
	# interpreted as options to "git clone" command, with the last argument being/assumed-to-be the
	# remote git repository URL.
	# Create local function variables that contain the various elements to each git clone command
	# with variable length amount of options for the command, and using the repository name as the
	# name for the output/download directory in the $ZSH_PLUGINS directory. Checks if plugins are
	# already present; if they are, skip them; if not then download and install them.
	#	local GIT_URL="${@: -1}"
	#	local GIT_OPTIONS="${@:1:$#-1}"
	#	local GIT_REPO_NAME="$(basename -s .git "${GIT_URL}")"

	# Check if the ZSH plugin manager "zsh-snap" is installed; install if not.
	#	[[ ! -d "$ZSH_PLUGINS/zsh-snap" ]] && \
	#		git clone --depth 1 -- https://github.com/marlonrichert/zsh-snap.git \
	#		"$ZSH_PLUGINS/zsh-snap"
	
	# Load zsh-syntax-highlighting; should be last.
	#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
	#	[[ ! git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
	#	source ~/.config/zsh/.oh-my-zsh/
#}

# Temporarily adding this below line to maybe fix an issue of the $DISPLAY variable being set to
# weird things; perhaps it happens whilst opening an X11 (forwarded from server to sink on Windows
# 19) via a daemon that allows X11 programs to be executed remotely but viewed and interacted with
# locally in conflicting machines.
export DISPLAY=192.168.1.30:0.0

. "$HOME/.local/bin/env"
