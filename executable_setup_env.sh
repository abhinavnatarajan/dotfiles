#!/usr/bin/bash

DOWNLOADS=$HOME/downloads
APPFOLDER=$HOME/opt
LOCALBIN=$HOME/.local/bin
mkdir -p $DOWNLOADS
mkdir -p $APPFOLDER

# Install C++ tools
sudo apt install automake libtool build-essential gdb cmake -y

# Install rust and cargo
# https://rust-lang.github.io/rustup/installation/other.html
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.bashrc

# Install go
cd $DOWNLOADS
curl -LO https://go.dev/dl/go1.22.2.linux-amd64.tar.gz
tar xzf go1.22.2.linux-amd64.tar.gz
mv go $GOPATH

# Pyenv for python version management
sudo apt update;
sudo apt install zlib1g zlib1g-dev libssl-dev libbz2-dev libsqlite3-dev libreadline-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
curl https://pyenv.run | bash
env PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto' PYTHON_CFLAGS='-march=native -mtune=native' pyenv install 3.11.6
pyenv global 3.11.6
# pipx for global packages
pip3 install --user pipx
pipx install jupytext # jupyter notebook to markdown and python
pipx install nbdime # git diffs for jupyter notebooks
nbdime config-git --enable --global
pipx install pydeps # python module dependency graph generator
pipx install tldr # tldr man pages
pipx install hatch # Hatch for Python project management
pipx install maturin # Maturin for PyO3 (Python + Rust) projects
pipx install segno # QR code generator
# Install svg2tikz
sudo apt install libcairo2-dev libgirepository1.0-devel -y
pipx install svg2tikz

# Mambaforge
cd $DOWNLOADS
curl -LO "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
bash Miniforge3-Linux-x86_64.sh -b

# conda init
source $HOME/.bashrc
conda config --set auto_activate_base false

# Install julia via the juliaup package manager
cargo install juliaup
juliaup self update
juliaup add release

# Install nodejs and npm
# https://github.com/nvm-sh/nvm#installing-and-updating
cd $DOWNLOADS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# Install node
nvm install node

# Lua
cd $DOWNLOADS
curl -LO https://www.lua.org/ftp/lua-5.4.6.tar.gz
tar zxf lua-5.4.6.tar.gz
cd lua-5.4.6
make linux-readline test
make install INSTALL_TOP=$APPFOLDER/lua
ln -sf $APPFOLDER/lua/bin/lua $LOCALBIN/lua
ln -sf $APPFOLDER/lua/bin/luac $LOCALBIN/luac

# Install Tex Live
sudo apt install texlive-full -y

# Install Hugo static website generator
go install -tags extended github.com/gohugoio/hugo@latest

# Function to grab latest release tag version from a github repo
function latest_github_release_version() {
	echo $(curl -s "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "[v]?\K[^"]*')
}

# fd-find for faster file searching
# https://github.com/sharkdp/fd
sudo apt install fd-find -y
ln -sf $(which fdfind) $LOCALBIN/fd

# Fuzzy finder
# https://github.com/junegunn/fzf
sudo apt install fzf -y

# Install rip-grep for searching text inside files
# https://github.com/BurntSushi/ripgrep
sudo apt install ripgrep -y

# xplr file explorer
XPLR_DEST_DIR=$APPFOLDER/xplr/
mkdir -p $XPLR_DEST_DIR
cd $DOWNLOADS
git clone -b dev https://github.com/sayanarijit/xplr.git
cd xplr
cargo build --locked --release --bin xplr
cp target/release/xplr $XPLR_DEST_DIR/
ln -sf $XPLR_DEST_DIR/xplr $LOCALBIN/xplr

# pistol file previewer for xplr and fzf
sudo apt install libmagic-dev -y
go install github.com/doronbehar/pistol/cmd/pistol@latest

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

# Github CLI
sudo mkdir -p -m 755 /etc/apt/keyrings && cd $_
sudo curl -LO https://cli.github.com/packages/githubcli-archive-keyring.gpg
sudo chmod go+r githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y

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
pyenv virtualenv 3.11.6 pynvim
pyenv activate pynvim
pip install pynvim
pyenv deactivate

# Install JetBrains Font
cd $DOWNLOADS
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.0/JetBrainsMono.zip
unzip JetBrainsMono.zip -d JetBrainsMono
mkdir -p $HOME/.local/share/fonts
mv JetBrainsMono $HOME/.local/share/fonts

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
