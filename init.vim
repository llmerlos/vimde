" ENVIRONMENT DETECT
let g:env = {'lua' :  has('nvim')}
let g:env.vsc = exists('g:vscode')
let g:env.itj = has('ide')
let g:env.nvm = g:env.lua && (env.vsc == 0)
let g:env.vim = (g:env.lua == 0) && (env.itj == 0)
let g:env.emb = g:env.vsc || g:env.itj
let g:env.ide = ($NVIM_APPNAME == 'vimde')

" OPTIONS
set nocompatible
set viminfo="NONE"
set noswapfile
set incsearch
set ignorecase
set smartcase
set clipboard^=unnamedplus
set path+=**
set gp=rg\ -n
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set scrolloff=12
set splitright
set splitbelow

if g:env.vsc == 0 
    syntax on
    filetype plugin indent on
    set title
    set mouse=a
    set termguicolors
    set number
    set relativenumber
    set nowrap
    set cursorline
    set colorcolumn=120
endif

" REMAPS
let mapleader=" "
let maplocalleader=" "
set wildcharm=<Tab>

" CONFIG
noremap     <leader>vr         :source $MYVIMRC<CR>
noremap     <leader>ve         :e $MYVIMRC<CR>
if g:env.vsc
    noremap <leader>vr         <Cmd>lua require('vscode-neovim').action("workbench.action.restartExtensionHost")<CR>
    noremap <leader>ve         :Edit $MYVIMRC<CR>
endif

"" BLOCK INDENT
vnoremap    >                  >gv
vnoremap    <lt>               <lt>gv

"" MISC
nnoremap    U                  <C-R>
noremap     <silent><ESC>      :set nohls<CR>
noremap     <leader>wc         :cd %:h<CR>

"" SCROLL & NAVIGATION
noremap     <Up>               <Nop>
noremap     <Down>             <Nop>
noremap     <Left>             <Nop>
noremap     <Right>            <Nop>
noremap     <silent><C-d>      12j
noremap     <silent><C-u>      12k
noremap     <silent><C-l>      :bn<CR>
noremap     <silent><C-h>      :bp<CR>
noremap     X                  :bd<CR>
noremap  <silent><leader><Tab> :b <Tab>
noremap     Q                  @q
noremap     mq                 mQ
noremap     mw                 mW
noremap     me                 mE
noremap     mr                 mR
noremap     mt                 mT
noremap     'q                 'Q
noremap     'w                 'W
noremap     'e                 'E
noremap     'r                 'R
noremap     't                 'T
noremap     `q                 `Q
noremap     `w                 `W
noremap     `e                 `E
noremap     `r                 `R
noremap     `t                 `T

"" CONFLICTING KEYMAPS
noremap     <C-s>              :w<CR>
nnoremap    <leader><leader>a  gg0vG$
nnoremap    <leader><leader>v  <C-v>

"" MOVE LINES
nnoremap    <silent><A-Up>     :m .-2<CR>==
nnoremap    <silent><A-Down>   :m .+1<CR>==
vnoremap    <silent><A-Up>     :m '<-2<CR>gv
vnoremap    <silent><A-Down>   :m '>+1<CR>gv
nnoremap    <silent><A-k>      :m .-2<CR>==
nnoremap    <silent><A-j>      :m .+1<CR>==
vnoremap    <silent><A-k>      :m '<-2<CR>gv
vnoremap    <silent><A-j>      :m '>+1<CR>gv

"" CLIPBOARD
noremap     c                  "_c
nnoremap    cc                 "_S
noremap     C                  "_C
noremap     s                  "_s
noremap     S                  "_S
noremap     d                  "_d
nnoremap    dd                 "_dd
noremap     D                  "_D
noremap     x                  "_x
noremap     <leader><leader>c  c
nnoremap    <leader><leader>cc cc
noremap     <leader><leader>C  C
noremap     <leader><leader>d  d
nnoremap    <leader><leader>dd dd
noremap     <leader><leader>D  D
vnoremap    p                  "_dP



if g:env.ide == 1
    lua require('ide')
endif
