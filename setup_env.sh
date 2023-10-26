#!/usr/bin/bash

# Install nnn file explorer
sudo apt-get install nnn

# fd-find for faster file searching
# https://github.com/sharkdp/fd
sudo apt-get install fd-find
ln -s $(which fdfind) $HOME/.local/bin/fd
# Fuzzy finder
# https://github.com/junegunn/fzf
sudo apt-get install fzf
# Install rip-grep for searching text inside files
# https://github.com/BurntSushi/ripgrep
sudo apt-get install ripgrep

# Install C++ tools
sudo apt-get install automake libtool build-essential gdb cmake
# Install rust and cargo
# https://rust-lang.github.io/rustup/installation/other.html
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.bashrc
# Pyenv for python version management
sudo apt update;
sudo apt install zlib1g zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev libreadline-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl https://pyenv.run | bash
env PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto' PYTHON_CFLAGS='-march=native -mtune=native' pyenv install 3.11.0
pyenv global 3.11.0
# pipx for global packages
pip3 install --user pipx
pipx install jupyterlab jupytext nbdime
nbdime config-git --enable --global
# Install lazygit
# https://github.com/jesseduffield/lazygit#installation
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit $HOME/.local/bin
# Hatch for Pure Python project management
pipx install hatch
# Maturin for PyO3 (Python + Rust) projects
pipx install maturin
# Install julia via the juliaup package manager
cargo install juliaup
juliaup self update
juliaup add release
# Mambaforge
mkdir $HOME/Downloads && cd $_
curl -LSO https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh
bash Mambaforge-Linux-x76_64.sh -b
# conda init
source $HOME/.bashrc
conda config --set auto_activate_base false
# Git-delta
cargo install git-delta

# Install neovim
# https://github.com/neovim/neovim/wiki/Installing-Neovim
curl -LSO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version
sudo mv squashfs-root $HOME/squashfs-root
sudo ln -s $HOME/squashfs-root/AppRun /.local/bin/nvim
# Install nodejs and npm
# https://github.com/nvm-sh/nvm#installing-and-updating
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# Install node
nvm install node
# Setup python environment for neovim
python3 -m venv $HOME/.local/share/pynvim_venv --upgrade-deps
source ~/.local/share/pynvim_venv/bin/activate
pip3 install pynvim
deactivate
# Install Tex Live
sudo apt-get install texlive
