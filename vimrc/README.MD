
## Install Neovim

https://github.com/neovim/neovim/wiki/Installing-Neovim

```
apt install neovim
```


```
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage /usr/bin/nvim
```


### using vimrc for nvim


[nvim-from-vim](https://neovim.io/doc/user/nvim.html#nvim-from-vim)


```
    :call mkdir(stdpath('config'), 'p')
    :exe 'edit '.stdpath('config').'/init.vim'

    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    source ~/.vimrc
```





## Install Vim-Plug

[Install vim-plug](https://github.com/junegunn/vim-plug)

### Unix + Vim

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Unix + NeoVim
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

```
pip3 install --user pynvim
```




### Install zathura

```
brew install zathura --with-synctex
```
如果不确定后面带的参数，可以使用```brew options zathura```进行查看。
然后再键入




### run cp.sh

```
cp vimrc/.vimrc ~/.vimrc
```
