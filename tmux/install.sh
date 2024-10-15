git clone https://github.com/hotchilipowder/.tmux.git ~/.tmux
ln -s -f .tmux/.tmux.conf 
cp .tmux/.tmux.conf.local .
tmux source-file .tmux.conf
