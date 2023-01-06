" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
" " requires make / gcc on windows
" Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" {'jackysee/telescope-hg.nvim'}
"
autocmd FileType TelescopePrompt let b:loaded_delimitMate = 1

lua << EOF
local actions = require('telescope.actions')
require('telescope').setup {
    defaults = {
        layout_config = {
            prompt_position = 'top',
            width = 0.92,
        },
        layout_strategy = "flex",
        -- border = false,
        path_display = {'truncate'},
        sorting_strategy = "ascending",
        mappings = {
            i =  {
                ["<esc>"] = actions.close,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
            }
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}
EOF

lua << EOF
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('hg')
EOF

function! TelescopeFindFiles(txt)
    lua require('telescope.builtin').find_files({find_command={'rg','--files'}})
    call feedkeys(a:txt)
endfunction

function! TelescopeFindFilesUnderCursor()
    let txt = VisualSelection()
    call TelescopeFindFiles(txt)
endfunction

function! TelescopeGrepVisualSelectedString()
    lua require('telescope.builtin').grep_string({ search = vim.api.nvim_eval('VisualSelection()'), use_regex = true })
endfunction

nnoremap <leader>df :call TelescopeFindFiles('')<cr>
nnoremap <leader>dl <cmd>lua require('telescope.builtin').live_grep({})<cr>
nnoremap <leader>dg <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Rg: "), use_regex = true })<cr>
nnoremap <leader>db <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>dr <cmd>lua require('telescope.builtin').oldfiles()<cr>
nnoremap <leader>dc <cmd>lua require('telescope.builtin').commands()<cr>
nnoremap <leader>dF :call TelescopeFindFiles(expand('<cword>'))<cr>
vnoremap <leader>dG :<BS><BS><BS><BS><BS>:call TelescopeGrepVisualSelectedString()<cr>
vnoremap <leader>dF :<BS><BS><BS><BS><BS>:call TelescopeFindFilesUnderCursor()<cr>
nnoremap <leader>hg :Telescope hg
