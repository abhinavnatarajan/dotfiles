#!/usr/bin/bash

DOWNLOADS=$HOME/Downloads
APPFOLDER=$HOME/opt
LOCALBIN=$HOME/.local/bin
mkdir -p $DOWNLOADS
mkdir -p $APPFOLDER

# Install nnn file explorer
sudo apt-get install nnn

# fd-find for faster file searching
# https://github.com/sharkdp/fd
sudo apt-get install fd-find
ln -sf $(which fdfind) $LOCALBIN/fd

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
pipx install jupyterlab jupytext nbdime pydeps
nbdime config-git --enable --global

# Function to grab latest release tag version from a github repo
function latest_github_release_version() {
	echo $(curl -s "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "[v]?\K[^"]*')
}

# Install lazygit
# https://github.com/jesseduffield/lazygit#installation
cd $DOWNLOADS
LAZYGIT_VERSION=$(latest_github_release_version jesseduffield/lazygit)
LAZYGIT_FILE="lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
LAZYGIT_DEST_FOLDER=$APPFOLDER/lazygit
curl -LO "https://github.com/jesseduffield/lazygit/releases/latest/download/${LAZYGIT_FILE}"
mkdir -p $LAZYGIT_DEST_FOLDER
tar -xf ${LAZYGIT_FILE} -C $LAZYGIT_DEST_FOLDER
ln -sf $LAZYGIT_DEST_FOLDER/lazygit $LOCALBIN/lazygit

# Hatch for Pure Python project management
pipx install hatch

# Maturin for PyO3 (Python + Rust) projects
pipx install maturin

# Install julia via the juliaup package manager
cargo install juliaup
juliaup self update
juliaup add release

# Mambaforge
cd $DOWNLOADS
curl -LO "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
bash Miniforge3-Linux-x86_64.sh -b

# conda init
source $HOME/.bashrc
conda config --set auto_activate_base false

# Git-delta
cargo install git-delta

# Install neovim
# https://github.com/neovim/neovim/wiki/Installing-Neovim
NEOVIM_DEST_FOLDER="${APPFOLDER}/neovim"
cd $DOWNLOADS
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
mkdir -p $NEOVIM_DEST_FOLDER
# ./squashfs-root/AppRun --version
mv squashfs-root/* $NEOVIM_DEST_FOLDER
ln -sf $NEOVIM_DEST_FOLDER/AppRun $LOCALBIN/nvim

# Setup python environment for neovim
python3 -m venv $HOME/.local/share/venvs/pynvim --upgrade-deps
source ~/.local/share/venvs/pynvim/bin/activate
pip3 install pynvim
deactivate

# Install nodejs and npm
# https://github.com/nvm-sh/nvm#installing-and-updating
cd $DOWNLOADS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# Install node
nvm install node

# Install Tex Live
sudo apt-get install texlive-full

# Install pandoc
cd $DOWNLOADS
PANDOC_VERSION=$(latest_github_release_version jgm/pandoc)
PANDOC_FILE="pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz"
PANDOC_DEST_FOLDER="$APPFOLDER/pandoc"
mkdir -p $PANDOC_DEST_FOLDER
curl -LO "https://github.com/jgm/pandoc/releases/latest/download/${PANDOC_FILE}"
tar -xzf $DOWNLOADS/$PANDOC_FILE --strip-components=1 -C $PANDOC_DEST_FOLDER
cp -asf $PANDOC_DEST_FOLDER/* $HOME/.local

# Install quarto
cd $DOWNLOADS
QUARTO_VERSION=$(latest_github_release_version quarto-dev/quarto-cli)
QUARTO_FILE="quarto-${QUARTO_VERSION}-linux-amd64.tar.gz"
QUARTO_DEST_FOLDER=$APPFOLDER/quarto
mkdir -p $QUARTO_DEST_FOLDER
curl -LO "https://github.com/quarto-dev/quarto-cli/releases/latest/download/${QUARTO_FILE}"
tar -xzf ${QUARTO_FILE} --strip-components=1 -C $QUARTO_DEST_FOLDER 
ln -sf $QUARTO_DEST_FOLDER/bin/quarto $LOCALBIN/quarto

# Install sioyek
cd $DOWNLOADS
SIOYEK_FILE="sioyek-release-linux-portable.zip"
SIOYEK_APPIMAGE="Sioyek-x86_64.AppImage"
SIOYEK_DEST_FOLDER=$APPFOLDER/sioyek
mkdir -p $SIOYEK_DEST_FOLDER
curl -LO "https://github.com/ahrm/sioyek/releases/latest/download/${SIOYEK_FILE}"
unzip $SIOYEK_FILE
chmod u+x $SIOYEK_APPIMAGE
./${SIOYEK_APPIMAGE} --appimage-extract
mv squashfs-root/* $SIOYEK_DEST_FOLDER
ln -sf $SIOYEK_DEST_FOLDER/AppRun $LOCALBIN/sioyek
