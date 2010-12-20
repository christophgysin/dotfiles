" Vim filetype detection file
" Language:	syslog-ng configuration
" Author:	Christoph Gysin <christoph.gysin@gmail.com>
" Copyright:	Copyright (c) 2010 Christoph Gysin
" Licence:	You may redistribute this under the same terms as Vim itself
"
" This sets up syntax highlighting for syslog-ng configuration files
"

if &compatible || v:version < 603
    finish
endif


" ebuilds, eclasses
au BufNewFile,BufRead {*/,}syslog-ng{{,.d}/*,.conf}
    \     set filetype=syslog-ng
