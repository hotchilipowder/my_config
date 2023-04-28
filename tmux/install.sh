git clone https://github.com/h12345jack/.tmux.git ~/.tmux
ln -s -f .tmux/.tmux.conf 
cp .tmux/.tmux.conf.local .
tmux source-file .tmux.conf
