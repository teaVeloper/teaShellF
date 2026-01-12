# ~/.profile

# Minimal XDG defaults
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_STATE_HOME

# Teagarden root fallback
: "${TEAGARDEN_HOME:=$HOME/src/teagarden}"
export TEAGARDEN_HOME

# Source contract
if [ -f "$XDG_CONFIG_HOME/teagarden/env.sh" ]; then
  . "$XDG_CONFIG_HOME/teagarden/env.sh"
elif [ -f "$TEAGARDEN_HOME/teashellf/dotfiles/shell/env.sh" ]; then
  . "$TEAGARDEN_HOME/teashellf/dotfiles/shell/env.sh"
fi

