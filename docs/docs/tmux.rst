==================
Tmux Configuration
==================

Install Tmux
============


.. tabs::

   .. tab:: MacOS
        
     .. code-block:: bash

         brew install tmux


   .. tab:: Linux (APT)

     .. code-block:: bash

         apt install tmux

   .. tab::  Linux (Source)
    
        First, please keep \ :code:`~/.local/bin`\ in the \ :code:`PATH`\, then \ :code:`make && make install`\ in the \ :code:`tmp/`\ dir.

        .. code-block:: bash

            mkdir tmp
            cd tmp/
            curl -OL https://invisible-island.net/datafiles/release/ncurses.tar.gz
            tar -xvf ncurses.tar.gz
            
            LOC=$(curl -s https://api.github.com/repos/libevent/libevent/releases/latest | grep "browser_download_url"|  awk '{ print $2 }' | awk -F '[\"\"]' '{print $2}' | grep tar.gz$ ) ; curl -OLl  $LOC
            
            LOC=$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | grep "browser_download_url" | awk '{ print $2 }' | awk -F '[\"\"]' '{print $2}'); curl -OL $LOC
            
            # install libevent
            mkdir $HOME/.local
            cd $HOME/tmp
            tar -zxf libevent*.tar.gz
            cd libevent-*/
            ./configure --prefix=$HOME/.local --enable-shared
            make && make install
            
            cd $HOME/tmp
            tar -zxf ncurses*.tar.gz
            cd ncurses*/
            ./configure --prefix=$HOME/.local --with-shared --with-termlib --enable-pc-files --with-pkg-config-libdir=$HOME/.local/lib/pkgconfig
            make && make install
            
            # install tmux
            cd $HOME/tmp
            tar -zxf tmux-*.tar.gz
            cd tmux-*/
            PKG_CONFIG_PATH=$HOME/.local/lib/pkgconfig ./configure --prefix=$HOME/.local
            make && make install



Why tmux instead of Zellij
==========================

其实我还真的挺喜欢\ :literal:`Rust`\的，但是对于\ :literal:`Zellij`\的使用体验确实不太好。
所以最后还是选用了\ :literal:`tmux`\.

具体的启用包括复制下面的config到\ :code:`~/.tmux.conf`\,然后\ :code:`tmux source-file .tmux.conf`\即可。

.. dropdown:: \ :code:`~/.tmux.conf`\

    .. literalinclude:: ../../tmux/.tmux.conf
       :language: bash


Tmux with Neovim
================

The basic useful for my tmux with neovim is `vim-tmux-navigator <https://github.com/christoomey/vim-tmux-navigator>`_, 但是这个最大的问题就是其中 \ :code:`<C-\\>`\ 和 \ `toggleterm.nvim <https://github.com/akinsho/toggleterm.nvim>`_\  设置的快捷键冲突了， 所以只能取消了。


.. attention::

    使用 \ :code:`:nmap <C-\\>`\ 就能看出来了

    + :code:`:nmap` for normal mode mappings
    + :code:`:vmap` for visual mode mappings
    + :code:`:imap` for insert mode mappings


.. tabs::

   .. tab:: Lazy.nvim

     .. code-block:: bash
     
        {
          'christoomey/vim-tmux-navigator',
          keys={
            {'<C-h>', ':<C-U>TmuxNavigateLeft<cr>'},
            {'<C-j>', ':<C-U>TmuxNavigateDown<cr>'},
            {'<C-k>', ':<C-U>TmuxNavigateUp<cr>'},
            {'<C-l>', ':<C-U>TmuxNavigateRight<cr>'},
          },
        },
         

   .. tab:: Plug

     .. code-block:: bash
     

         Plug 'christoomey/vim-tmux-navigator',

        let g:tmux_navigator_no_mappings = 1
        noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
        noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
        noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
        noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
     
     

