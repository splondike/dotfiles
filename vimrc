" Per machine vimrc customisations
let s:host_vimrc = $HOME . '/.' . hostname() . '.vimrc'
if filereadable(s:host_vimrc)
  execute 'source ' . s:host_vimrc
endif


"*******************
"***** Options *****
"*******************
" {{{
let &titlestring = 'VIM %-00.20t | %{v:servername}'
set title
" titlelen means to not truncate the title so Talon can pull out the long RPC
" socket filename on OSX
set statusline=%00.70F\ %m\ %=%l,%c\ %p%% titlelen=1000
" Always show this to avoid bouncing
set signcolumn=yes

set backspace=2 "Make backspace behave sensibly
set mouse=a "Enable mouse if possible
set tags=./tags; "Climb dir tree until tags is found
set nu
set nospell

set clipboard=unnamed,unnamedplus

set tabstop=4 softtabstop=4 shiftwidth=4 expandtab "Indenting preferences
set smartindent "Automatically indent 'smartly'
"set textwidth=72 "Max width before breaking
set formatoptions=l "No automatic wrapping
set lbr

"Show whitespace characters
set listchars=tab:>-,trail:~
set list

"Give a bit more space for hover messages
set cmdheight=2

set ignorecase smartcase incsearch hlsearch "Search preferences

let mapleader = ","

"Show list of completions when requested in command mode
set wildmenu wildmode=list:longest,full
"Use this to trigger the wild menu in command mode
set wildcharm=<C-Z>

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

"Buffer customisations
" Don't force buffers to be saved when switching
set hidden

" Source ~/.vim/local_vimrc for machine specific global config
runtime local_vimrc

" Fold by default, hR to remove all, hM to get them back, lowercases to
" increment
set foldmethod=indent
set foldlevel=99
" Find auto close annoying at the moment, but maybe in the future?
" set foldclose=all

" }}}

"*******************
"***** Plugins *****
"*******************
" {{{

call plug#begin()
" Library packages
Plug 'nvim-lua/plenary.nvim', { 'commit': '253d34830709d690f013daf2853a9d21ad7accab' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'commit': '584ccea56e2d37b31ba292da2b539e1a4bb411ca'}

" LSP
Plug 'neovim/nvim-lspconfig', {'commit': 'eddaef928c1e1dd79a96f5db45f2fd7f2efe7ea0'}

" Movement packages
Plug 'nvim-telescope/telescope.nvim', { 'commit': '942fe5faef47b21241e970551eba407bc10d9547' }
Plug 'debugloop/telescope-undo.nvim', { 'commit': '231b5ebb4328d2768c830c9a8d1b9c696116848d' }
Plug 'desdic/agrolens.nvim', {  'commit': 'f5833b800a659db4789d518f0d63bb8c6eacbdd7' }
Plug 'ggandor/leap.nvim', { 'commit': '6f2912755c9c4ae790abd829f0cf1b07c037b2a4w' }
Plug 'wellle/targets.vim', { 'commit': '642d3a4ce306264b05ea3219920b13ea80931767' }
Plug 'bkad/CamelCaseMotion', { 'commit': 'de439d7c06cffd0839a29045a103fe4b44b15cdc' }

" Completion
Plug 'neoclide/coc.nvim', { 'commit': 'bbaa1d5d1ff3cbd9d26bb37cfda1a990494c4043' }
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'commit': '1dbacb6f17c46c3beedc506e8007603a759fdcff' }

" Misc packages
Plug 'dense-analysis/ale', { 'commit': '5b1044e2ade71fee4a59f94faa108d99b4e61fb2' }
Plug 'tinted-theming/base16-vim', { 'commit': '79d4fb4575b6e9fab785c44557529240c0b7093a' }
Plug 'SirVer/ultisnips', { 'commit': '0ad238b1910d447476b2d98f593322c1cdb71285' }
Plug 'tomtom/tcomment_vim', { 'commit': 'b4930f9da28647e5417d462c341013f88184be7e' }
Plug 'editorconfig/editorconfig-vim', { 'commit': '30ddc057f71287c3ac2beca876e7ae6d5abe26a0' }
Plug 'ray-x/lsp_signature.nvim', { 'commit': '72b0d4ece23338fe2d03fc7b6fd8c8bace6bb441' }
Plug 'nvim-treesitter/nvim-treesitter-context', { 'commit': '8b6861ebf0ba88e5f57796372eb194787705d25a' }
Plug 'freitass/todo.txt-vim', { 'commit': 'ed9d639de2e34eafb82f2682010ab361966ee40f' }
Plug 'Wansmer/treesj', { 'commit': 'cba4aca075e4a9687cfd34b40328cac06126bc07' }
" Plug 'weilbith/vim-localrc', { 'commit': '7fd606ac361f7058739bb8bce27888efa86c7420' }
"Plug 'joonty/vdebug', { 'commit': '4c6a7caa10e32841dba86ba16acee30781388fdd' }

