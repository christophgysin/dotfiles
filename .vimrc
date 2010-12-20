scriptencoding utf-8

"-----------------------------------------------------------------------
" terminal setup
"-----------------------------------------------------------------------

" Extra terminal things
"if ($TERM == "rxvt-unicode") && (&termencoding == "")
"    set termencoding=utf-8
"endif

"-----------------------------------------------------------------------
" settings
"-----------------------------------------------------------------------

" Enable mouse
set mouse=a

" Tabulator settings
set tabstop=4
set softtabstop=4
set smarttab
set shiftwidth=4
set expandtab

" Show tabs and trailing whitespace visually
set list listchars=tab:\ \ ,trail:·,extends:…,nbsp:‗
"set list listchars=tab:>-,trail:.,extends:>

" Don't be compatible with vi
set nocompatible

" Enable a nice big viminfo file
set viminfo='1000,f1,:1000,/1000

" Make backspace delete lots of things
set backspace=indent,eol,start

" Create backups
set backup
set backupdir=~/.vim/backup

" Show us the command we're typing
set showcmd

" Highlight matching parens
set showmatch

" Search options: incremental search, do clever case things, highlight
" search
set incsearch
set ignorecase
set infercase
set hlsearch

" Show full tags when doing search completion
set showfulltag

" Speed up macros
set lazyredraw

" No annoying error noises
set noerrorbells
set visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Try to show at least three lines and two columns of context when
" scrolling
set scrolloff=3
set sidescrolloff=2

set nowrap
" Wrap on these
set whichwrap+=<,>,[,]

" Use the cool tab complete menu
set wildmenu
set wildignore=*.o,*~

" Allow edit buffers to be hidden
set hidden

" 1 height windows
set winminheight=1

" Enable syntax highlighting
syntax on

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
    call LoadColourScheme("inkpot:night:rainbow_night:darkblue:elflord")
else
    if &t_Co == 88 || &t_Co == 256
        call LoadColourScheme("inkpot:darkblue:elflord")
    else
        call LoadColourScheme("darkblue:elflord")
    endif
endif

" No icky toolbar, menu or scrollbars in the GUI
if has('gui')
    set guioptions-=m
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R

" Set our fonts
    set guifont=courier"
    "set guifont=Terminus/12/-1/5/50/0/0/0/0/0
    "set guifont=Terminus\ 12
    "set guifont=-xos4-terminus-medium-r-normal--10-140-72-72-c-80-iso8859-1
    "set guifont=-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso10646-1
end

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
set tags+=~/.vim/tags/stl
set tags+=~/.vim/tags/linux

" Enable filetype settings
filetype on
filetype plugin on
filetype indent on

" Enable modelines only on secure vim versions
if (v:version == 603 && has("patch045")) || (v:version > 603)
    set modeline
else
    set nomodeline
endif

" Nice statusbar
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
if filereadable(expand("$VIM/vimfiles/plugin/vimbuddy.vim"))
    set statusline+=\ %{VimBuddy()}          " vim buddy
endif
set statusline+=%=                           " right align
set statusline+=0x%-8B\                      " current char
set statusline+=%-14.(%l,%c%V%)\ %<%P        " offset

" If possible, try to use a narrow number column.
try
    setlocal numberwidth=3
catch
endtry

" Include $HOME in cdpath
"let &cdpath=','.expand("$HOME")

set fillchars=fold:-

"-----------------------------------------------------------------------
" completion
"-----------------------------------------------------------------------
set dictionary=/usr/share/dict/words

"-----------------------------------------------------------------------
" autocmds
"-----------------------------------------------------------------------

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

"-----------------------------------------------------------------------
" mappings
"-----------------------------------------------------------------------
" rvxt escape sequences
"nmap <ESC>[5^ <C-PageUp>
"nmap <ESC>[6^ <C-PageDown>

" tab navigation
map  <M-Right> :tabnext<CR>
map  <M-Left> :tabprev<CR>
map  <C-Right> :tabnext<CR>
map  <C-Left> :tabprev<CR>

"map  <C-Right> :tabnext<CR>
"vmap <C-Right> :tabnext<CR>
"imap <C-Right> :tabnext<CR>
"map  <C-Left> :tabprev<CR>
"vmap <C-Left> :tabprev<CR>
"imap <C-Left> :tabprev<CR>
"map  <C-t> :tabnew<CR>
"vmap <C-t> :tabnew<CR>
"imap <C-t> :tabnew<CR>
"map  <C-w> :tabclose<CR>
"vmap <C-w> :tabclose<CR>
"imap <C-w> :tabclose<CR>

nmap   <silent> <S-Right>  :bnext<CR>

" Delete a buffer but keep layout
command! Kwbd enew|bw #
nmap     <C-w>!   :Kwbd<CR>

" Annoying default mappings
inoremap <S-Up>   <C-o>gk
inoremap <S-Down> <C-o>gj
noremap  <S-Up>   gk
noremap  <S-Down> gj

" Make <space> in normal mode go down a page rather than left a
" character
"noremap <space> <C-f>

" Useful things from inside imode
"inoremap <C-z>w <C-o>:w<CR>
"inoremap <C-z>q <C-o>gq}<C-o>k<C-o>$

