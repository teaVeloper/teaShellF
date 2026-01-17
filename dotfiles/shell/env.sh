# dotfiles/shell/env.sh
# Base environment contract (POSIX sh friendly).
# Safe to source from zsh, bash, and provisioning scripts.

# ---- XDG Base Directory Spec ----
: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"
: "${XDG_STATE_HOME:=$HOME/.local/state}"
# XDG_RUNTIME_DIR is system/session-managed; don't force it here.

export XDG_CONFIG_HOME XDG_DATA_HOME XDG_CACHE_HOME XDG_STATE_HOME

# ---- Teagarden roots (hierarchical defaults) ----
: "${TEAGARDEN_HOME:=$HOME/src/teagarden}"
export TEAGARDEN_HOME

# The dotfiles repo lives inside the garden by contract.
: "${TEASHELLF_HOME:=$TEAGARDEN_HOME/teashellf}"
export TEASHELLF_HOME

# The actual config payload lives in teashellf/dotfiles (your new structure).
: "${DOTFILES_HOME:=$TEASHELLF_HOME/dotfiles}"
export DOTFILES_HOME

# Optional: convenience alias variable (for humans, not required by tooling)
: "${DOTS:=$DOTFILES_HOME}"
export DOTS

# ---- Editor defaults ----
: "${EDITOR:=nvim}"
: "${VISUAL:=$EDITOR}"
export EDITOR VISUAL

: "${MANPAGER:=nvim +Man!}"
export MANPAGER

# inputrc
: "${INPUTRC:=$XDG_CONFIG_HOME/readline/inputrc}"
export INPUTRC


# ---- PATH (minimal + clean) ----
# Keep this conservative; add language toolchains in shell-specific files if needed.
# Ensure user-local bin is early.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) PATH="$HOME/.local/bin:$PATH" ;;
esac
case ":$PATH:" in
  *":$HOME/bin:"*) ;;
  *) PATH="$HOME/bin:$PATH" ;;
esac

# Cargo/go can be optional; include only if dirs exist to avoid junk PATH.
: "${CARGO_HOME:=$XDG_DATA_HOME/cargo}"
: "${RUSTUP_HOME:=$XDG_DATA_HOME/rustup}"
export CARGO_HOME RUSTUP_HOME
if [ -d "$CARGO_HOME/bin" ]; then
  case ":$PATH:" in *":$CARGO_HOME/bin:"*) ;; *) PATH="$CARGO_HOME/bin:$PATH" ;; esac
fi

: "${GOPATH:=$XDG_DATA_HOME/go}"
export GOPATH
if [ -d "$GOPATH/bin" ]; then
  case ":$PATH:" in *":$GOPATH/bin:"*) ;; *) PATH="$GOPATH/bin:$PATH" ;; esac
fi

export PATH

