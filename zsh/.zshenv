# ~/.zshenv — the first file zsh reads, for EVERY zsh (scripts included).
#
# This file must live at $HOME; zsh has no way to find it anywhere else.
# Its only job is to point zsh at the real config directory, so keep it tiny —
# anything here also runs for non-interactive scripts and `ssh host cmd`.

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
