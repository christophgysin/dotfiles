au BufNewFile,BufRead *.j2
    \ exec "set ft=" . substitute(bufname('%'), '.*\.\([^.]*\)\.j2', '\1', '')
