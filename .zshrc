# zmodload zsh/zprof
# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export PAGER=less
export EDITOR=nvim

export LIBGL_ALWAYS_INDIRECT=1
export GDK_SCALE=0.5
export GDK_DPI_SCALE=1

export ORACLE_HOME=/opt/oracle/instantclient_21_1
export LD_LIBRARY_PATH="$ORACLE_HOME"

# export TERM=xterm-256color
export PATH="$HOME/.local/bin/:$HOME/.cargo/bin:$HOME/go/bin:$ORACLE_HOME:/opt/homebrew/bin:$HOME/.deno/bin:$PATH"

export QT_PLATFORM_PLUGIN=qt5ct
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
# fcitx-autostart &> /dev/null

export KEYTIMEOUT=25

export WSL_HOST=$(tail -1 /etc/resolv.conf | cut -d' ' -f2)
export ADB_SERVER_SOCKET=tcp:$WSL_HOST:5037
export ANDROID_SDK_ROOT=/opt/android-sdk

stty -ixon

if command -v xset > /dev/null; then
    xset r rate 250 250
fi


if [[ $(uname -a) =~ microsoft ]]; then
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
fi

if [[ $(uname -a) =~ Linux ]]; then
    export DISPLAY=$(ip rout list default | awk '{print $3}'):0
fi

if [[ $(uname -s) =~ Darwin ]]; then
    BPICK="(*darwin*amd*)|(*macos*)|(*apple*darwin*)"
else
    BPICK="(*x86*linux*)|(*linux-x86*)|(*linux*amd*)|(*linux64*)"
fi

## tpm
if [[ ! -d "$HOME/.dotfiles/tmux/.tmux/plugins/tpm" ]]; then
    echo "install tpm"
    mkdir -p $HOME/.dotfiles/tmux/.tmux/plugins
    git clone https://github.com/tmux-plugins/tpm $HOME/.dotfiles/tmux/.tmux/plugins/tpm
fi

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# export FZF_DEFAULT_COMMAND="rg --files "
export FZF_DEFAULT_COMMAND="([ ! -f ./.ignore ] && [ -d ./.hg ] && ag -l --hidden --ignore .hg) || rg --files "
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='
    --border --exit-0
    --color fg:188,hl:103,fg+:222,bg+:234,hl+:104
    --color info:183,prompt:110,spinner:107,pointer:167,marker:215'
export FZF_CTRL_T_OPTS="--preview 'bat {}' --bind '?:toggle-preview'"

# fnm
export ZSH_FNM_ENV_EXTRA_ARGS="--use-on-cd"

