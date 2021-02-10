set number
set hidden
set wildchar=<Tab> wildmenu wildmode=full
syntax on
set splitright
set list listchars=tab:»·,trail:·,extends:#
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab
set cursorline
set colorcolumn=80
set nomodeline
set noswapfile
" Use simple/system clipboard
set clipboard+=unnamedplus
set signcolumn=yes
" Skip banner on top of netrw
let g:netrw_banner=0

" jk is escape
inoremap jk <esc>

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
call plug#end()
colorscheme srcery

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
let g:completion_timer_cycle = 10
let g:completion_trigger_on_delete = 1

" Setup fuzzy finding
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fq <cmd>lua require('telescope.builtin').quickfix()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>
nnoremap <leader>fa <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_range_code_actions()<cr>

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

" Setup telescope fuzzy finder
lua <<EOF
local telescope = require'telescope'
local previewers = require'telescope.previewers'
telescope.setup{
    qflist_previewer = previewers.vim_buffer_qflist.new
}
EOF

" LSP
" Map all standard LSP commands to ,X
noremap ,d <cmd>lua vim.lsp.buf.definition()<CR>
noremap ,c <cmd>lua vim.lsp.buf.incoming_calls()<CR>
noremap ,r <cmd>lua vim.lsp.buf.references()<CR>
noremap ,i <cmd>lua vim.lsp.buf.implementation()<CR>
noremap ,h <cmd>lua vim.lsp.buf.hover()<CR>
noremap ,n <cmd>lua vim.lsp.buf.rename()<CR>

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
augroup end
