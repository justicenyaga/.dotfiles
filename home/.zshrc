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
alias myemulator='emulator -avd Pixel_7_API_35 -no-boot-anim -gpu swiftshader_indirect'

flutter-release() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: flutter-release <version> <build_number> <service_name>"
    return 1
  fi
  local version="$1"
  local build_number="$2"
  local service_name="$3"
  fvm flutter build appbundle --release \
    --build-name="$version" \
    --build-number="$build_number" \
    --obfuscate \
    --split-debug-info=build/debug-info \
  && dd-upload "$version" "$service_name"
}

sb-release() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: sb-release <version> <build_number> <service_name> [env=production]"
    return 1
  fi

  local version="$1"
  local build_number="$2"
  local service_name="$3"
  local env="${4:-production}"
  local flutter_version="${SHOREBIRD_FLUTTER_VERSION:-$(jq -r '.flutter // empty' .fvmrc 2>/dev/null)}"

  if [ -z "$flutter_version" ]; then
    echo "No Flutter version found. Set SHOREBIRD_FLUTTER_VERSION or add .fvmrc"
    return 1
  fi

  shorebird release android \
    --flutter-version="$flutter_version" \
    --dart-define-from-file=".env/${env}.json" \
    --build-name="$version" \
    --build-number="$build_number" \
    -- --obfuscate --split-debug-info=build/debug-info \
  && dd-upload "$version" "$service_name"
}

dd-upload() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: dd-upload <version> <service_name>"
    return 1
  fi

  local version="$1"
  local service_name="$2"
  local debug_info_dir="./build/debug-info"
  local mapping_file="./build/app/outputs/mapping/release/mapping.txt"
  local archive_root="$HOME/projects/customer_app_debug_info"
  local dest_dir="$archive_root/${version}_${service_name}"

  datadog-ci flutter-symbols upload \
    --service-name "$service_name" \
    --version "$version" \
    --dart-symbols-location "$debug_info_dir" \
    --android-mapping --android-mapping-location "$mapping_file" \
  || { echo "datadog-ci upload failed"; return 1; }

  mkdir -p "$archive_root"

  if [ ! -d "$debug_info_dir" ]; then
    echo "No debug-info folder found at $debug_info_dir"
    return 1
  fi

  mv "$debug_info_dir" "$dest_dir"

  if [ -f "$mapping_file" ]; then
    cp "$mapping_file" "$dest_dir/"
  else
    echo "Warning: mapping.txt not found at $mapping_file"
  fi

  echo "Debug info archived to $dest_dir"

  (
    cd "$archive_root" || { echo "Failed to cd into $archive_root"; return 1; }
    git add .
    git commit -m "${service_name} - ${version}"
    git push || echo "git push failed for ${service_name} - ${version}"
  )
}

sb-patch() {
  if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: sb-patch <version> <build_number> <service_name> [patch_number] [env=production] [track=staging]"
    return 1
  fi

  local version="$1"
  local build_number="$2"
  local service_name="$3"
  local patch_number="$4"
  local env="${5:-production}"
  local track="${6:-staging}"
  local symbols_dir="build/debug-info-patch"

  # clean up so symbols from an earlier patch can't mix with this one
  rm -rf "$symbols_dir"

  shorebird patch android \
    --release-version="${version}+${build_number}" \
    --track="$track" \
    --dart-define-from-file=".env/${env}.json" \
    -- --obfuscate --split-debug-info="$symbols_dir" \
  && dd-upload-patch "$version" "$service_name" "$patch_number"
}

dd-upload-patch() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: dd-upload-patch <version> <service_name> [patch_number]"
    return 1
  fi

  local version="$1"
  local service_name="$2"
  local patch_label="patch${3:-$(date +%Y%m%d-%H%M%S)}"
  local debug_info_dir="./build/debug-info-patch"
  local archive_root="$HOME/projects/customer_app_debug_info"
  local dest_dir="$archive_root/${version}_${service_name}_${patch_label}"

  if [ ! -d "$debug_info_dir" ]; then
    echo "No patch debug-info folder found at $debug_info_dir"
    return 1
  fi

  # Dart symbols only. No --android-mapping: patches don't change native code
  datadog-ci flutter-symbols upload \
    --service-name "$service_name" \
    --version "$version" \
    --dart-symbols-location "$debug_info_dir" \
  || { echo "datadog-ci upload failed"; return 1; }

  mkdir -p "$archive_root"
  mv "$debug_info_dir" "$dest_dir"

  echo "Patch debug info archived to $dest_dir"

  (
    cd "$archive_root" || { echo "Failed to cd into $archive_root"; return 1; }
    git add .
    git commit -m "${service_name} - ${version} (${patch_label})"
    git push || echo "git push failed for ${service_name} - ${version} (${patch_label})"
  )
}

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
export CHROME_EXECUTABLE=brave

# java
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
# export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"

# codecompanion - sourced secrets
if [ -f "$HOME/.zshrc_secrets" ]; then
  source "$HOME/.zshrc_secrets"
fi

# tmux
export POWERKIT_DEFAULT_STALE_MULTIPLIER=1

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

