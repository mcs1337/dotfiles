export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:plugins:git' aliases no

ZSH_THEME="agnoster"

HIST_STAMPS="dd.mm.yyyy"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