### Added by Zinit's installer
if [[ ! -f $HOME/.zplugin/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma-continuum/zinit)…%f"
    command mkdir -p "$HOME/.zplugin" && command chmod g-rwX "$HOME/.zplugin"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zplugin/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi
source "$HOME/.zplugin/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit installer's chunk

set promptsubst

# zinit snippet OMZ::plugins/vi-mode/vi-mode.plugin.zsh
# zinit snippet OMZ::plugins/tmux/tmux.plugin.zsh
zinit snippet OMZP::git
zinit snippet OMZP::mercurial
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::alias-finder
zinit snippet OMZP::sudo
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::history.zsh

zinit light-mode for \
    agkozak/zsh-z \
    zpm-zsh/autoenv 

zinit light-mode lucid wait for \
    changyuheng/zsh-interactive-cd \
    dominik-schwabe/zsh-fnm \
    OMZP::rbenv

zinit ice lucid as"command" from"gh-r" bpick"${BPICK}" mv"lsd* -> lsd" pick"lsd/lsd"
zinit light Peltoche/lsd

zinit ice atclone"./install --xdg --no-update-rc --completion --key-bindings" atpull"%atclone" as"program" pick="bin/fzf" multisrc"shell/{key-bindings,completion}.zsh"
zinit light junegunn/fzf

zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat

zinit ice from"gh-r" as"program" mv"fd* -> fd" pick"fd/fd" nocompletions
zinit light sharkdp/fd

# zinit ice from"gh-r" as"program" extract"" mv"exa*->exa" pick"bin/exa"
# zinit light ogham/exa

zinit ice as"program" pick"bin/git-dsf" wait"0" lucid
zinit light z-shell/zsh-diff-so-fancy

zinit ice from"gh-r" as"program" mv"tldr* -> tldr" pick"tldr"
zinit light dbrgn/tealdeer

zinit ice from"gh-r" as"program" mv"delta* -> delta" pick"delta/delta"
zinit light dandavison/delta

# zinit ice from"gh-r" as"program" bpick="hugo_extended*Linux*64bit.tar.gz" pick"hugo"
# zinit light gohugoio/hugo

zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg" bpick"${BPICK}"
zinit light BurntSushi/ripgrep

# zinit ice from"gh-r" as"program" ver"nightly" mv"nvim* -> nvim" pick"nvim/bin/nvim" bpick"*linux64*tar*"
zinit ice from"gh-r" as"program" ver"nightly" mv"nvim* -> nvim" pick"nvim/bin/nvim" bpick"${BPICK}"
zinit light neovim/neovim




if type broot >/dev/null 2>&1; then
  eval "$(broot --print-shell-function zsh)"
fi
# zinit ice pick"async.zsh" src"pure.zsh"
# zinit light sindresorhus/pure

zinit ice as'program' from'gh-r' mv'starship* -> starship' atload'eval $(starship init zsh)'
zinit light starship/starship


zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf \
        zsh-users/zsh-completions


# zstyle ':completion:*' menu select matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

[ -f ~/.aliases ] && source ~/.aliases

if command -v dircolors > /dev/null; then
    eval `dircolors ~/.dir_colors`
fi

# fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#

_diff_cmd="delta --paging=always"

gdiff() {
    local DIFF
    if [ "$@" ]; then
        # DIFF="git show --color=always $@ $(git rev-parse --show-toplevel)/{-1} | diff-so-fancy | less --tabs=4 -Rc"
        DIFF="git show --color=always $@ $(git rev-parse --show-toplevel)/{-1} | $_diff_cmd"
        git show $@ --name-only --pretty="format:" | \
        fzf --ansi --no-sort --reverse --tiebreak=index --no-select-1 \
            --preview="$DIFF" --bind "ctrl-m:execute:$DIFF"
    else
        # DIFF="git diff --color=always {-1} | diff-so-fancy | less --tabs=4 -Rc"
        DIFF="git diff --color=always {-1} | $_diff_cmd"
        git diff --name-only --pretty="format:" |  \
        fzf --ansi --no-sort --reverse --tiebreak=index --no-select-1 \
            --preview="$DIFF"  \
            --bind "ctrl-m:execute:$DIFF"
    fi
}

_ggrephash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_gshowdiff="$_ggrephash | xargs -I % sh -c \
    'git show --color=always % @ | $_diff_cmd'"
_gshowdifffile="git show % --color=always \$(git rev-parse --show-toplevel)/\{1} | $_diff_cmd"
_gfzfdiff="$_ggrephash | xargs -I % sh -c \
    'git show % --name-only --pretty=\"format:\" |
    fzf --ansi --no-sort --reverse --no-select-1 \
        --header=\"hash %\" --preview \"$_gshowdifffile\" \
        --bind \"ctrl-m:execute:$_gshowdifffile\"'"


gshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(auto)%an" "$@" $1 |
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --bind "ctrl-s:toggle-sort" \
      --bind "?:toggle-preview" \
      --preview=${_gshowdiff/@/$1} \
      --bind "ctrl-m:execute:${_gshowdiff/@/$1}" \
      --bind "ctrl-d:execute:$_gfzfdiff"
}

