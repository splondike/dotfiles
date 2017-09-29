"*******************
"***** Options *****
"*******************

set backspace=2 "Make backspace behave sensibly
set mouse=a "Enable mouse if possible
set autochdir
set tags=./tags; "Climb dir tree until tags is found
set nospell
set nu

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab "Indenting preferences
set smartindent "Automatically indent 'smartly'
"set textwidth=72 "Max width before breaking
set formatoptions=l "No automatic wrapping
set lbr

"Show whitespace characters
set listchars=tab:>-,trail:~
set list

"Insert python comments at the current indent level
au FileType python inoremap # X<BS>#

set ignorecase smartcase incsearch hlsearch "Search preferences

"Extra file extension to type mappings
au! BufRead,BufNewFile *.module,*.install,*.theme setfiletype php
au! BufRead,BufNewFile *.m,*.oct setfiletype octave 
au! BufRead,BufNewFile *.gp setfiletype gnuplot 

"Show list of completions when requested in command mode
set wildmenu wildmode=list:longest,full

set complete=.,w,b,]
"Omnicomplete to <C-space>
inoremap <C-space> <C-x><C-o>
inoremap <Nul> <C-x><C-o>

" Tell vim to remember certain things when we exit
"  '10  :	marks will be remembered for up to 10 previously edited files
"  "100 :	will save up to 100 lines for each register
"  :20  :	up to 20 lines of command-line history will be remembered
"  %    : 	saves and restores the buffer list
"  n... : 	where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

"Persistent undo
let myUndoDir = expand('$HOME/.cache/vim-undo')
call system('mkdir -p ' . myUndoDir)
let &undodir = myUndoDir
set undofile

"*******************
"***** Plugins *****
"*******************

let mapleader = ","

"ALE
let g:ale_lint_on_text_changed = 'never'

" Ctrl-P
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"Used in tComment
let g:tcommentMapLeaderOp1 = ",c"

"Used in tagbar
nmap <F8> :TagbarToggle<CR>

"Used for ack.vim
cnoreabbrev Ack Ack!
nnoremap <Leader>a :Ack!<Space>
let g:ackprg = 'ag --vimgrep'

"Used in easymotion
nmap ; <Plug>(easymotion-s)

"Toggle undotree
nnoremap <F2> :UndotreeToggle<CR>

"Pathogen
call pathogen#helptags()
call pathogen#incubate()
filetype off
syntax on
filetype plugin indent on

colorscheme slate_custom

"*******************
"***** Bindings ****
"*******************


"Use noremap rather than map as this uses the original vim mappings
"when I later remap them. E.g. u is later remapped to k, but I still
"want z to be 'u' (undo), rather than up.

"===== General =====
"'z' stuff like folds and spelling now uses h
noremap h z

"===== Mode switching =====
nnoremap <silent> <Tab> <Esc>:noh<CR>|
vnoremap <Tab> <Esc><Nul>| " <Nul> added to fix select mode problem
inoremap <Tab> <Esc>|

"Insert
noremap s i|
noremap S I|
noremap t a|
noremap T A|
"Visual
nnoremap a v|
nnoremap A V|
" Make insert/add work also in visual line mode like in visual block mode
xnoremap <silent> <expr> s (mode() =~# "[V]" ? "\<C-v>0o$I" : "I")|
xnoremap <silent> <expr> t (mode() =~# "[V]" ? "\<C-v>0o$A" : "A")|
"Replace
noremap r c|

"===== Jumps =====
nnoremap ( <C-o>|
nnoremap ) <C-i>|

"===== Editing things =====
nnoremap <silent> <C-u> :move .-2<CR>|
nnoremap <silent> <C-e> :move .+1<CR>|
vnoremap <silent> <C-u> :move '<-2<CR>gv|
vnoremap <silent> <C-e> :move '>+1<CR>gv|
imap <C-BS> <C-W>

"===== Undo/Redo/Copy+Paste =====
nnoremap z u|
nnoremap Z <C-r>|

noremap c y|
noremap v gP|
noremap C yy|
noremap V p|

"===== Movement mappings =====
noremap n h|
noremap u k|
noremap e j|
noremap i l|

noremap N 5h|
noremap U 5k|
noremap E 5j|
noremap I 5l|

noremap l b|
noremap y w|
noremap L ^|
noremap Y $|

"====== Tabs =====
cnoreabbr <expr> te 'tabedit'|
nnoremap <silent> <C-n> :tabp<CR>|
"<C-i> == <Tab>, so i've set it to this instead
nnoremap <silent> <C-y> :tabn<CR>|

"====== Windows =====
nnoremap <C-w>n <C-w>h|
nnoremap <C-w>u <C-w>k|
nnoremap <C-w>e <C-w>j|
nnoremap <C-w>i <C-w>l|

"====== Search =====
nnoremap <F3> n|
