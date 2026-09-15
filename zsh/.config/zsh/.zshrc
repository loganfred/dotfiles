# $ZDOTDIR/.zshrc — interactive shells only.
#
# Load order: ~/.zshenv -> .zprofile (login) -> .zshrc (interactive).
# PATH and exports that scripts need go in .zprofile, not here.
#
# Sections: environment, history, options, completion, vi mode, fzf, prompt,
# aliases, optional plugins, local overrides.

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim

# -F: don't page if it fits on one screen.  -R: pass through colors.
# -X: don't wipe the screen on exit, so output stays in scrollback.
export PAGER=less
export LESS='-FRX'
export MANPAGER='nvim +Man!'

# Read by nvim/lua/config/vimwiki.lua. $HOME, not a hardcoded username, so this
# works on both the mac and the Arch box.
export VIMWIKI_PATH="$HOME/vimwiki"

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
# HISTFILE stays in $HOME on purpose: $ZDOTDIR is a symlink into the dotfiles
# repo, and shell history must never end up staged for commit.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000   # lines held in memory for this session
SAVEHIST=50000   # lines written out to $HISTFILE

setopt EXTENDED_HISTORY     # save timestamp + duration with each command
setopt SHARE_HISTORY        # live sync across shells — worth it since you use tmux
setopt HIST_IGNORE_ALL_DUPS # drop older copies of a repeated command; keeps Ctrl-R clean
setopt HIST_IGNORE_SPACE    # a leading space keeps a command out of history entirely
setopt HIST_REDUCE_BLANKS   # normalise whitespace before saving
setopt HIST_VERIFY          # !! / !$ expand onto the line for review instead of running

# ---------------------------------------------------------------------------
# Shell options
# ---------------------------------------------------------------------------
setopt AUTO_CD              # bare `foo` cds into ./foo
setopt AUTO_PUSHD           # cd builds a directory stack; see `dirs -v` and `cd -<TAB>`
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB        # ^negation, glob qualifiers like *(.om[1]) — used below
setopt INTERACTIVE_COMMENTS # allow trailing # comments when typing interactively
setopt NO_BEEP
setopt NO_FLOW_CONTROL      # frees Ctrl-S / Ctrl-Q for keybindings

# ---------------------------------------------------------------------------
# Completion
# ---------------------------------------------------------------------------
zmodload zsh/complist       # provides the menuselect keymap used below
autoload -Uz compinit

# Rebuild the completion dump at most once a day; otherwise trust the cache
# (-C skips the security audit of $fpath, which is the slow part of startup).
# The dump goes under $XDG_CACHE_HOME so it never lands inside the repo.
_zdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"
[[ -d ${_zdump:h} ]] || mkdir -p "${_zdump:h}"
if [[ -n ${_zdump}(#qNm-1) ]]; then   # (#qN) = no error if absent, m-1 = modified <1 day
	compinit -C -d "$_zdump"
else
	compinit -d "$_zdump"
fi
unset _zdump

zstyle ':completion:*' menu select                       # interactive menu instead of a dump
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive matching
zstyle ':completion:*' group-name ''                     # group results by category
zstyle ':completion:*:descriptions' format '%F{blue}%d%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # color the menu like ls
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ':completion:*' special-dirs true                 # offer ../ and ./
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Move through the completion menu with hjkl, to match vi mode.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# uv ships a native zsh completion script, so no bashcompinit needed.
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)"

# ---------------------------------------------------------------------------
# Vi mode
# ---------------------------------------------------------------------------
bindkey -v      # same as `set -o vi`, but must run BEFORE fzf so fzf layers on top
KEYTIMEOUT=1    # 10ms, not the default 400ms — removes the lag after pressing ESC

# NORMAL-mode `v` drops the current command line into nvim; :wq runs it, :q! aborts.
# This overrides zsh's default `v` (visual-mode), which is the trade you asked for.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Vi insert mode drops several editing keys that are hard to live without.
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^K' kill-line
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^?' backward-delete-char  # let backspace cross where insert started
bindkey -M viins '^H' backward-delete-char

# History search filtered by what you have already typed: type `git ` then k.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins '^P' up-line-or-beginning-search
bindkey -M viins '^N' down-line-or-beginning-search
bindkey -M vicmd 'k' up-line-or-beginning-search
bindkey -M vicmd 'j' down-line-or-beginning-search

# Block cursor in NORMAL, thin beam in INSERT, so the mode is always visible.
_vi_cursor() {
	case $KEYMAP in
	vicmd) print -n '\e[2 q' ;;
	*) print -n '\e[5 q' ;;
	esac
}
zle -N zle-keymap-select _vi_cursor
_vi_line_init() {
	zle -K viins # always start a new line in INSERT
	_vi_cursor
}
zle -N zle-line-init _vi_line_init
precmd_functions+=(_vi_cursor) # reset the cursor after a command exits

