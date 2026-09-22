My Dev Config
=============

Personal development environment, HomeLab deployment configurations, and
technical notes.

The documentation is built with Sphinx and published to GitHub Pages. The
repository also contains Neovim, Tmux, terminal, Docker Compose, and snippet
configurations.

See `readme.rst` and `docs/` for setup instructions and detailed notes.

Neovim now has two isolated profiles: `nvim-lite` (offline, no plugins) and
`nvim-daily` (the daily configuration, with optional LSP).
Run `bash nvim/install.sh` to install both without replacing the existing `nvim`
configuration. See [Neovim setup](nvim/readme.rst) for requirements and shortcuts.
