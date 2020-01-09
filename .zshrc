# zmodload zsh/zprof
# locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

export PAGER=less
export EDITOR=vim

export DISPLAY=:0
export LIBGL_ALWAYS_INDIRECT=1
export GDK_SCALE=0.5
export GDK_DPI_SCALE=1

export TERM=xterm-256color
export PATH="$HOME/.local/bin/:$PATH"

export QT_PLATFORM_PLUGIN=qt5ct
export QT_QPA_PLATFORMTHEME=qt5ct

export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
# fcitx-autostart &> /dev/null

stty -ixon

## fnm
export FNM_DIR="${:-$HOME/.}fnm"
if [[ ! -d $FNM_DIR ]]; then
  echo "Installing FNM"
  mkdir $FNM_DIR
  curl -fsSL https://github.com/Schniz/fnm/raw/master/.ci/install.sh | bash -s -- --skip-shell --force-install
fi
export PATH=$HOME/.fnm:$PATH
eval "`fnm env --multi`"

# ## nvm
# export NVM_LAZY_LOAD=true
# export NVM_DIR="${:-$HOME/.}nvm"
# if [[ ! -d $NVM_DIR ]]; then
#   echo "Installing NVM"
#   mkdir $NVM_DIR
#   curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.1/install.sh | bash
#   echo "Please modify ${HOME}/.zshrc to remove the line of code that the NVM installer added"
# fi
#
# if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
#   declare -a NODE_GLOBALS=(`find $HOME/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
#   NODE_GLOBALS+=("node")
#   NODE_GLOBALS+=("nvm")
#   NODE_GLOBALS+=("vim")
#   for cmd in "${NODE_GLOBALS[@]}"; do
#     eval "${cmd}(){ unset -f ${NODE_GLOBALS}; echo 'loading nvm...'; source $HOME/.nvm/nvm.sh; ${cmd} \$@ }"
#   done
# fi

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# export FZF_DEFAULT_COMMAND="rg --files "
export FZF_DEFAULT_COMMAND="([ ! -f ./.ignore ] && [ -d ./.hg ] && ag -l --hidden --ignore .hg) || rg --files "
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_DEFAULT_OPTS='
    --border --exit-0 --select-1
    --color fg:188,hl:103,fg+:222,bg+:234,hl+:104
    --color info:183,prompt:110,spinner:107,pointer:167,marker:215'
export FZF_CTRL_T_OPTS="--preview 'bat {}' --bind '?:toggle-preview'"

### Added by Zplugin's installer
export ZPLG_HOME="${:-$HOME/.}zplugin"

if [[ ! -d $ZPLG_HOME ]]; then
  echo "Installing zplugin"
  curl -sL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh | bash
fi

ZSH_DISABLE_COMPFIX=true
source "${ZPLG_HOME}/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

zplugin snippet OMZ::plugins/vi-mode/vi-mode.plugin.zsh
zplugin snippet OMZ::plugins/mercurial/mercurial.plugin.zsh
zplugin snippet OMZ::plugins/git/git.plugin.zsh
zplugin snippet OMZ::lib/directories.zsh
zplugin snippet OMZ::lib/history.zsh
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

zplugin light agkozak/zsh-z
# zplugin light dbkaplun/smart-cd
zplugin light bugworm/auto-exa
# # zplugin ice wait"0" atinit"zpcompinit; zpcdreplay" lucid

# issue https://github.com/zdharma/fast-syntax-highlighting/issues/146
# zplugin ice wait'0' lucid atload'FAST_HIGHLIGHT[chroma-git]="chroma/-ogit.ch"'
zplugin ice wait'0' lucid
zplugin light zdharma/fast-syntax-highlighting

# zplugin ice wait'0'
# zplugin light lukechilds/zsh-nvm

zplugin ice wait"0" atload"_zsh_autosuggest_start" lucid
zplugin light zsh-users/zsh-autosuggestions

zplugin ice wait"0" blockf lucid
zplugin light zsh-users/zsh-completions

zplugin ice from"gh-r" as"program"
zplugin light junegunn/fzf-bin

zplugin ice multisrc"shell/{key-bindings,completion}.zsh"
zplugin light junegunn/fzf

zplugin ice from"gh-r" as"program" bpick"*64*linux*" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zplugin light BurntSushi/ripgrep

zplugin ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat"
zplugin light sharkdp/bat

zplugin ice from"gh-r" as"program" mv"fd* -> fd" pick"fd/fd" nocompletions
zplugin light sharkdp/fd

zplugin ice from"gh-r" as"program" mv"exa*->exa" pick"exa"
zplugin light ogham/exa

zplugin ice from"gh-r" as"program" pick"dot"
zplugin light ubnt-intrepid/dot

zplugin ice as"program" pick"bin/git-dsf" wait"0" lucid
zplugin light zdharma/zsh-diff-so-fancy

zplugin ice pick"async.zsh" src"pure.zsh"
zplugin light sindresorhus/pure

### End of Zplugin's installer chunk

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

[ -f ~/.aliases ] && source ~/.aliases

if command -v dircolors > /dev/null; then
    eval `dircolors ~/.dir_colors`
fi

# fzf
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

_gshowdiff="(grep -o '[a-f0-9]\{7\}' | head -1 |
            xargs -I % sh -c 'git show --color=always % | diff-so-fancy | less --tabs=4 -RX') << 'FZF-EOF'
            {}
FZF-EOF"
gshow() {
  git log $1 --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(auto)%an" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --bind "ctrl-s:toggle-sort" \
      --bind "?:toggle-preview" \
      --preview=$_gshowdiff \
      --bind "ctrl-m:execute:$_gshowdiff"
}

# gshow() {
#   git log $1 --graph --color=always \
#       --format="%C(auto)%h%d %s %C(black)%C(bold)%cr %C(auto)%an" "$@" |
#   fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
#       --bind "ctrl-m:execute:
#                 (grep -o '[a-f0-9]\{7\}' | head -1 |
#                 xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
#                 {}
# FZF-EOF"
# }
_hgshowdiff="(grep -o '[0-9]\+' | head -1 |
                xargs -I % sh -c 'hg log --stat --color=always -vpr % | diff-so-fancy | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
hgshow() {
  hg log2 $1 --color=always |
  fzf --ansi --no-sort --reverse --tiebreak=index \
      --preview="$_hgshowdiff" \
      --bind "ctrl-s:toggle-sort" \
      --bind "?:toggle-preview" \
      --bind "ctrl-m:execute: $_hgshowdiff"
}

j() {
  [ $# -gt 0 ] && z "$*" && return
  cd "$(z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}
# zprof

vf() {
  local files

  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
     vim -- $files
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
     vim $file +$line
  fi
}

# Load local file if it exists (this isn't commited to the dotfiles repo)
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

