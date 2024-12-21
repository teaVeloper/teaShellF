# history plugin
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE

# ---  Prevent duplicate entries in the history ----
setopt HIST_IGNORE_ALL_DUPS
# When a new command is added to the history, any previous commands matching it are removed.
setopt HIST_FIND_NO_DUPS
# Do not display duplicate entries during completion or searching.
setopt HIST_REDUCE_BLANKS
# Remove superfluous blanks before storing a command in the history.
setopt APPEND_HISTORY
# Append history entries to the history file instead of overwriting it
setopt SHARE_HISTORY
# Share history between all sessions.
setopt INC_APPEND_HISTORY
# Write each command to the history file as it is entered.
setopt HIST_SAVE_NO_DUPS
# Do not write duplicate history entries to the history file.
setopt HIST_IGNORE_DUPS
# Prevents consecutive duplicate entries in the history.
setopt EXTENDED_HISTORY
# This option ensures that each entry in the history file includes a timestamp

# incremental search with up and down as in omz
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
# the below version only uses first command, but ignores later
# bindkey '^[[A' up-line-or-search
# bindkey '^[[B' down-line-or-search
