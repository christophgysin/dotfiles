scriptencoding utf-8

let no_flake8_maps=1
execute pathogen#infect()

set nocompatible
set mouse=a
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set expandtab
set list listchars=tab:>-,trail:·
set viminfo='1000,f1,:1000,/1000
set backspace=indent,eol,start
set showcmd
set showmatch
set incsearch
set ignorecase
set infercase
set hlsearch
set showfulltag
set lazyredraw
set noerrorbells
set visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
set scrolloff=3
set sidescrolloff=2
set nowrap
set whichwrap+=<,>,[,]
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*~
set hidden
set winminheight=1
set textwidth=80
syntax on
set switchbuf=useopen,usetab,newtab
set undodir=~/.vim/undo
set undofile

set secure
set exrc

" splits
set splitbelow
set splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" fix whitespace
"command Fixws :retab<CR>:%s/\s\+$//<CR>

" Try to load a nice colourscheme
fun! LoadColourScheme(schemes)
    let l:schemes = a:schemes . ":"
    while l:schemes != ""
        let l:scheme = strpart(l:schemes, 0, stridx(l:schemes, ":"))
        let l:schemes = strpart(l:schemes, stridx(l:schemes, ":") + 1)
        try
            exec "colorscheme" l:scheme
            break
        catch
        endtry
    endwhile
endfun

if has('gui')
    call LoadColourScheme("inkpot:torte:night:rainbow_night:darkblue:elflord")
else
    if &t_Co == 88 || &t_Co == 256
        call LoadColourScheme("inkpot:torte:darkblue:elflord")
    else
        call LoadColourScheme("torte:darkblue:elflord")
    endif
endif

" Do clever indent things. Don't make a # force column zero.
set autoindent
set smartindent
inoremap # X<BS>#

" Enable folds...
set foldmethod=indent
" ...but open all folds
set nofoldenable

" Syntax when printing
set popt+=syntax:y

" extra tags
source ~/.vim/tags/tags.vim

" Enable filetype settings
filetype on
filetype plugin on
filetype indent on

set modeline

" Nice statusbar
set laststatus=2
set statusline=
set statusline+=%n/                         " buffer number
set statusline+=%{len(filter(range(1,bufnr('$')),'buflisted(v:val)'))}\  "number of ubbfers
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%=                           " right align
set statusline+=0x%-8B\                      " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" If possible, try to use a narrow number column.
try
    setlocal numberwidth=3
catch
endtry

set fillchars=fold:-

set dictionary=/usr/share/dict/words

" draw numbers in wide windows
autocmd BufEnter * :call <SID>WindowWidth()
" Turn off search highlight when idle
autocmd CursorHold * nohls | redraw

" Always do a full syntax refresh
autocmd BufEnter * syntax sync fromstart

" For help files, move them to the top window and make <Return>
" behave like <C-]> (jump to tag)
autocmd FileType help :call <SID>WindowToTop()
autocmd FileType help nmap <buffer> <Return> <C-]>

" If we're in a wide window, enable line numbers.
fun! <SID>WindowWidth()
    if bufname("%") != "-MiniBufExplorer-"
        if winwidth(0) > 90
            setlocal foldcolumn=1
            setlocal number
        else
            setlocal nonumber
            setlocal foldcolumn=0
        endif
    endif
endfun

" Force active window to the top of the screen without losing its
" size.
fun! <SID>WindowToTop()
    let l:h=winheight(0)
    wincmd K
    execute "resize" l:h
endfun

" Force active window to the bottom of the screen without losing its
" size.
fun! <SID>WindowToBottom()
    let l:h=winheight(0)
    wincmd J
    execute "resize" l:h
endfun

command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction

nmap   <silent> <S-Right>  :bnext<CR>

" Make <space> in normal mode go down a page rather than left a
" character
noremap <space> <C-f>

" Map key to toggle opt
function MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

" Commonly used commands
MapToggle <F1> paste
nmap <F2> :AT<CR>
MapToggle <F3> hlsearch
map <F4> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q . && cscope -Rb<CR>
map <F6> :bprev<CR>
map <F7> :bnext<CR>
nmap <F8> :make<CR>
nnoremap <silent> <F9> :Tlist<CR>
map <silent> <F10> :QFix<CR>
map <silent> <F11> :redo<CR>
nmap <F12> :bd<CR>
map <S-PageUp> :cprev<CR>
map <S-PageDown> :cnext<CR>

" Insert a single char
noremap <Leader>i i<Space><Esc>r

" Split the line
nmap <Leader>n \i<CR>

" Pull the following line to the cursor position
noremap <Leader>J :s/\%#\(.*\)\n\(.*\)/\2\1<CR>

" In normal mode, jj escapes
inoremap jj <Esc>

" Select everything
noremap <Leader>gg ggVG

" Reformat everything
noremap <Leader>gq gggqG

" Reformat paragraph
noremap <Leader>gp gqap

" Clear lines
noremap <Leader>clr :s/^.*$//<CR>:nohls<CR>

" Delete blank lines
noremap <Leader>dbl :g/^$/d<CR>:nohls<CR>

" Enclose each selected line with markers
noremap <Leader>enc :<C-w>execute
            \ substitute(":'<,'>s/^.*/#&#/ \| :nohls", "#", input(">"), "g")<CR>

" save as root
cmap w!! w !sudo tee '%' >/dev/null

" set up some more useful digraphs
digraph ., 8230    " ellipsis (â€¦)

" GNU format changelog entry
fun! MakeChangeLogEntry()
    norm gg
    /^\d
    norm 2O
    norm k
    call setline(line("."), strftime("%Y-%m-%d") .
                \ " Christoph Gysin <christoph.gysin@gmail.com>")
    norm 2o
    call setline(line("."), "\t* ")
    norm $
endfun
noremap ,cl :call MakeChangeLogEntry()<CR>

" plugin / script / app settings

" Vim specific options
let g:vimsyntax_noerror=1

" Settings for taglist.vim
let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=0
let Tlist_Enable_Fold_Column=0
let Tlist_Compact_Format=1
let Tlist_WinWidth=28
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close = 1
"autocmd FileType c,cpp :Tlist

" Settings for a.vim
let g:alternateExtensions_h = "c,cc,cpp"
let g:alternateExtensions_hh = "cc,cpp"
let g:alternateExtensions_cc = "h,hh,hpp"
let g:alternateExtensions_cpp = "h,hh,hpp"
let g:alternateSearchPath = '../source,../src,../../src,../include,../inc,../../inc'
let g:alternateNoDefaultAlternate = 1

" Settings minibufexpl.vim
let g:miniBufExplWinFixHeight = 1
let g:miniBufExplForceSyntaxEnable = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" Settings for showmarks.vim
if has("gui_running")
    let g:showmarks_enable=1
else
    let g:showmarks_enable=0
    let loaded_showmarks=1
endif

" Settings for explorer.vim
let g:explHideFiles='^\.'

" Settings for netrw
let g:netrw_list_hide='^\.,\~$'

" Settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

" syntastic
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11'

" final commands

" turn off any existing search
autocmd VimEnter * nohls

if filereadable(glob('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" vim: set shiftwidth=4 softtabstop=4 expandtab tw=72
