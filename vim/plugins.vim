
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs 
    \ https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

" bling, bling
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'
Plug 'jonathanfilip/vim-lucius'
Plug 'bling/vim-airline'

" coding
Plug 'editorconfig/editorconfig-vim'

" blitz-open
Plug 'kien/ctrlp.vim'

call plug#end()
