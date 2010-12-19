colorscheme inkpot
set mouse=a

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set number

set tags+=~/.vim/stl.tags
"set tags+=~/.vim/efl.tags

let Tlist_Use_Right_Window = 1
let Tlist_Show_Menu = 1
let Tlist_Exit_OnlyWindow = 1

map <F1> <Nop>
map <F2> :AT<cr>
map <F3> :nohls<cr>
map <F4> :!ctags -R .<cr>
map <F8> :make<cr>
map <F9> :Tlist<cr>
map <F10> :copen<cr>
map <F11> :redo<cr>
map <F12> :tabclose<cr>