# ---------------------------------------------------------------------------
# fzf — Ctrl-R history, Ctrl-T file insert, Alt-C cd
# ---------------------------------------------------------------------------
# fd respects .gitignore and skips .git, which is almost always what you want.
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border --info inline'

# Ctrl-T: insert a file path at the cursor, previewed with bat.
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"

# Ctrl-R: fuzzy history. Long pipelines get truncated in the list, so ? toggles
# a wrapped preview of the full command. {2..} skips the timestamp column.
export FZF_CTRL_R_OPTS="--preview 'echo {2..}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

# Alt-C: cd into a subdirectory.
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'ls -1 {}'"

# fzf >= 0.48 emits its own integration, which replaces hunting for
# key-bindings.zsh by path — that path differs across Homebrew, MacPorts and Arch.
command -v fzf >/dev/null && source <(fzf --zsh)

# ---------------------------------------------------------------------------
# Prompt
# ---------------------------------------------------------------------------
# zsh's built-in vcs_info is enough for a branch name; no external prompt needed.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{yellow}%b%f'
zstyle ':vcs_info:git:*' actionformats ' %F{yellow}%b%f %F{red}%a%f'
precmd_functions+=(vcs_info)
setopt PROMPT_SUBST
# cwd, git branch, then % — turning red if the last command failed.
PROMPT='%F{cyan}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})%#%f '

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias v=nvim
alias vi=nvim

# GNU coreutils (Arch) and BSD (macOS) disagree here. Probe the full flag set,
# not just --color: recent macOS ls accepts --color but not
# --group-directories-first, so testing only the former picks the wrong branch.
if ls --color=auto --group-directories-first . >/dev/null 2>&1; then
	alias ls='ls --color=auto --group-directories-first'
else
	alias ls='ls -G'
fi
alias ll='ls -lh'
alias la='ls -lAh'

alias rgh='rg --hidden --glob=!.git' # search dotfiles too
alias fda='fd --hidden --no-ignore'  # ignore .gitignore, find everything

alias gs='git status --short --branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'

alias ..='cd ..'
alias ...='cd ../..'

# Re-link a package after editing it, e.g. `restow nvim`. $DOTFILES is set in .zprofile.
alias restow='stow -R -d "$DOTFILES"'

# ---------------------------------------------------------------------------
# Optional plugins — activate only if installed
#   brew install zsh-autosuggestions zsh-syntax-highlighting
#   pacman -S zsh-autosuggestions zsh-syntax-highlighting
# ---------------------------------------------------------------------------
_src_first() {
	local f
	for f in "$@"; do
		[[ -r $f ]] && source "$f" && return 0
	done
	return 1
}

# Ghosted grey suggestion from history; Ctrl-Space accepts it.
if _src_first \
	/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
	/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh; then
	bindkey -M viins '^ ' autosuggest-accept
fi

# Must be sourced last: it wraps every widget defined before it.
_src_first \
	/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
	/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unfunction _src_first

# ---------------------------------------------------------------------------
# Machine-specific, untracked
# ---------------------------------------------------------------------------
[[ -r $ZDOTDIR/.zshrc.local ]] && source "$ZDOTDIR/.zshrc.local"
