curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

chmod u+x nvim.appimage
mv nvim.appimage /usr/bin/nvim
mkdir ~/.config/
mkdir ~/.config/nvim

curl -L https://raw.githubusercontent.com/h12345jack/dotfile_public/master/nvim/init-coc.vim  --output ~/.config/nvim/init.vim
curl https://codeload.github.com/h12345jack/dotfile_public/tar.gz/master | tar -xz --strip=2 dotfile_public-master/nvim/ -C ~/.config/nvim/

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'



curl -sL install-node.vercel.app/lts | bash


pip3 install neovim