" Language specific packages
"Plug 'neoclide/vim-jsx-improve', { 'commit': '3eb35b93d91d8f818236f4b019beb2d4accc0916' }
Plug 'leafgarland/typescript-vim', { 'commit': '67e81e4292186889a1a519e1bf3a600d671237eb' }
Plug 'vim-python/python-syntax', { 'commit': 'c1c5bafb6d2333d25e415eb2ec2d0a54a59a21b4' }
Plug 'Vimjas/vim-python-pep8-indent', { 'commit': '60ba5e11a61618c0344e2db190210145083c91f8' }
Plug 'hashivim/vim-terraform', { 'commit': 'f0b17ac9f1bbdf3a29dba8b17ab429b1eed5d443' }

" Vendored packages
Plug '~/.vim/plugged/fzf-basic'
Plug '~/.vim/plugged/my_stuff'
Plug '~/.vim/plugged/todo-txt-time-tracking'
call plug#end()

" }}}

"*******************
"** Plugin config **
"*******************
"{{{

function! s:base16_customize() abort
  call Base16hi("Normal", g:base16_gui06, g:base16_gui00, g:base16_cterm06, g:base16_cterm00, "", "")
  call Base16hi("LineNr", g:base16_gui03, g:base16_gui00, g:base16_cterm03, g:base16_cterm00, "", "")
  call Base16hi("Comment", g:base16_gui04, "", g:base16_cterm04, "", "", "")
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END

let base16colorspace=256
silent! colorscheme base16-tomorrow-night

" Syntax highlight code embedded in markdown. Built in Vim functionality
let g:markdown_fenced_languages = ['python', 'terraform', 'javascript', 'bash']

" Telescope
lua << EOF
    local tele = require('telescope')
    tele.setup({
        defaults = {
            layout_strategy = 'vertical',
            layout_config = {
                vertical = {
                    width = {
                        0.99,
                        max = 100
                    },
                    preview_height = 10,
                }
            },
            mappings = {
                i = {
                    -- Turn off the default vim mode stuff, I don't
                    -- find it useful
                    ["<esc>"] = require('telescope.actions').close,
                }
            },
            file_ignore_patterns = {
                ".git/"
            }
        },
        pickers = {
            buffers = {
                sort_lastused = true
            },
        },
    })
    tele.load_extension('undo')
    tele.load_extension('agrolens')
EOF
" See https://stackoverflow.com/questions/74448018/neovim-broken-syntax-highlighting-after-heredoc-lua-eof-in-vimscript/75191068#75191068 for broken highlighter fix "
nnoremap <Leader>f :Telescope find_files<CR>
nnoremap <Leader>t :Telescope oldfiles<CR>
nnoremap <Leader>g :Telescope live_grep<CR>
nnoremap <Leader>d :Telescope agrolens query=functions<CR>
nnoremap <Leader>pg :Telescope git_status<CR>
nnoremap <F2> :Telescope undo<CR>

" Treesj
lua << EOF
local tsj = require('treesj')

local langs = {--[[ configuration for languages ]]}

tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 500,
  cursor_behavior = 'hold',
  notify = true,
  langs = langs,
  dot_repeat = false,
})
EOF
nnoremap <Leader>m :TSJToggle<CR>

"LSPs
lua << EOF
local lspconfig = require('lspconfig')
lspconfig.jedi_language_server.setup {}
EOF

"Used in tComment
let g:tcomment_opleader1 = ",c"

"Leap.nvim
nnoremap <silent> p <Plug>(leap-forward-to)
nnoremap <silent> P <Plug>(leap-backward-to)

"CamelCaseMotion
omap <silent> si <Plug>CamelCaseMotion_ie
xmap <silent> si <Plug>CamelCaseMotion_ie

" CoC (Intellisense/completion)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
call coc#config('suggest.noselect', v:true)
inoremap <silent><expr> <C-e>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#refresh()
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-p>"


