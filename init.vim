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
Plug 'neovim/nvim-lspconfig'     " LSP support
Plug 'nvim-lua/completion-nvim'  " Auto-complete
Plug 'vim-airline/vim-airline'   " Status bar lull lull
Plug 'srcery-colors/srcery-vim'  " Theme
Plug 'tpope/vim-fugitive'        " Git
call plug#end()
colorscheme srcery

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
set completeopt=menuone,noinsert,noselect
" Avoid showing message extra message when using completion
set shortmess+=c
let g:completion_timer_cycle = 10

" LSP
nmap ,d <cmd>lua vim.lsp.buf.definition()<CR>
nmap ,c <cmd>lua vim.lsp.buf.incoming_calls()<CR>
nmap ,r <cmd>lua vim.lsp.buf.references()<CR>
nmap ,i <cmd>lua vim.lsp.buf.implementation()<CR>
nmap ,h <cmd>lua vim.lsp.buf.hover()<CR>
nmap ,n <cmd>lua vim.lsp.buf.rename()<CR>

" Go
autocmd FileType go setlocal noexpandtab
autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)

" Go
lua <<EOF
require'lspconfig'.gopls.setup{}
EOF
"autocmd Filetype go setlocal omnifunc=v:lua.vim.lsp.omnifunc

" Python
lua <<EOF
require'lspconfig'.pyls.setup{}
EOF

" Java
lua <<EOF
require'lspconfig'.jdtls.setup{}
EOF

" Dotnet (Roslyn supported)
lua <<EOF
require'lspconfig'.omnisharp.setup{}
EOF

