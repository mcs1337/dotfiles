# ~/.aliases.sh  (works in bash and zsh)
# Load it from ~/.bashrc or ~/.zshrc with:
#   [ -f ~/.aliases.sh ] && . ~/.aliases.sh
#
# Every alias is guarded: if a tool isn't installed, the alias is skipped
# and the normal command keeps working.
#
# Suggested install (Debian):
#   sudo apt install eza bat fd-find ripgrep fzf zoxide btop duf ncdu \
#                    tree trash-cli wl-clipboard

_have() { command -v "$1" >/dev/null 2>&1; }

# Debian ships these under different names
_BAT=bat;  _have batcat && ! _have bat && _BAT=batcat
_FD=fd;    _have fdfind && ! _have fd  && _FD=fdfind

# Let aliases work after sudo (sudo ll, sudo v ...)
alias sudo='sudo '

# ----------------------------------------------------------------------
# Listing: eza (falls back to ls / tree)
# ----------------------------------------------------------------------
if _have eza; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lh --icons=auto --group-directories-first --time-style=relative'
  alias la='eza -lah --icons=auto --group-directories-first --time-style=relative'
  alias lm='eza -lh --icons=auto --sort=modified --reverse'   # newest first
  alias lS='eza -lh --icons=auto --sort=size --reverse'       # biggest first
  alias lt='eza --tree --level=2 --icons=auto --group-directories-first'
  alias lt3='eza --tree --level=3 --icons=auto --group-directories-first'
  alias lta='eza --tree --level=2 --icons=auto --all --group-directories-first'
else
  alias ls='ls --color=auto --group-directories-first'
  alias ll='ls -lh'
  alias la='ls -lAh'
  _have tree && alias lt='tree -L 2 -C --dirsfirst'
fi

# ----------------------------------------------------------------------
# Viewing and searching: bat, ripgrep, fd, fzf
# ----------------------------------------------------------------------
if _have "$_BAT"; then
  alias cat="$_BAT --style=plain --paging=never"   # cat with syntax highlighting
  alias bat="$_BAT"
  alias lessf="$_BAT --paging=always"              # full bat with line numbers
fi
alias grep='grep --color=auto'
_have rg && alias rgi='rg --ignore-case'
_have "$_FD" && alias fd="$_FD"

# fzf: pick a file with preview and open it in Neovim
if _have fzf; then
  fe() {
    local f
    f=$(fzf --preview "$_BAT --color=always --style=numbers {} 2>/dev/null || cat {}") || return
    "${EDITOR:-nvim}" "$f"
  }
  # fuzzy-search history and run the selection
  fh() {
    local cmd
    cmd=$(history | sed 's/^ *[0-9]* *//' | fzf --tac --no-sort) && eval "$cmd"
  }
fi

# ----------------------------------------------------------------------
# Navigation: zoxide gives you z (jump) and zi (interactive jump)
# ----------------------------------------------------------------------
if _have zoxide; then
  if [ -n "$ZSH_VERSION" ]; then eval "$(zoxide init zsh)"
  elif [ -n "$BASH_VERSION" ]; then eval "$(zoxide init bash)"; fi
fi
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# Go up N directories:  up 3
up() { local d=""; for ((i = 0; i < ${1:-1}; i++)); do d="../$d"; done; cd "$d" || return; }

# Make a directory and enter it
mkcd() { mkdir -p -- "$1" && cd -- "$1" || return; }

# ----------------------------------------------------------------------
# Safer file operations
# ----------------------------------------------------------------------
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
_have trash-put && alias del='trash-put'        # move to trash instead of rm
_have trash-list && alias trashls='trash-list'

# Quick backup:  bak file  ->  file.bak
bak() { cp -iv -- "$1" "$1.bak"; }

# Extract any archive:  extract file.tar.gz
extract() {
  [ -f "$1" ] || { echo "extract: '$1' is not a file" >&2; return 1; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar.zst)        tar --zstd -xf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.zip)            unzip "$1" ;;
    *.7z)             7z x "$1" ;;
    *.rar)            unrar x "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.xz)             unxz "$1" ;;
    *)                echo "extract: unknown format '$1'" >&2; return 1 ;;
  esac
}

# ----------------------------------------------------------------------
# System monitoring
# ----------------------------------------------------------------------
_have btop  && alias top='btop'
_have duf   && alias df='duf'                   # pretty disk usage
_have ncdu  && alias dus='ncdu'                 # interactive disk usage
_have dust  && alias du='dust'
_have procs && alias ps='procs'
alias free='free -h'
alias sizes='du -sh -- * 2>/dev/null | sort -rh | head -20'   # biggest items here

# ----------------------------------------------------------------------
# Network
# ----------------------------------------------------------------------
alias ip='ip -c'
alias ports='ss -tulpn'                         # listening ports
alias myip='curl -s ifconfig.me; echo'
alias ping='ping -c 5'
alias serve='python3 -m http.server 8000'       # serve this directory
weather() { curl -s "wttr.in/${1:-}?format=3"; }

# ----------------------------------------------------------------------
# Clipboard (Wayland):  cat file | clip      pclip > file
# ----------------------------------------------------------------------
if _have wl-copy; then
  alias clip='wl-copy'
  alias pclip='wl-paste'
fi

# ----------------------------------------------------------------------
# Editor and tmux
# ----------------------------------------------------------------------
if _have nvim; then
  alias v='nvim'
  alias vi='nvim'
  alias vim='nvim'
  alias vimrc='nvim ~/.config/nvim/init.lua'
fi
if _have tmux; then
  alias t='tmux'
  alias ta='tmux attach -t'
  alias tn='tmux new -s'
  alias tls='tmux ls'
  alias tk='tmux kill-session -t'
  tm() { tmux new-session -A -s "${1:-main}"; }   # attach or create (default: main)
fi

# ----------------------------------------------------------------------
# Debian packages and systemd
# ----------------------------------------------------------------------
if _have apt; then
  alias update='sudo apt update && sudo apt upgrade'
  alias install='sudo apt install'
  alias remove='sudo apt remove'
  alias search='apt search'
  alias autoremove='sudo apt autoremove --purge'
fi
alias sc='systemctl'
alias scu='systemctl --user'
alias sce='sudo systemctl enable --now'
alias scr='sudo systemctl restart'
alias scs='systemctl status'
alias jc='journalctl -xeu'                      # logs for a unit:  jc ssh
alias jf='journalctl -f'                        # follow the system log

# ----------------------------------------------------------------------
# Shell conveniences
# ----------------------------------------------------------------------
alias c='clear'
alias x='exit'
alias h='history'
alias path='echo "$PATH" | tr ":" "\n"'
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias please='sudo $(fc -ln -1)'                # rerun the last command with sudo
alias reload='exec "$SHELL"'
hg() { history | grep -i -- "$@"; }
