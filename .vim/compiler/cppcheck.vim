" vim compiler file
" Compiler:		cppcheck (C++ static checker)
" Maintainer:   Vincent B. (twinside@free.fr)
" Last Change:  2010 mars 14

if exists("cppcheck")
  finish
endif
let current_compiler = "cppcheck"

let s:cpo_save = &cpo
set cpo-=C

setlocal makeprg=cppcheck\ --enable=all\ .
setlocal errorformat=\[%f:%l\]:\ (%t%s)\ %m

let &cpo = s:cpo_save
unlet s:cpo_save

"vim: ft=vim

