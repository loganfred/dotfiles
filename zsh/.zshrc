autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
eval "$(uv generate-shell-completion zsh)"
source /opt/local/share/fzf/shell/key-bindings.zsh

export VIMWIKI_PATH=/Users/loganf/vimwiki
