. "$HOME/.local/bin/env"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)

zinit ice depth=1
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Shell wrapper that allows yazi to cd to directory when exiting yazi
# https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

export PATH="$PATH:/opt/nvim/"

# Set default editor
export EDITOR=nvim

# opencode
export PATH=/home/jamjar/.opencode/bin:$PATH

source /home/jamjar/.config/broot/launcher/bash/br

. "$HOME/.local/bin/env"

source $HOME/.local/bin/env

if [ -f ~/.aliases ]; then
  . ~/.aliases
fi

# Zsh plugins
zi ice lucid wait
zi light zsh-users/zsh-syntax-highlighting

zi for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
  zsh-users/zsh-completions

# zi light zsh-users/zsh-completions

# autoload -Uz compinit
# compinit

# zinit cdreplay -q

# Load completions before fzf-tab
# autoload -U compinit; compinit
zi ice lucid wait
zi light Aloxaf/fzf-tab

# Enable emacs mode keybindings.
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completion
zstyle ':completion:*' menu no

# Keychain for SSH
eval $(keychain -q --eval ~/.ssh/id_ed25519)

# oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/macchiato.json)"

# Enable FZF support for bash
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
