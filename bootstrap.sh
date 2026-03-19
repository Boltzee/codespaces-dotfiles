#!/bin/bash

cp .tmux.conf ~
cp .gitconfig ~
mkdir ~/.copilot
cp copilot-instructions.md ~/.copilot/

# Install NeoVim via tarball (container-friendly, no FUSE needed)
mkdir -p ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xzf nvim-linux-x86_64.tar.gz -C ~/.local/
ln -sf ~/.local/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim

# Alias nvim
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
echo 'alias vim=nvim' >> ~/.bashrc
echo 'alias vi=nvim' >> ~/.bashrc

# Bring in our custom neovim config
echo "XDG_CONFIG_HOME=$HOME" >> ~/.profile
# git clone https://github.com/shea-parkes/neovim-config ~/.config/nvim
git clone https://github.com/Boltzee/LUNAR_NVIM_CONFIG.git ~/.config/nvim
cd ~/.config/nvim
git submodule init
git submodule update

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Get Neovim mostly ready to go
cd /workspaces/$RepositoryName
# poetry run pip install pynvim ipython  # Avoid if we can help it
poetry run nvim --headless +":UpdateRemotePlugins" +"q!"

# Go ahead and configure vim as well while we're at it
git clone https://github.com/shea-parkes/vim-config ~/.vim
cd ~/.vim
git submodule init
git submodule update

# Setup git completions for bash
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
echo "source ~/.git-completion.bash" >> ~/.bashrc
