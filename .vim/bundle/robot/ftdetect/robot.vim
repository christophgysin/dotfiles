" Vim filetype detection file
" Language:	robot configuration
" Author:	Christoph Gysin <christoph.gysin@gmail.com>
" Copyright:	Copyright (c) 2010 Christoph Gysin
" Licence:	You may redistribute this under the same terms as Vim itself
"
" This sets up syntax highlighting for robot files
"

if &compatible || v:version < 603
    finish
endif

au BufNewFile,BufRead {*/,}*.robot
    \     set filetype=robot
