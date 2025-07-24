# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to oh-my-zsh 
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

export PATH="$PATH:$HOME/.local/bin"

source $ZSH/oh-my-zsh.sh
source <(fzf --zsh)
eval "$(zoxide init zsh)"

# aliases
alias ls="eza --icons=always"
alias cd="z"
alias open="xdg-open"
alias pnvim="pipenv run nvim"
alias netspeed="dstat --net --top-io-adv"
alias oo="cd $HOME/obsidian"
alias or="nvim -p $HOME/obsidian/inbox/*.md"
[[ "$TERM" = "xterm-kitty" ]] && [[ -z $TMUX ]] && alias ssh="kitty +kitten ssh"
alias yt720='yt-dlp -f "bestvideo[height=720]+bestaudio"'

# add chrome alias if in a WSL environment
if which powershell.exe &>/dev/null; then
  alias chrome="/mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe" 
fi

# gem
export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"

# go
export GOPATH="$HOME/go"
export GOROOT="/usr/lib/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$GOROOT/bin"

# flutter
export PATH="$HOME/.local/flutter/bin:$PATH"
export PATH="$HOME/.local/android-studio/bin:$PATH"
export CHROME_EXECUTABLE=microsoft-edge-stable

# java
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
# export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# codecompanion - sourced secrets
if [ -f "$HOME/.zshrc_secrets" ]; then
  source "$HOME/.zshrc_secrets"
fi

# flatpak
# export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:~/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# fzf
fg="#cbe0f0"
bg="#011628"
bg_highlight="#143652"
purple="#b388ff"
blue="#06bce4"
cyan="#2cf9ed"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --follow --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# bat
export BAT_THEME="tokyonight_night"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/jnyaga/.dart-cli-completion/zsh-config.zsh ]] && . /home/jnyaga/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

