# PROMPT
PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null || echo "null")'; PS1='\[\e[38;5;45m\][\[\e[38;5;207m\]${PS1_CMD1}\[\e[38;5;45m\]]\[\e[0m\] \[\e[38;5;82m\]\W\[\e[0m\] \[\e[38;5;226m\]\$\[\e[0m\] '

# ENV VARS
export FZF_DEFAULT_COMMAND="fdfind -L -E snap -E go -E win_home -E watchdog_src -E dependency_track -E build -E include -E CMakeFiles"
export EDITOR="nvim"

# OPTIONS
set -o vi

# ALIASES
alias vim=nvim
alias fd=fdfind
alias ls="ls --color"
alias _source="source ~/.bash_profile"
alias _edit="$EDITOR ~/.bash_profile"

# FUNCTIONS
ff() { local selection=$(fzf); [ -n "$selection" ] && { [ -d "$selection" ] && pushd "$selection" > /dev/null || $EDITOR "$selection"; }; }