hgdiff() {
    local DIFF
    if [ "$@" ]; then
        # DIFF="hg diff -c $@ $(hg root)/{-1} --color=always | diff-so-fancy | less -R"
        DIFF="hg diff -c $@ $(hg root)/{-1} --color=always | $_diff_cmd"
        hg log -r $@ --template "{files % '{file}\n'}" | \
        fzf --ansi --no-sort --reverse --tiebreak=index --no-select-1 \
            --preview="$DIFF" --bind "ctrl-m:execute:$DIFF"
    else
        # DIFF="hg diff $(hg root)/{-1} --color=always | diff-so-fancy | less -R"
        DIFF="hg diff $(hg root)/{-1} --color=always | $_diff_cmd"
        hg status | \
        fzf --ansi --no-sort --reverse --tiebreak=index --no-select-1 \
            --preview="$DIFF" --bind "ctrl-m:execute:$DIFF"
    fi
}


_hggrepver="echo {} | grep -o '[0-9]\+' | head -1 "
_hgshowdiff="$_hggrepver | xargs -I % sh -c \
     'hg log @ --stat --color=always -vpr % | $_diff_cmd'"
    # 'hg log @ --stat --color=always -vpr % | diff-so-fancy | less -R'"
# _hgshowdifffile="hg diff -c @ \$(hg root)/\{1} --color=always | diff-so-fancy | less -R"
_hgshowdifffile="hg diff -c @ \$(hg root)/\{1} --color=always | $_diff_cmd"
_hglogfiles='hg log -r @ --template "{join(files, \"\n\")}"'
_hgfzfdiff="$_hggrepver | xargs -I @ sh -c '$_hglogfiles |
    fzf --ansi --no-sort --reverse --tiebreak=index --no-select-1 \
        --preview \"$_hgshowdifffile\" --header=\"Revision @\" \
        --bind \"ctrl-m:execute:$_hgshowdifffile\"'"

hgshow() {
  hg log2 $1 --color=always |
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --preview="${_hgshowdiff/@/$1}" \
      --bind "ctrl-s:toggle-sort" \
      --bind "?:toggle-preview" \
      --bind "ctrl-m:execute: ${_hgshowdiff/@/$1}" \
      --bind "ctrl-d:execute: $_hgfzfdiff"
}

hgr() {
  local files
  files=$(hg status | fzf -m --preview 'hg diff --color=always {2}' --bind '?:toggle-preview')
  if [ "$files" ]; then
    hg revert $(echo "$files" | awk '{print $2}')
  fi
}

hgcom () {
  local files
  files=$(hg status | fzf -m --preview 'hg diff --color=always {2}' --bind '?:toggle-preview')
  if [ "$files" ]; then
    hg ci $(echo "$files" | awk '{print $2}')
  fi
}

j() {
  [ $# -gt 0 ] && z "$*" && return
  cd "$(z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

vf() {
  local files

  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
     nvim -- $files
     print -l $files[1]
  fi
}

#vim + ag
vg() {
  local file
  local line

  read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     nvim $file +$line
  fi
}

# wsl unwatch file
# https://github.com/microsoft/WSL/issues/1529
# https://github.com/fuzzyTew/wslunpindir
wslunpin() {
   LD_PRELOAD=/usr/lib/interceptrename.so  "$@"
}


fkill() {
  local pid

  pid="$(
    ps -ef \
      | sed 1d \
      | fzf -m \
      | awk '{print $2}'
  )"

  if [[ ! -z $pid ]]; then
    kill -"${1:-9}" "$pid"
  fi
}

installvim() {
  sudo pacman -U https://archive.archlinux.org/packages/v/vim-runtime/vim-runtime-$1-x86_64.pkg.tar.zst
  sudo pacman -U https://archive.archlinux.org/packages/v/gvim/gvim-$1-x86_64.pkg.tar.zst
}

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# Load local file if it exists (this isn't commited to the dotfiles repo)
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# zprof

alias luamake=/home/jackys/server/lua-language-server/3rd/luamake/luamake

# fnm
if [[ $(uname -s) =~ Darwin ]]; then
    export PATH="/Users/jackysee/Library/Application Support/fnm:$PATH"
    eval "`fnm env`"
fi

