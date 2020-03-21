# Setup fzf
# ---------
if [[ ! "$PATH" == */home/drew/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/drew/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/drew/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/drew/.fzf/shell/key-bindings.zsh"
