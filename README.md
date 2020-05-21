# Personal Dotfiles

My dotfiles. Should work on _*nix_ systems although are created in Linux Mint 19(Ubuntu 18.04).

Took ideas from:

- [Tute](https://github.com/tute/dotfiles)
- [Pedro Fernandez](https://github.com/pedrofernandezm/dotfiles)
- [Web Pro](https://github.com/webpro/dotfiles)
- [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
- [Getting Started with Dotfiles](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789)

## Installation

Clone this repo:

```bash
$ cd ~/projects
$ git clone https://github.com/cesc1989/dotfiles
```

Symlink files to `$HOME` folder.

On Linux Mint:

```bash
$ ln -sv "/home/$(whoami)/projects/dotfiles/runcom/.bash_profile" ~
$ ln -sv "/home/$(whoami)/projects/dotfiles/git/.gitconfig" ~
```

On macOS:

```bash
$ ln -sv "/Users/$(whoami)/projects/dotfiles/runcom/.bash_profile" ~
$ ln -sv "/Users/$(whoami)/projects/dotfiles/git/.gitconfig" ~
```

Add the following snippet in `~/.profile`:

```bash
if [ -f "$HOME/.bash_profile" ]; then
. "$HOME/.bash_profile"
fi
```
