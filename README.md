dotfiles
========

This repository contains my configuration files and manual provisioning checklists.

As a consultant in a regulated industry, I don't have much control over which operating systems I will be asked to use or what development tools are permitted, so I have learned to pick my battles. I also need to get up to speed quickly.

The goal is to collect a superset of configurations for common tools and pair them with provisioning checklists so that I can get up and running on a new system in 90 minutes or less.

minimum acceptable environment
------------------------------

I can't do my work without:

- vim/neovim or IDE plugin
- ability to remap capslock to escape
- pandoc
- shell scripting

I prefer to have the following:

- PDF viewer
- terminal emulator
- keyboard-focused browser
- keyboard-focused window manager
- version control system
- application launcher
- keyboard remapper / hotkey tool

Many tools are good enough, even if I would prefer a specific one.

overview of provisioning
------------------------

After many employers and systems, I have settled on the following five principles for setting up and using a computer effectively:

### 1. create obvious boundaries betweek work and personal data, public and private data

I don't put work data on personal devices, but it is inevitable that personal data (like tax forms, bookmarks, and so on) ends up on work devices. I use explicit `work/` and `personal/` folders and within them `public/` and `private/` to make it clear which things could be on the internet (like my personal wiki or conference talks) and which things are personal-private or corporate intellectual property.

### 2. make backups easy even at the expense of restoring from them

I like to create one master folder that contains everything important so that backups are trivial. If files need to appear in specific places, like for configuration, I manually symlink them or source them. This is annoying, but it means my "backups" are painless and portable to other operating systems.

### 3. routine tasks should be effortless

I focus on writing scripts and macros when it adds daily value.

### 4. leave breadcrumbs to resume

The nature of my personal and work endeavors is that I never really know when a project will be on hold for months. I add `README.md` files everywhere to track daily state so that it is much easier to ramp on or off some project.

### 5. discoverability is critical

I go above and beyond to try and make my files as full-text searchable as possible so that I can `grep` around for what I'm looking for. This includes using tools like pandoc, LaTeX, or typst for searchable documents and presentations. I also try to make my file heirarchies human-usable.

neovim configuration
--------------------

My neovim configuration is the most complex. Here are some notes documenting the "features" I have added.

- a minimimal set of plugins managed with Lazy including:
    - several classic tpope plugins
    - several fzf plugins
    - vim-wordy, for spotting weasel words and jargon
    - vimwiki and vim-zettel for personal wiki
    - blink, conform, and which-key
    - mason and mason-lspconfig with LSPs for C/C++, CMake, Python
- a custom "utils" plugin I'm working on to handle cross-platform concerns
- a custom "provisioning" plugin I'm working on to check for common binaries like pandoc and fzf
- a custom quick navigation plugin I'm working on to jump to common files I use
    - how-to
    - links and learnings
    - vim configuration
- an elaborate vimwiki and vimzettel configuration featuring:
    - markdown syntax
    - private, zettelkasten, writings, content reviews, and recipe wikis
    - changes to the search behavior for inter-wiki links
    - changes to the default zettelkasten template
    - autocommand to auto-update the last-modified timestamp in zettelkasten notes
