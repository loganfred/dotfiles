# $ZDOTDIR/.zprofile — login shells only. PATH and environment belong here.
#
# IMPORTANT: because .zshenv sets ZDOTDIR, zsh reads THIS file instead of
# ~/.zprofile. Anything an installer appends to ~/.zprofile from now on will be
# silently ignored, so move it here.

# --- MacPorts (first, so Homebrew below takes precedence) -------------------
[[ -d /opt/local/bin ]] && export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# --- Homebrew: Apple Silicon, Intel, then Linuxbrew ------------------------
# Also puts brew's completions on $fpath, which is why this must run before
# compinit in .zshrc. Login shells load .zprofile first, so that holds.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
	if [[ -x $_brew ]]; then
		eval "$("$_brew" shellenv)"
		break
	fi
done
unset _brew

# --- XDG base directories ---------------------------------------------------
# Exported so tools that honour them agree with where this repo stows configs.
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

[[ -d $HOME/.local/bin ]] && export PATH="$HOME/.local/bin:$PATH"

# Where this repo is checked out. Override in .zprofile.local on a machine that
# clones it somewhere else; the `restow` alias in .zshrc reads it.
export DOTFILES="${DOTFILES:-$HOME/gh/dotfiles}"

# --- Machine-specific, untracked -------------------------------------------
[[ -r $ZDOTDIR/.zprofile.local ]] && source "$ZDOTDIR/.zprofile.local"
