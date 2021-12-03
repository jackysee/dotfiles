if has('vim_starting')
  set encoding=utf-8
endif
scriptencoding utf-8

if &compatible
  set nocompatible
endif

let s:plug_dir = expand('/tmp/plugged/vim-plug')
if !filereadable(s:plug_dir .. '/plug.vim')
  execute printf('!curl -fLo %s/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim', s:plug_dir)
end

execute 'set runtimepath+=' . s:plug_dir
call plug#begin(s:plug_dir)
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'andymass/vim-matchup'
call plug#end()
PlugInstall | quit


let g:vimsyn_embed = 'l'
let g:loaded_matchit = 1
let g:matchup_transmute_enabled = 0

lua << EOF

require'nvim-treesitter.configs'.setup {
    matchup = { enable = true }
}

local test = function (a) 
    if a == nil then
        return 'word'
    end
    return 'hello'
end

EOF

