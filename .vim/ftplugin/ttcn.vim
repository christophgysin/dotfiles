" Vim filetype plugin file
" Language:     TTCN-3
" Maintainer:   Stefan Karlsson <stefan.74@comhem.se>
" Last Change:  15 April 2004

if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

if exists("g:ttcn_fold")
    setlocal foldmethod=syntax
    setlocal foldlevel=99
endif

" Path to the dictionary (this path might need adjustment)
setlocal dict=~\vimfiles\dicts\ttcn.dict

" Enables gf, [I, [i, etc commands for ttcn files
setlocal include=^\\s*import\\s\\+from
setlocal suffixesadd=.ttcn

" Disable auto breaking of non-comments
setlocal formatoptions-=t

" Enable auto breaking of comments and enable formatting of comments with
" the gq command
setlocal formatoptions+=croq

setlocal cinoptions=(1s
