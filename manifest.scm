;; manifest inspired by https://guix.gnu.org/cookbook/en/html_node/Guix-Containers.html
;; Dependencies from: https://openwrt.org/docs/guide-user/additional-software/imagebuilder

(specifications->manifest
 (list 

       ;; base
       "bash-minimal"
       "glibc-locales"
       "nss-certs"

       ;; common tools
       "coreutils"
       "wget"
       "file"
       "gawk"
       "git"
       "gettext"
       "rsync"
       "unzip"
       "python"
       "perl"
       "tar"
       "zstd" ; for tar
       
       ;; build essentials
       "gcc-toolchain"
       "make"

       ;; dependencies
       "ncurses"
       "zlib"
       "libressl"  ;;compatible?
       "libxslt"
       

       ))
