git clone https://github.com/hotchilipowder/.tmux.git ~/.tmux
mv ~/.tmux.conf ~/.tmux.conf.bak.$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
cp .tmux/.tmux.conf ~/.tmux.conf
cp .tmux/.tmux.conf.local .
tmux source-file .tmux.conf
