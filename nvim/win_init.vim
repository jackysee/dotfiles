" copy this file to c:/users/username/AppData/Local/nvim/init.vim

set pythonthreedll=~/AppData/Local/Programs/Python/Python37/python37.dll
set pythonthreehome=~/AppData/Local/Programs/Python/Python37/
let $PYTHONHOME = '~/AppData/Local/Programs/Python/Python37/'
set runtimepath^=/settings/dotfiles/nvim
set runtimepath+=/settings/dotfiles/nvim/after
let &packpath=&runtimepath
source /settings/dotfiles/nvim/init.vim
