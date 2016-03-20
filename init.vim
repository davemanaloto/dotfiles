" vim:fdm=marker

" {{{ Vim/Nvim compatibility
if has('nvim')
    let PLUGGED_PATH='~/.config/nvim/plugged'
    let IS_NVIM=1
else
    let PLUGGED_PATH='~/.vim/plugged'
    let IS_NVIM=0
    set nocompatible
    set encoding=utf-8
    set ttyfast

    if !has('gui_running')
        set t_Co=256
    endif
endif
" }}}

" {{{ Plugins
call plug#begin(PLUGGED_PATH)

Plug 'airblade/vim-gitgutter'
Plug 'amix/vim-zenroom2'
Plug 'ap/vim-css-color'
Plug 'benekastah/neomake'
Plug 'christoomey/vim-tmux-navigator'
Plug 'easymotion/vim-easymotion'
Plug 'hail2u/vim-css3-syntax'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kchmck/vim-coffee-script'
Plug 'Konfekt/FastFold'
Plug 'nelstrom/vim-markdown-folding'
Plug 'pangloss/vim-javascript'
Plug 'sgur/vim-editorconfig'
Plug 'SirVer/ultisnips'
Plug 'terryma/vim-expand-region'
Plug 'tmux-plugins/vim-tmux'
Plug 'tomasr/molokai'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/LargeFile'
Plug 'chriskempson/base16-vim'
Plug 'Yggdroot/indentLine'
Plug 'ryanoasis/vim-devicons'
Plug 'mbbill/undotree'
Plug 'diepm/vim-rest-console'

if IS_NVIM
    " Nvim specific plugins
    Plug 'Shougo/deoplete.nvim'
else
    " Vim specific plugins
endif

call plug#end()

" Don't load the rest of the vimrc if we are instal mode
if $INSTALLMODE == '1'
  finish
endif
" }}}

"{{{ General

" Code folding settings
set foldmethod=syntax " fold based on indent
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " don't fold by default
set foldlevelstart=0

" Search settings
set ignorecase
set smartcase   " case-sensitive if expression contains a capital letter.
set hlsearch

" Disable wrapping
set wrap
set linebreak

" Enable the mouse
set mouse +=a

" Disable the bell
set noeb
set vb
set t_vb=

" Backup settings
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

"
" Save undo state
set undofile               " Save undo's after file closes
set undodir=$HOME/.undodir " where to save undo histories
set undolevels=1000        " How many undos
set undoreload=10000       " number of lines to save for undo

"}}}

"{{{ Look
if has('gui_running')
  set guifont=Inconsolata-g\ for\ Powerline:h12
  let g:fzf_launcher = "/$HOME/bin/In_a_new_term_function %s"
else
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

" Dark background and set colorscheme
set background=dark
colorscheme molokai

" Airline status line
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='molokai'

" Show status and tabline for airline
set laststatus=2
set showtabline=2
set guioptions=2

" Show line numbers
set number

" Show relative numbers
set relativenumber

" Show all characters
"set invlist
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" Hide the default mode text
set noshowmode

" Show cursor
set cursorline

"}}}

"{{{ Custom key mappings

" Change mapleader
let mapleader = "\<Space>"

" Map jj to exit insert mode.
imap jj <Esc>

" Spell checking
map <leader>sa zg
map <leader>s? z=

" Toggle Zen-mode
nmap <silent> <leader>z :Goyo<cr>

" Allow indent/deindent with tab/shift-tab
nmap <Tab> >>_
nmap <S-Tab> <<_
imap <S-Tab> <C-D>
vmap <Tab> >gv
vmap <S-Tab> <gv

" Start interactive EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Commenting
nmap <leader>c gcc
vmap <leader>c gc

" Fugitive
nmap <silent> <leader>gs :Gstatus<CR>
nmap <leader>ge :Gedit<CR>
nmap <silent><leader>gr :Gread<CR>
nmap <silent><leader>gb :Gblame<CR>
nmap <silent><leader>gc :Gcommit<CR>

" Folding
nmap <silent><leader>z  za
vmap <silent><leader>z  za

" Paste whatever's in the buffer to system clipboard
nnoremap <leader>y :call system('clipit', @0)<CR>

" Undo tree
nnoremap <leader>u :UndotreeToggle<CR>

" Mappings for FZF
nnoremap <C-p>                     :Files<CR>
nnoremap <silent> <Leader>C        :Colors<CR>
nnoremap <silent> <Leader><Enter>  :Buffers<CR>
nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
nnoremap <silent> <Leader>`        :Marks<CR>
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

"}}}

" {{{ Plugin settings
" Deoplete
let g:deoplete#enable_at_startup = 1

" Editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" Don't align comments or text in strings
let g:easy_align_ignore_groups = ['Comment', 'String']
"
" Neomake
autocmd BufWritePost * Neomake

" TMuxline status, need to install plugin
let g:tmuxline_preset = {
       \'a'    : '#S',
       \'win'  : ['#I', '#W'],
       \'cwin' : ['#I', '#W', '#F'],
       \'y'    : ['#\{cpu_icon\}#\{cpu_percentage\}'],
       \'z'    : '%l:%M %p %b %d',
       \'options' : {'status-justify' : 'left'}}
" \'y'    : ['#\{cpu_icon\}#\{cpu_percentage\}', '#\{battery_icon\}#\{battery_percentage\}'],

if IS_NVIM
    let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" }}}

" {{{ Goyo - Zen Mode
function! s:goyo_enter()
  silent !tmux set status off
  set noshowcmd
  set scrolloff=999

  " Allow quiting
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  set showcmd
  set scrolloff=5
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" }}}


