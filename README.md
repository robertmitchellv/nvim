# My 💤 LazyVim `neovim` set up

<div align="center">
  <p>
    <img title="neovim!" height="65px" width="65px" hspace=10 src="https://cdn.simpleicons.org/neovim/6062ba" />
  </p>
</div>

<br>

Started with [glepnir's](https://github.com/glepnir) `cosynvim`, which was recently renamed to `dope` and is now a part of [nvimdev](https://github.com/nvimdev/). There was a big change from using `packer` a while back to `lazy.nvim`, which was interesting to work through but a lot of it I didn't really understand because I was just using the framework and not putting it together myself.

So, I'm gradually moving towards having most of my `~/.config/` as a repo with all dots and config for wezterm, starship, etc that powers my personal development environment all in one place (sort of like [folke's](https://github.com/folke) dots; I like that set up a lot). For now, I've changed the configuration a lot and spent a good deal of time trying to make what I had work in LazyVim with varying degrees of success.

## Geting started

### Install neovim

Depending on your OS or distribution you may not have a latest stable release available; it's always
a good idea to check first, otherwise you can grab what you need from the neovim [releases](https://github.com/neovim/neovim/releases) page:

Currently I'm using `Pop!_OS`, and the version of neovim from `apt` isn't recent enough, so for
linux I need to grab it from the repo releases page.

**linux**

```bash
gh --repo neovim/neovim release download stable --pattern='*.deb'
sudo apt install ./nvim-linux64.deb
```

**update on linux**

```bash
      update-neovim() {
        # Get the installed version of neovim
        local installed_version=$(nvim --version | head -n 1 | awk '{print $2}')

        # Get the latest release version of neovim from GitHub
        local latest_release=$(gh --repo neovim/neovim release view --json tagName,name)
        local latest_version_name=$(echo "$latest_release" | jq -r '.name' | sed 's/^Nvim //')
        local latest_version_tag=$(echo "$latest_release" | jq -r '.tagName')

        # If the latest version tag is "stable", get the version number from the release list
        if [[ "$latest_version_tag" == "stable" ]]; then
          # Get the second latest version (assuming stable points to a release build)
          latest_version_name=$(gh --repo neovim/neovim release list | awk 'NR==2 {print $2}')
        fi

        echo "   installed version: $installed_version"
        echo "   latest version: $latest_version_name"

        # If the installed version is not the latest, update
        if [[ "$installed_version" != "$latest_version_name" ]]; then
          echo "   updating neovim..."

          gh --repo neovim/neovim release download --pattern='nvim.appimage'
          chmod u+x nvim.appimage && mv nvim.appimage ~/.local/bin/nvim
          echo "   updated to neovim $latest_version_name"
        else
          echo "   neovim is already up-to-date!"
        fi
      }
```

On the macbook pro; can use `homebrew`

**macOS**

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