" Ultisnips
let g:UltiSnipsExpandTrigger="hh"
let g:UltiSnipsJumpForwardTrigger="hh"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

" targets.vim
let g:targets_aiAI = 'tsTS'

" todo.txt-vim
let maplocalleader=" "
highlight link TodoPriorityA Normal
highlight link TodoPriorityB Normal
highlight link TodoPriorityC Normal

" Better colours for JSX syntax highlighter
let g:vim_jsx_pretty_colorful_config = 1 " default 0

" }}}

"*******************
"**** Languages ****
"*******************
"{{{

augroup python
    au!
    autocmd FileType python nnoremap <buffer> hF :setlocal foldmethod=indent<cr>
augroup END

augroup vim
    au!
    autocmd FileType vim set foldmethod=marker
augroup END

augroup todo
    au!
    autocmd FileType todo nnoremap <buffer> <localleader>t :call todotxt#timetracking#toggle()<cr>
augroup END

" }}}

"*******************
"***** Bindings ****
"*******************
"{{{

"Use noremap rather than map as this uses the original vim mappings
"when I later remap them. E.g. u is later remapped to k, but I still
"want z to be 'u' (undo), rather than up.

" Text objects can be used with as" -> select within quotes, at" -> select
" around quotes
for textObject in ['w', 'W', 's', 'p']
    " Loop to remap some built in objects. targets.vim does the rest.
    execute printf('xnoremap s%s i%s', textObject, textObject)
    execute printf('onoremap s%s i%s', textObject, textObject)
    execute printf('xnoremap t%s a%s', textObject, textObject)
    execute printf('onoremap t%s a%s', textObject, textObject)

    " Remove the original commands.
    execute printf('xnoremap a%s <Nop>', textObject)
    execute printf('onoremap a%s <Nop>', textObject)
    execute printf('xnoremap i%s <Nop>', textObject)
    execute printf('onoremap i%s <Nop>', textObject)
endfor

"===== General =====
"'z' stuff like folds and spelling now uses h. hf folds visual mode highlight,
"hc ho hO are close fold, open first fold, open nested folds. :setlocal
"foldmethod=indent or foldmethod=syntax to trigger automatic folds
noremap h z
" Paste in a timestamp in insert mode
inoremap <F12> <C-R>=strftime("%H:%M:%S")<CR>
" Use ,s to swap between most recent buffers
nnoremap <Leader>s <C-^>

" Base64 decode from https://stackoverflow.com/a/7846569
vnoremap <leader>64 c<c-r>=trim(system('base64', @"))<cr><esc>"
vnoremap <leader>46 c<c-r>=system('base64 --decode', @")<cr><esc>"

" Edit relative to current buffer
cnoremap <expr> e; "e " . expand("%:h") . "/"

"===== Mode switching =====
" Switch to normal mode from insert by typing hh
nnoremap <silent> <Tab> <Esc>:noh<CR>|

"Use semicolon instead of colon to enter command mode from normal and
"visual modes
map ; :

"Insert
nnoremap s i|
nnoremap S I|
nnoremap t a|
nnoremap T A|
"Visual
nnoremap a v|
nnoremap A V|
"Replace
noremap r c|

"===== Jumps =====
nnoremap ( <C-o>|
nnoremap ) <C-i>|

"===== Editing things =====
nnoremap <silent> <C-f> :move .-2<CR>|
nnoremap <silent> <C-s> :move .+1<CR>|
vnoremap <silent> <C-f> :move '<-2<CR>gv|
vnoremap <silent> <C-s> :move '>+1<CR>gv|
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
noremap <C-u> 5k|
noremap <C-e> 5j|

noremap l b|
noremap y w|
noremap L ^|
noremap Y ^|
noremap <C-l> ^|
noremap <C-y> $|

"====== Windows =====
nnoremap <C-w>n <C-w>h|
nnoremap <C-w>u <C-w>k|
nnoremap <C-w>e <C-w>j|
nnoremap <C-w>i <C-w>l|

"====== Search =====
nnoremap <C-i> n|
nnoremap <C-o> N|

"====== Misc =====
" Used by my Talon scripts to cancel any pending repeat or operator
" pending commands
noremap <F4> :echo<cr>
inoremap <F4> <Nop>
cnoremap <F4> <Nop>
vnoremap <F4> <Nop>

" }}}
