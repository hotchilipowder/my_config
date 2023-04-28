curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mv nvim.appimage /usr/bin/nvim
echo "如果不能gitclone, 请打开"
mkdir ~/.config/nvim
curl https://raw.githubusercontent.com/h12345jack/dotfile/master/nvim/init_pure.vim -o ~/.config/nvim
