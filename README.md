dotfiles
========

I used to heavily customize all my computers with the same operating system, tools, custom scripts, and configurations, but over the years my opinions have softened. This could be personal growth or that my industry requires each software tool to be approved, so you learn to pick your battles and to get creative.

I like working with volatile startups and I have my own consulting business, so I do similar work on more unique machines than most people I know.

I don't know what operating system I'll be asked to use next or what tools will be available to me, so these dotfiles are a superset of configuration files with a heavy emphasis on manual provisioning checklists.

ingredients
-----------

I use the following specific tools:

- neovim
- pandoc

And multiple options will work for the rest:

- terminal emulator
- keyboard-focused browser
- keyboard-focused window manager
- PDF viewer
- document converter
- version control system
- application launcher
- keyboard remapper / hotkey tool


provisioning approach
---------------------

I have found these five principles to be the helpful when setting up any new system:

1. create obvious boundaries betweek work and personal data, public and private data
2. make backups easy even at the expense of restoring from them
3. routine things should be effortless
4. leave breadcrumbs to resume
5. searchability is critical

These principles transcend any specific implementation, but here are some notes on my current approach for work systems.

First, I create one master folder and sync it with OneDrive or whatever. Backups done. I add explicit sub-folders for `personal/` and `work/` data and within those ones for `public/` and `private/` data. I tie this folder in with the system using symlinks and config sourcing, which is annoying, but it is well worth the price of how convenient it makes file backups and that I can port any backup to a new operating system.

This is a good example of how I proritize making routine things effortless even if less common things are more awkward. This extends to hotkeys and scripts and pausing and resuming projects. I work on all kinds of things, so I have gotten in the habit of leaving detailed `README.md` files everywhere so it is easier to leave and come back even after months.

I do almost all my computer work in a source code / compiled output paradigm for searchability. I do my documents in `markdown` or `typst` and use `pandoc` to make them into usual office documents. If people share things with me, I convert those too. I will never understand why search indexing on most computers is so terrible, so I design around that problem. And, if everything is plaintext, then everything works great with `vim` or `neovim`.
