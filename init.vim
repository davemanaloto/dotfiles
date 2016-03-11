call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'amix/vim-zenroom2'
Plug 'benekastah/neomake'
"Plug 'christoomey/vim-tmux-navigator'
Plug 'Chun-Yang/vim-action-ag'
Plug 'easymotion/vim-easymotion'
Plug 'godlygeek/tabular'
Plug 'hail2u/vim-css3-syntax'
Plug 'honza/vim-snippets'
Plug 'janko-m/vim-test'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/vim-easy-align'
Plug 'kchmck/vim-coffee-script'
Plug 'Konfekt/FastFold'
Plug 'pangloss/vim-javascript'
Plug 'rking/ag.vim'
Plug 'skammer/vim-css-color'
Plug 'sgur/vim-editorconfig'
Plug 'Shougo/deoplete.nvim'
Plug 'SirVer/ultisnips'
Plug 'terryma/vim-expand-region'
Plug 'tmux-plugins/vim-tmux'
Plug 'tomasr/molokai'
"Plug 'tomtom/tcomment_vim'
"Plug 'tpope/vim-commentary'
"Plug 'tpope/vim-endwise'
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
Plug 'Yggdroot/indentLine'

call plug#end()

let is_install = $INSTALLMODE
if is_install == '1'
  finish
endif

""{{{ General

" Code folding settings
set foldmethod=syntax " fold based on indent
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " don't fold by default
set foldlevel=1

" Search settings
set ignorecase
set smartcase   " case-sensitive if expression contains a capital letter.
set hlsearch

" Disable wrapping
set wrap
set linebreak
"}}}


"{{{ Look
if has('gui_running')
  set guifont=Inconsolata-g\ for\ Powerline:h12
  let g:fzf_launcher = "/$HOME/bin/In_a_new_term_function %s"
endif

set background=dark
colorscheme molokai

set laststatus=2
set showtabline=2
set guioptions=2

" Show line numbers
" set number
" Show relative numbers
set relativenumber

" Show all characters
set invlist
set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

set noshowmode " Hide the default mode text since it shows in our status line

" Airline status line
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='molokai'
"}}}

"{{{ Backups
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
"}}}

"{{{ Custom key mappings

" Change mapleader
let mapleader = "\<Space>"

inoremap <c-x><c-k> <c-x><c-k>

" Map jj to exit insert mode.
inoremap jj <Esc>

" Toggle displaying all characters
nmap <leader>l :set list!<CR>:set relativenumber!<CR>:IndentLinesToggle<CR>

" Spell checking
map <leader>sa zg
map <leader>s? z=

" File finding
nnoremap <Leader>o :FZF<CR>
map <C-p> :FZF<CR>

" Toggle Zen-mode
nnoremap <silent> <leader>z :Goyo<cr>

" Tab switching
nnoremap <leader>[ :tabprevious<CR>
nnoremap <leader>] :tabnext<CR>

" Allow indent/deindent with tab/shift-tab
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Start interactive EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


" Ultisnips
" Set ultisnips triggers
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

"}}}
"
let g:deoplete#enable_at_startup = 1

" For Commits and BCommits to customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" Advanced customization using autoload functions
autocmd VimEnter * command! Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'})

" Editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*']

" {{{ Goyo - Zen Mode
function! s:goyo_enter()
  silent !tmux set status off
  "set noshowmode
  set noshowcmd " Show (partial) command in the status line.
  set scrolloff=999

  " Allow quiting
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  "set showmode
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

" Enable neomake on the current file on every write
autocmd! BufWritePost * Neomake

" {{{
" let g:tmuxline_preset = {
"        \'a'    : '#S',
"        \'win'  : ['#I', '#W'],
"        \'cwin' : ['#I', '#W', '#F'],
"        \'y'    : ['#\{cpu_icon\}#\{cpu_percentage\}'],
"        \'y'    : ['#\{cpu_icon\}#\{cpu_percentage\}', '#\{battery_icon\}#\{battery_percentage\}'],
"        \'z'    : '%l:%M %p %b %d',
"        \'options' : {'status-justify' : 'left'}}
" "}}}
