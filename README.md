# My `neovim` set up

<div align="center">
  <p>
    <img title="neovim!" height="65px" width="65px" hspace=10 src="https://cdn.simpleicons.org/neovim/6062ba" />
  </p>
</div>

<br>

Started with [glepnir's](https://github.com/glepnir) `cosynvim`, which was recently renamed to `dope` and is now a part of [nvimdev](https://github.com/nvimdev/). There's a big change from using `packer` to `lazy.nvim`, which was interesting to see what changed but a lot of it I didn't really understand because I was just using the framework and not putting it together myself. 

So, I'm gradually moving towards having most of my `~/.config/` as a repo with all dots and config for wezterm, starship, etc that powers my personal development environment all in one place (sort of like [folke's](https://github.com/folke) dots; I like that set up a lot). For now, I've changed the configuration a lot and spent a good deal of time trying to make what I had work in LazyVim with varying degrees of success. 

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

