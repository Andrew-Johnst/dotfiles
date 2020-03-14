# Luke's config for the Zoomer Shell

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[cyan]%}%n%{$fg[gray]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# If existent, oads (shortcuts, aliases, and functions) rc files located within ~/.config/zsh directory.
[ -f "$HOME/.config/zsh/shortcutrc" ] && source "$HOME/.config/zsh/shortcutrc"
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

# Apparently, despite countless warnings online against exporting TERM variable in shell profile,
# this is what fixed it lol. (Have yet to start new SSH instance, or X11 session however).
export TERM=xterm-24bit


# Setting DISPLAY varriable for X11 forwarding
# Too braindead to understand if im supposed to define DISPLAY on host or client, commenting out for now.
#export DISPLAY=:0.0

# Fuzzy Finder settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

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
