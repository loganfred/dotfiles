dotfiles
========

NOTE: these files are publicly available for sync purposes and so I can link them on occasion.

I make no effort to ensure they will function properly for others.

arch
----

    sudo pacman -S stow
    git clone https://github.com/loganfred/dotfiles.git ~/source/gh_dotfiles
    cd ~/source/gh_dotfiles
    stow nvim
    stow qutebrowser
    stow git
    stow bash
    nvim -c :Lazy
    nvim -c :Mason

macOS
-----

(see above)

windows: WSL
------------

(see above)

windows: native
---------------

TBD - plan:

- update `windows.json` or `windows.toml` to track paths
- use `deploy.ps1` to copy, ignoring `.config` assumption for `stow`


other ideas
-----------

- zsh, bash, powershell prompt should check hourly if git is out of date
- keep working on provisioning `:checkhealth` plugin in `nivm`: goal is have every tool installed
- include docs from work provisioning tracker
