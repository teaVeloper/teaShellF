bindkey -v
export KEYTIMEOUT=1


zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


# emacs keybindings in insert mode
bindkey '^A' beginning-of-line # C-a
bindkey '^E' end-of-line # C-e

# home and end for beginning and end of line
bindkey '^[[H' beginning-of-line  # Home key
bindkey '^[[F' end-of-line        # End key

# use C-v for loading to vim instead visual mode
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd ^v edit-command-line

# vim commands like da" or ci(
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done


# mimic vim surroung in shell
autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround
# }}}

# incremental search with up and down as in omz
# bindkey "^[[A" history-beginning-search-backward
# bindkey "^[[B" history-beginning-search-forward
# the below version only uses first command, but ignores later
# bindkey '^[[A' up-line-or-search
# bindkey '^[[B' down-line-or-search



# TODO: completion config in completion plugin?
# not to mix up completions with completion config...
#
# ------ Completion bindkeys ---------
#
# Map Ctrl+N to menu complete next (like Tab)
bindkey '^N' menu-select

# Map Ctrl+P to menu complete previous (like Shift+Tab)
bindkey '^P' reverse-menu-complete

