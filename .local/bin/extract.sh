#!/bin/sh

# Compressed file formats:
#   -> *.tar.bz2
#   -> *.tar.gz
#   -> *.bz2
#   -> *.rar
#   -> *.gz, *.z
#   -> *.tar
#   -> *.tbz2
#   -> *.tgz
#   -> *.zip
#   -> *.Z
#   -> *.7z
#   -> *.a, *.ar, *.deb (ar)
#   -> *.jar
#   -> *.cpio (cpio)
#   -> *.gzip
#   -> *.bzip2
#   -> *.shar (sharutils)
#   -> *.zst (zstd)
#   -> *.lrz (lrzip)
#   -> *.rz (rzip)
#   -> *.lz (lzip)
#   -> *.xz, *.lzma (xz-utils)
#   -> *.lzo (lzop)
#   -> *.lz4 (lz4)

# if [ -f $1 ] ; then
    # case $1 in
        # *.tar.bz2) tar xjvf $1 ;;
        # *.tar.gz) tar xzvf $1 ;;
        # *.bz2) bunzip2 $1 ;;
        # *.rar) rar x $1 ;;
        # *.gz) gunzip $1 ;;
        # *.tar) tar xf $1 ;;
        # *.tbz2) tar xjvf $1 ;;
        # *.tgz) tar xzvf $1 ;;
        # *.zip) unzip $1 ;;
        # *.Z) uncompress $1 ;;
        # *.7z) 7z x $1 ;;
        # *) echo "'$1' cannot be extracted via extract-file" ;;
    # esac
# else
    # echo "'$1' is not a valid file"
# fi
