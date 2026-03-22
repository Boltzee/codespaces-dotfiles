#!/bin/bash
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

cp .tmux.conf ~
cp .gitconfig ~
mkdir ~/.copilot
cp copilot-instructions.md ~/.copilot/

# Install NeoVim via tarball (container-friendly, no FUSE needed)
mkdir -p ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz -C ~/.local/
ln -sf ~/.local/nvim-linux64/bin/nvim ~/.local/bin/nvim

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Load nvm immediately in the script without restarting shell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install and use latest LTS
nvm install --lts
nvm use --lts

# Alias nvim
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
echo 'alias vim=nvim' >> ~/.bashrc
echo 'alias vi=nvim' >> ~/.bashrc

# Bring in our custom neovim config
echo "XDG_CONFIG_HOME=$HOME" >> ~/.profile
# git clone https://github.com/shea-parkes/neovim-config ~/.config/nvim
git clone https://oauth2:${NVIM_CONFIG_PAT}@github.com/Boltzee/LUNAR_NVIM_CONFIG.git ~/.config/nvim
cd ~/.config/nvim
git submodule init
git submodule update

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# if command -v poetry &>/dev/null; then
#   REPO_NAME=$(basename "$CODESPACE_REPO_NAME")
#   cd /workspaces/$REPO_NAME
#   poetry run nvim --headless +":UpdateRemotePlugins" +"q!"
# fi

# Go ahead and configure vim as well while we're at it
git clone https://github.com/shea-parkes/vim-config ~/.vim
cd ~/.vim
git submodule init
git submodule update

# Setup git completions for bash
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
echo "source ~/.git-completion.bash" >> ~/.bashrc

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
sudo rm -rf lazygit.tar.gz 
