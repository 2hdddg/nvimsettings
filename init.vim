set number
set hidden
set wildchar=<Tab> wildmenu wildmode=full
syntax on
set splitright
set list listchars=tab:»·,trail:·,extends:#
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set cursorline
set colorcolumn=80
set nowrap
set nomodeline
set noswapfile
" Use simple/system clipboard
set clipboard+=unnamedplus
set signcolumn=yes
" Skip banner on top of netrw
let g:netrw_banner=0

let mapleader = ";"

" jk is escape
inoremap jk <esc>
" Keystroke savers
nnoremap <leader>n <cmd>nohl<cr> " No hightlight

"set completeopt-=preview
"set completeopt=menuone,noinsert,noselect
"filetype plugin on

" The Silver Searcher
" Use ag over grep
if executable('ag')
  set grepprg=ag\ --vimgrep\ $*
  set grepformat=%f:%l:%c:%m
  " bind K to grep word under cursor
  " this binding only works with ag
  nnoremap K :silent! grep! <cword> <bar>cwindow<bar>redraw!<cr>
endif

" Plugins, using https://github.com/junegunn/vim-plug
call plug#begin('~/.nvimplug')
Plug 'neovim/nvim-lspconfig'         " LSP configuration support
Plug 'mfussenegger/nvim-jdtls'      " Enhanced Java LSP support
Plug 'nvim-lua/completion-nvim'      " Auto-complete
Plug 'vim-airline/vim-airline'       " Status bar lull lull
Plug 'srcery-colors/srcery-vim'      " Theme
Plug 'tpope/vim-fugitive'            " Git
Plug 'nvim-lua/popup.nvim'           " For telescope
Plug 'nvim-lua/plenary.nvim'         " For telescope
Plug 'nvim-telescope/telescope.nvim' " Fuzzy finder over lists
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " neovim 0.5 syntax highlighter experiment
Plug 'honza/vim-snippets'            " Actual snippets
call plug#end()
colorscheme srcery

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
let g:completion_timer_cycle = 5
let g:completion_trigger_on_delete = 1
let g:completion_enable_snippet = 'UltiSnips'

" Setup fuzzy finding
nnoremap <leader>f <cmd>lua require('telescope.builtin').find_files({ initial_mode = 'insert' })<cr>
nnoremap <leader>q <cmd>lua require('telescope.builtin').quickfix()<cr>
nnoremap <leader>a <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>


" Snippets
"

" Setup fancy highlighting
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
  },
}
EOF

" Shows LSP diagnostics in a pop up instead of virtual text
lua <<EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        underline = true,
        signs = true,
    }
)
EOF
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
" autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
set updatetime=300 " CursorHold trigger time (and write to swap)

" Setup telescope fuzzy finder
lua <<EOF
local telescope = require'telescope'
local previewers = require'telescope.previewers'
telescope.setup{
  defaults = {
   initial_mode = 'insert',
   sorting_strategy = 'descending',
  }
}
EOF

" LSP
" Map all standard LSP commands to ,X
noremap ,d <cmd>lua vim.lsp.buf.definition()<CR>
noremap ,c <cmd>lua vim.lsp.buf.incoming_calls()<CR>
noremap ,r <cmd>lua vim.lsp.buf.references()<CR>
"noremap ,r <cmd>lua require('telescope.builtin').lsp_references({shorten_path = false})<CR>
noremap ,D <cmd>lua require('telescope.builtin').lsp_document_diagnostics()<CR>
noremap ,i <cmd>lua vim.lsp.buf.implementation()<CR>
noremap ,h <cmd>lua vim.lsp.buf.hover()<CR>
noremap ,n <cmd>lua vim.lsp.buf.rename()<CR>
" Standard LSP stuff but specific for jdtls plugin
noremap ,a <Cmd>lua require('jdtls').code_action()<CR>
noremap ,f <Cmd>lua require('jdtls').code_action(false, 'refactor')<CR>

" Go
autocmd FileType go setlocal noexpandtab
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)

lua <<EOF
require'lspconfig'.gopls.setup{}
EOF
"autocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc

" Python
lua <<EOF
require'lspconfig'.pyls.setup{}
EOF

" Java
"autocmd BufWritePre *.java lua vim.lsp.buf.formatting_sync(nil, 1000)
"lua <<EOF
"local lspconfig = require'lspconfig'
"lspconfig.jdtls.setup{
"    root_dir = lspconfig.util.root_pattern('.git')
"}
"EOF
augroup lsp
    au!
    au FileType java lua require'jdtls'.start_or_attach({cmd = {'java-lsp.sh'}})
    " au FileType java lua require'jdtls'.start_or_attach({cmd = {'java-lsp.sh', '' .. vim.fn.getcwd()}})
augroup end
