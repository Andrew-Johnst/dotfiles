# Exports the ZDOTDIR into ~/.config/zsh rather than cluttering up the home directory wtih dotfiles.
export ZDOTDIR="$HOME/.config/zsh"
# Exports the oh-my-zsh directory.
#export ZSH="/home/drew/.config/zsh/.oh-my-zsh"
 # [Using the oh-my-zsh plugin (make sure to push current changes before doing so, just in case
 # something breaks.]
export ZSH="/home/drew/.config/zsh/.oh-my-zsh"

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[cyan]%}%n%{$fg[gray]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# If existent, loads alias and function rc files located within ~/.config/zsh directory.
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"
[ -f "$HOME/.config/zsh/functionrc" ] && source "$HOME/.config/zsh/functionrc"

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

# Keybinds.
# bindkey -s '^o' 'lfcd\n'		# ZSH (lfcd is a function provided for common shells used to change the pwd on quit).
bindkey 	'^[f'	vi-cmd-mode		# Binds <M-F> to return to vi normal mode (<Esc>) becuase I'm lazy.
bindkey -s 	'^[l'	'^L'			# Binds <M-L> to clear screen (added for easier screen-clearing in tmux.
# Not sure if this will have much effect since tmux prolly captures special keycombos like this and would take precedence
# since they already do with <C-L> and clear command.
bindkey 	'^['	delete-char



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
if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]
then
    DISPLAY="$(echo $SSH_CONNECTION | awk '{print $1}'):0.0"
    SSH_CLIENT_IP="$(echo $SSH_CONNECTION | awk '{print $1}')"
    # Old variable export that defaulted to my desktop IP.
    DISPLAY=192.168.1.30:0.0
    # Below conditional checks to see if current SSH Client IP address has valid IPv4 address
    # (general IP check).
    #[[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\} ]] &&
    # Below conditional checks to see if network is on "192.168.1.0/24" network.
    #[[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.1\.[0-9]\{1,3\} ]]
	# Below conditional checks to see if current network interface LAN IP is on 192.168.200.0/24
	# subnet ("Temporary" subnet/network for KVM virtual-network until I setup subnetting/VLANs with
	# Cisco router and switch).
    [[ "$SSH_CLIENT_IP" =~ ^[0-9]\{1,3\}\.[0-9]\{1,3\}\.200\.[0-9]\{1,3\} ]] && \
        DISPLAY="192.168.1.30:0.0"
    export DISPLAY

	# Sets OpenGL rendering to indirect, meant for rendering over network.
	# https://unix.stackexchange.com/questions/1437/what-does-libgl-always-indirect-1-actually-do
	export LIBGL_ALWAYS_INDIRECT=1
else
	export DISPLAY=:0
fi
# Change later (1-8-21 8:41PM).
DISPLAY="192.168.1.30:0.0"

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


# Fuzzy Finder settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Manually added options.


# Add this to the zshrc file if required to login to ACC system, so that programs can be installed
# to my local user bin directory.
#
#			(ZSH)
#	path+=('/home/drew/bin')
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

# Setting grep to always use color
#export GREP_OPTIONS="--color=always"

# Adding this for colorized `less` command output via pygmentize.
#export LESS='-R'
#export LESSOPEN='|~/.config/zsh/lessfilter %s'

# Adding this to test PulseAudio forwarding over X11.
#export PULSE_SERVER="tcp:localhost:24713"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/drew/.sdkman"
[[ -s "/home/drew/.sdkman/bin/sdkman-init.sh" ]] && source "/home/drew/.sdkman/bin/sdkman-init.sh"

PATH="/home/drew/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/drew/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/drew/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/drew/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/drew/perl5"; export PERL_MM_OPT;

# Adding this in for fuck command (extremely useful correcting previously entered incorrect command.)
eval $(thefuck --alias f)

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
