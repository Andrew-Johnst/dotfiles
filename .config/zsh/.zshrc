# Exports the ZDOTDIR into ~/.config/zsh rather than cluttering up the home directory wtih dotfiles.
#export ZDOTDIR="$HOME/.config/zsh"
# Exports the oh-my-zsh directory.
#export ZSH="$HOME/.config/zsh/.oh-my-zsh"
 # [Using the oh-my-zsh plugin (make sure to push current changes before doing so, just in case
 # something breaks.]
#export ZSH="$HOME/.config/zsh/.oh-my-zsh"

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[cyan]%}%n%{$fg[gray]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

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
ShellShortcutDir="$HOME/.config/zsh/Shell-Helpers/"
[ -d "$ShellShortcutDir" ] && \
	for f in ${ShellShortcutDir}*; do source "$f"; done && \
	export ZSH_AFRC="$HOME/.config/zsh/Shell-Helpers/"

# If the Shell-Helpers directory is not present, then export ZSH environment variable to the
# previous location for the ZSH shell helper scripts--like aliasrc and functionrc.
[ ! -d "$ShellShortcutDir" ] && \
	export ZSH_AFRC="$HOME/.config/zsh/"

# Check if there is a directory named "Filters" in the main "$ZDOTDIR" directory path, export an
# environment variable "ZSH_PROGRAM_FILTERS" if so.
[ -d "$ZDOTDIR/Filters/" ] && \
	export ZSH_PROGRAM_FILTERS="$ZDOTDIR/Filters/"

# This automatically allows ZSH to determine if a link has been pasted into the terminal/shell and
# automatically handles the special characters appropriately by escaping them.
# [Link]: https://forum.endeavouros.com/t/tip-better-url-pasting-in-zsh/6962
autoload -U url-quote-magic bracketed-paste-magic
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -U compinit
zstyle ':completion:*' menu select
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
preexec() { echo -ne '\e[5 q' ;}

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
# bindkey -s '^o' 'lfcd\n'		# ZSH (lfcd is a function provided for common shells used to change
# the pwd on quit).
bindkey '^[f' vi-cmd-mode					# Binds <M-F> to return to vi normal mode (<Esc>) 
											# becuase I'm lazy.
bindkey -s '^[l' '^L'						# Binds <M-L> to clear screen (added for easier screen
											# clearing in tmux.
autoload -U edit-command-line				# Load the required zsh module to allow editing the
zle -N edit-command-line					# current command in a tmp file with $EDITOR.
bindkey -M vicmd '^[v' edit-command-line	# Binds <M-v> to edit the command-line in a vim buffer.

# Not sure if this will have much effect since tmux prolly captures special keycombos like this and
# would take precedence since they already do with <C-L> and clear command.
bindkey 	'^['	delete-char

# This fixes the issue of pressing the numberpad/tenkey "Enter" key while "Number Lock" is not
# enabled (which inserts an "OM" instead of a Carriage Return).
bindkey	'^[OM'	accept-line



# Manual environment variables.
export EDITOR=nvim
export FILEMANAGER=pcmanfm-qt

# Apparently, despite countless warnings online against exporting TERM variable in shell profile,
# this is what fixed it lol. (Have yet to start new SSH instance, or X11 session however).
# Removing this for now.
export TERM=xterm-256color
#export TERM=mintty

# Checks whether or not the current session is from SSH, exports the DISPLAY variable to the IP
# address of the SSH client if so, and if the current session doesn't appear to originate from an
# SSH session, it will default to setting the DISPLAY variable to the standard (on-board/localhost)
# display address.
#if [[ -n "$SSH_CONNECTION" ]]
if [ -e "$SSH_CLIENT" ] || [ -e "$SSH_TTY" ] || [ -e "$SSH_CONNECTION" ]
then
    DISPLAY="$(echo $SSH_CLIENT | awk '{print $1}'):0.0"
    SSH_CLIENT_IP="$(echo $SSH_CLIENT | awk '{print $1}')"
    # Old variable export that defaulted to my desktop IP.
    #DISPLAY=192.168.1.30:0.0
	
	# This defaults to the current $SSH_CONNECTION IP address; this is used while accessing from WAN
	# and utilizing X11Forwarding through connection to the NAS's LAN via connecting to
	# AsusWRT-Merlin (OpenVPN Server)'s LAN.
	# (This below line for whatever reason only as of 8-7-2021 started setting the DISPLAY to the
	# default gateway [192.168.1.1] so commenting this out since the first word in $SSH_CONNECTION
	# is the default gateway).
    #	DISPLAY="$(echo $SSH_CONNECTION | awk '{print $1}'):0.0"
    # Below conditional checks to see if current SSH Client IP address has valid IPv4 address
    # (general IP check).
    #[[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} ]] &&
    # Below conditional checks to see if network is on "192.168.1.0/24" network.
    #[[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.1\.[0-9]\{1,3\} ]]
	# Below conditional checks to see if current network interface LAN IP is on 192.168.200.0/24
	# subnet ("Temporary" subnet/network for KVM virtual-network until I setup subnetting/VLANs with
	# Cisco router and switch).
    [[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.0\.[0-9]\{1,3\} ]] && \
        export DISPLAY="$SSH_CLIENT_IP:0.0"
        #export DISPLAY="192.168.1.30:0.0"
    #export DISPLAY="192.168.1.30:0.0"

	# (8-7-2021)
	
	# Sets OpenGL rendering to indirect, meant for rendering over network.
	# https://unix.stackexchange.com/questions/1437/what-does-libgl-always-indirect-1-actually-do
	export LIBGL_ALWAYS_INDIRECT=1
else
	export DISPLAY=:0
fi
# Change later (1-8-21 8:41PM).
#DISPLAY="192.168.1.30:0.0"
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

# Prolly a better way to do this but doing this as a temporary fix for WSL starting directory when a
# new session is started. Doing a check for if root or not since that might not be preferable to cd
# into the root dir when switching to root user.
[[ "$HOST" == "Drew-PC" && "$EUID" -ne 0 ]] && cd

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
export LESSKEY="$ZSH_PROGRAM_FILTERS/Less/lesskey"

# Setting grep to always use color
#export GREP_OPTIONS="--color=always"

# Adding this for colorized `less` command output via pygmentize.
#export LESS='-R'
#export LESSOPEN='|~/.config/zsh/lessfilter %s'

# Adding this to test PulseAudio forwarding over X11.
#export PULSE_SERVER="tcp:localhost:24713"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
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
export QT_QPA_PLATFORMTHEME=gtk2
# The below QT env variable causes issues with the qt5ct program so it is commented out; unless this
# profile is loaded on the Debian-Bitcoin virtual machine since bitcoin-qt requires this environment
# variable to use the QT style correctly.
[[ "$HOST" == "Debian-Bitcoin" || "$HOST_IP" == "192.168.0.1" ]] && \
	export QT_STYLE_OVERRIDE=kvantum


# Adding directories to the PATH variable.
# (This needs to be cleaned up since there are several PATH declarations already listed above for
# various other programs that need it).
# This PATH addition is for pywal (used for GTK theming).
export PATH="${PATH}:${HOME}/.local/bin/"

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
source "$ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

# ZSH-Navigation-Tools.
source "$ZSH_PLUGINS/.oh-my-zsh/plugins/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh"

# ZSH-Auto-Suggestions for automatically showing suggestions in the terminal.
#source "$ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
#
# zsh-autosuggestions configuration.
#bindkey '\t' end-of-line
#bindkey '^[d' autosuggest-accept
#zstyle ':completion:*' special-dirs true
zstyle ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'



# Source the plugins.
plugins=(
	#zsh-autosuggestions
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