" Commonly used commands
map <F1> <Nop>
imap <F1> <Nop>

nmap <F2> :AT<CR>
nmap <silent> <F3> :silent nohlsearch<CR>
imap <silent> <F3> <C-o>:silent nohlsearch<CR>
map <F4> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q . && cscope -Rb<CR>
map <F5> :NERDTreeToggle<CR>
imap <F5> <C-o>:NERDTreeToggle<CR>
"nmap <F6>
"nmap <F7> :so %<CR>
nmap <F8> :make<CR>
nnoremap <silent> <F9> :Tlist<CR>
map <silent> <F10> :QFix<CR>
map <silent> <F11> :redo<CR>
nmap <F12> :tabclose<CR>

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

" Enable fancy % matching
runtime! macros/matchit.vim

" q: sucks
nmap q: :q

" set up some more useful digraphs
digraph ., 8230    " ellipsis (…)

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

" command aliases, can't call these until after cmdalias.vim is loaded
au VimEnter * if exists("loaded_cmdalias") |
            \       call CmdAlias("mkdir",   "!mkdir") |
            \       call CmdAlias("cvs",     "!cvs") |
            \       call CmdAlias("svn",     "!svn") |
            \       call CmdAlias("commit",  "!svn commit -m \"") |
            \       call CmdAlias("upload",  "make upload") |
            \ endif

"-----------------------------------------------------------------------
" special less.sh and man modes
"-----------------------------------------------------------------------

fun! <SID>is_pager_mode()
    let l:ppidc = ""
    try
        if filereadable("/lib/libc.so.6")
            let l:ppid = libcallnr("/lib/libc.so.6", "getppid", "")
        elseif filereadable("/lib/libc.so.0")
            let l:ppid = libcallnr("/lib/libc.so.0", "getppid", "")
        else
            let l:ppid = ""
        endif
        let l:ppidc = system("ps -p " . l:ppid . " -o comm=")
        let l:ppidc = substitute(l:ppidc, "\\n", "", "g")
    catch
    endtry
    return l:ppidc ==# "less.sh" ||
                \ l:ppidc ==# "vimpager" ||
                \ l:ppidc ==# "manpager.sh" ||
                \ l:ppidc ==# "vimmanpager"
endfun
if <SID>is_pager_mode()
    " we're in vimpager / less.sh / man mode
    set laststatus=0
    set ruler
    set foldmethod=manual
    set foldlevel=99
    set nolist
endif

"-----------------------------------------------------------------------
" plugin / script / app settings
"-----------------------------------------------------------------------

" Perl specific options
let perl_include_pod=1
let perl_fold=1
let perl_fold_blocks=1

" Vim specific options
let g:vimsyntax_noerror=1

" Settings for taglist.vim
let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=1
let Tlist_Enable_Fold_Column=0
let Tlist_Compact_Format=1
let Tlist_WinWidth=28
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close = 1

" Autostart taglist for code
"autocmd FileType c,cpp :Tlist

" Settings minibufexpl.vim
"let g:miniBufExplModSelTarget = 1
"let g:miniBufExplWinFixHeight = 1
" let g:miniBufExplForceSyntaxEnable = 1

" Settings for showmarks.vim
if has("gui_running")
    let g:showmarks_enable=1
else
    let g:showmarks_enable=0
    let loaded_showmarks=1
endif

autocmd VimEnter *
            \ if has('gui') |
            \        highlight ShowMarksHLl gui=bold guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight ShowMarksHLu gui=none guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight ShowMarksHLo gui=none guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight ShowMarksHLm gui=none guifg=#a0a0e0 guibg=#2e2e2e |
            \        highlight SignColumn   gui=none guifg=#f0f0f8 guibg=#2e2e2e |
            \    endif

" Settings for explorer.vim
let g:explHideFiles='^\.'

" Settings for netrw
let g:netrw_list_hide='^\.,\~$'

" Settings for :TOhtml
let html_number_lines=1
let html_use_css=1
let use_xhtml=1

" cscope settings
"if has('cscope') && filereadable("/usr/bin/cscope")
"    set csto=0
"    set cscopetag
"    set nocsverb
"    if filereadable("cscope.out")
"        cs add cscope.out
"    endif
"    set csverb
"
"    let x = "sgctefd"
"    while x != ""
"        let y = strpart(x, 0, 1) | let x = strpart(x, 1)
"        exec "nmap <C-j>" . y . " :cscope find " . y .
"                    \ " <C-R>=expand(\"\<cword\>\")<CR><CR>"
"        exec "nmap <C-j><C-j>" . y . " :scscope find " . y .
"                    \ " <C-R>=expand(\"\<cword\>\")<CR><CR>"
"    endwhile
"    nmap <C-j>i      :cscope find i ^<C-R>=expand("<cword>")<CR><CR>
"    nmap <C-j><C-j>i :scscope find i ^<C-R>=expand("<cword>")<CR><CR>
"endif

"-----------------------------------------------------------------------
" final commands
"-----------------------------------------------------------------------

" turn off any existing search
autocmd VimEnter * nohls

"-----------------------------------------------------------------------
" vim: set shiftwidth=4 softtabstop=4 expandtab tw=72                  :
