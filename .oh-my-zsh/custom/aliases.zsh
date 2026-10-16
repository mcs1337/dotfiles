alias up='sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y'
alias reload='source ~/.zshrc'

alias zshrc='$EDITOR ~/.zshrc'
alias aliases='$EDITOR $ZSH_CUSTOM/aliases.zsh'

alias bat='batcat'

# Tmux
alias tnew='tmux new -s'
alias tatt='tmux attach -t'

# Install: sudo apt install eza bat fd-find ripgrep fzf zoxide btop duf ncdu tree trash-cli wl-clipboard
# On Debian, bat and fd run as batcat and fdfind.

alias sudo='sudo '

# Listing
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -lh --icons=auto --group-directories-first --time-style=relative'
alias la='eza -lah --icons=auto --group-directories-first --time-style=relative'
alias lm='eza -lh --icons=auto --sort=modified --reverse'
alias lS='eza -lh --icons=auto --sort=size --reverse'
alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
alias lt3='eza --tree --level=3 --icons=auto --group-directories-first'
alias lta='eza --tree --level=2 --icons=auto --all --group-directories-first'

# Viewing and searching
alias cat='batcat --style=plain --paging=never'
alias bat='batcat'
alias lessf='batcat --paging=always'
alias grep='grep --color=auto'
alias rgi='rg --ignore-case'
alias fd='fdfind'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Safer file operations
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias del='trash-put'
alias trashls='trash-list'

# System monitoring
alias top='btop'
alias df='duf'
alias dus='ncdu'
alias free='free -h'
alias sizes='du -sh -- * 2>/dev/null | sort -rh | head -20'

# Network
alias ip='ip -c'
alias ports='ss -tulpn'
alias myip='curl -s ifconfig.me; echo'
alias ping='ping -c 5'
alias serve='python3 -m http.server 8000'
alias weather='curl -s "wttr.in?format=3"'

# Clipboard (Wayland)
alias clip='wl-copy'
alias pclip='wl-paste'

# Editor and tmux
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias t='tmux'
alias ta='tmux attach -t'
alias tn='tmux new -s'
alias tls='tmux ls'
alias tk='tmux kill-session -t'
alias tm='tmux new-session -A -s main'

# Debian packages and systemd
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'
alias autoremove='sudo apt autoremove --purge'
alias sc='systemctl'
alias scu='systemctl --user'
alias sce='sudo systemctl enable --now'
alias scr='sudo systemctl restart'
alias scs='systemctl status'
alias jc='journalctl -xeu'
alias jf='journalctl -f'

# Shell conveniences
alias c='clear'
alias x='exit'
alias h='history'
alias hg='history | grep -i'
alias path='echo "$PATH" | tr ":" "\n"'
alias now='date "+%Y-%m-%d %H:%M:%S"'
