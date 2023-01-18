# My neovim set up

<div align="center">
  <p>
    <img title="neovim!" height="65px" width="65px" hspace=10 src="https://cdn.simpleicons.org/neovim/6062ba" />
  </p>
</div>

<br>

Started with [glepnir's](https://github.com/glepnir) `cosynvim`, which was recently renamed to `dope`. There's a big change from using `packer` to `lazy.nvim`, which was interesting to see what changed. I'm gradually moving towards having most of my `~/.config/` as a repo with all dots and config for wezterm, starship, etc that powers my personal development environment all in one place (sort of like [folke's](https://github.com/folke) dots; I like that set up a lot).

## Geting started

### Install neovim

Depending on your OS or distribution you may not have a latest stable release available; it's always
a good idea to check first, otherwise you can grab what you need from the neovim [releases](https://github.com/neovim/neovim/releases) page:

Currently I'm using `Pop!_OS`, and the version of neovim from `apt` isn't recent enough, so for
linux I need to grab it from the repo releases page.

__linux__
```bash
gh --repo neovim/neovim release download stable --pattern='*.deb'
sudo apt install ./nvim-linux64.deb
```

On the macbook pro; can use `homebrew`

__macOS__
```bash
brew install nvim
```

### Clone the repo

Using the GitHub CLI

First make to authenticate

```bash
gh auth login
```

```bash
gh repo clone robertmitchellv/nvim ~/.config/nvim
```

_from `glepnir/dope`:_

## What is dope

Many people are interested in my [personal configuration](https://github.com/glepnir/nvim). So I created dope.

What does dope do? dope wants vimers to have their own config with high performance

fast speed and modernity.

## Structure

```
├── init.lua
├── lua
│   ├── core
│   │   ├── cli.lua
│   │   ├── helper.lua
│   │   ├── init.lua
│   │   ├── keymap.lua
│   │   ├── options.lua
│   │   └── pack.lua
│   ├── keymap
│   │   ├── config.lua
│   │   └── init.lua
│   └── modules
│       ├── completion
│       │   ├── config.lua
│       │   └── package.lua
│       ├── editor
│       │   ├── config.lua
│       │   └── package.lua
│       ├── tools
│       │   ├── config.lua
│       │   └── package.lua
│       └── ui
│           ├── config.lua
│           └── package.lua
├── snippets
│   ├── lua.json
│   ├── lua.lua
│   └── package.json
```

- `core` heart of dope it include the api of dope
- `modlues` plugin module and config in this folder
- `snippets` vscode snippets json file

## Usage

- Click button `Use this template` It will genereate a new repo based on dope on your github

### Cli tool

`bin/dope` is a cli tool for dope config. run `./bin/dope help` check more detail

you can use `/bin/dope debug ui,editor` for debug modues. when you get trouble
this is useful for your debug, this command mean disable `ui editor` modules.Then
the plugins in `ui,editor` modules not load.

## How to install plugins

dope use [lazy.nvim](https://github.com/folk/lazy.nvim) as package mangement plugin. register a plugin in `package.lua` by using dope api `require('core.pack').package`. more useage check the
lazy.nvim doc and you can some examples in package.lua file.

### How to create module

create a fold inside `modlues` folder and `package.lua` file you must created inside your module.
dope will auto read this file at startup.


### How to config keymap

In dope there are some apis that make it easy to set keymap. All apis are defined in `core/keymap.lua`.

```lua
keymap.(n/i/c/v/x/t)map -- function to generate keymap by vim.keymap.set
keymap.new_opts -- generate opts into vim.keymap.set
-- function type that work with keymap.new_opts
keymap.silent keymap.noremap keymap.expr keymap.nowait keymap.remap
keymap.cmd -- just return string with <Cmd> and <CR>
keymap.cu -- work like cmd but for visual map
```

Use these apis to config your keymap in `keymap` folder. In this folder `keymap/init.lua` is necessary but if you

have many vim mode remap you can config them in `keymap/other-file.lua` in dope is `config.lua` just an

example file. Then config plugins keymap in `keymap/init.lua`. the example of api usage

```lua
-- genreate keymap in noremal mode
nmap {
  -- packer
  {'<Leader>pu',cmd('Lazy update'),opts(noremap,silent,'Lazy update')},
   {"<C-h>",'<C-w>h',opts(noremap)},
  
}

also you can pass a table not include sub table to `map` like

```lua
nmap {'key','rhs',opts(noremap,silent)}
```

use `:h vim.keymap.set` to know more about.

## Tips

- Improve key repeat

```
mac os need restart
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

linux
xset r rate 210 40
```

## Licenese MIT
