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
Plug 'neovim/nvim-lspconfig'
call plug#end()
PlugInstall | quit

lua << EOF

local prettier = {
    formatCommand = 'prettierd ${INPUT}',
    formatStdin = true
}

require'lspconfig'.efm.setup {
    cmd = {'/home/jackys/.local/share/nvim/lsp_servers/efm/efm-langserver'},
    filetypes = { "typescript", "javascript"},
    init_options = { documentFormatting = true },
    root_dir = require'lspconfig.util'.root_pattern('package.json'),
    settings = {
        rootMarkers = { "package.json" },
        languages = {
            typescript = { prettier },
            javascript = { prettier }
        }
    },
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = true
    end
}
EOF


augroup FormatAutogroup
  autocmd!
  autocmd BufWritePre *.js,*.ts lua vim.lsp.buf.formatting_sync(nil, 1000)
augroup END
