for tagfile in split(glob(expand("<sfile>:p:h").'/*.tags'), '\n')
    exe "set tags+=".tagfile
endfor
