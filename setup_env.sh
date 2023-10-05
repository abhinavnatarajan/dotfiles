#!/usr/bin/bash

# Install nnn file explorer
sudo apt-get install nnn

# Mambaforge
mkdir ../Downloads && cd $_
curl -LSO https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash Mambaforge-Linux-x76_64.sh -b
conda init
source ~/.bashrc
conda config --set auto_activate_base false

# Pyenv for python version management
curl https://pyenv.run | bash
# Poetry for environment management
curl -sSL https://install.python-poetry.org | python3 -

# Install C++ tools
sudo apt-get install automake libtool build-essential gdb cmake

# Install rust and cargo
# https://rust-lang.github.io/rustup/installation/other.html
curl https://sh.rustup.rs -sSf | sh -s -- -y
source ~/.profile

# Install julia via the juliaup package manager
cargo install juliaup
juliaup self update
juliaup add release

# Git-delta
cargo install git-delta

# Neovim telescope dependencies
# Install rip-grep for file searching
# https://github.com/BurntSushi/ripgrep
sudo apt-get install ripgrep
# fd-find for faster file searching
# https://github.com/sharkdp/fd
sudo apt-get install fd-find

# Install neovim
# https://github.com/neovim/neovim/wiki/Installing-Neovim
curl -LSO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /.local/bin/nvim

# Install nodejs and npm
# https://github.com/nvm-sh/nvm#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# Install node
nvm install node

# Install lazygit
# https://github.com/jesseduffield/lazygit#installation
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin/

# Setup python environment for neovim
python -m venv ~/.local/share/pynvim_venv --upgrade-deps
source ~/.local/share/pynvim_venv/bin/activate
pip install pynvim
deactivate

# Install Tex Live
sudo apt-get install texlive
