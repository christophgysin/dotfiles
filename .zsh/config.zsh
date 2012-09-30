# disable auto-correct
unsetopt correct_all

# fix completion of ..
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'
