====================
Neovim and Tmux
====================



Install Neovim
==============

Requirements
------------

Because My neovim config has lsp config, install nodejs is necessary. \ `Download Node.js <https://nodejs.org/en/download/package-manager>`_




.. tab-set::

   .. tab-item::  Linux (~/.local) 

    .. code-block:: bash

      curl -OL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
      tar -xvf nvim-linux64.tar.gz -C ~/.local --strip-components=1


   .. tab-item::  Linux (AppImage)

    .. code-block:: bash

      curl -OL https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
      chmod u+x nvim.appimage
      mv nvim.appimage nvim

   .. tab-item:: MacOS (homebrew)

    .. code-block:: bash
    
      brew install neovim 

   .. tab-item:: MacOS (Pre-built archives)

    .. code-block:: bash
    
      curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz
      tar xzf nvim-macos.tar.gz
      ./nvim-macos/bin/nvim

   .. tab-item:: Others 

      see \ `install neovim <https://github.com/neovim/neovim/wiki/Installing-Neovim>`_


Install Tmux
============


.. tab-set::

   .. tab-item:: MacOS
        
     .. code-block:: bash

         brew install tmux


   .. tab-item:: Linux (APT)

     .. code-block:: bash

         apt install tmux

   .. tab-item::  Linux (Source)
    
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


Why Neovim instead of Vim
=========================

其实本人之前一直是使用\ :literal:`vim`\的，而后被\ :literal:`neovim`\的速度所吸引。
在无痛切换到nvim之后，最后实在是忍不住切换到\ :literal:`init.lua`\。
总体而言，比较讨厌写多个文件，喜欢使用\ :code:`<Space>fed`\去打开配置文件，然后复制粘贴即可。

有许多关于使用plug文件夹和多个不同插件配置的方式，我个人不是很喜欢。
我更喜欢\ `kickstart.nvim <https://github.com/nvim-lua/kickstart.nvim>`_\ 这样的方式。

由于 [kickstart]_ 使用的 [lazy.nvim]_, 所以也就切换到了 [lazy.nvim]_ 

具体的配置如下：

.. code-block:: bash

   mkdir -p ~/.config/nvim && curl -SL https://raw.githubusercontent.com/hotchilipowder/my_config/main/nvim/init.lua -o ~/.config/nvim/init.lua
  

.. dropdown:: ~/.config/nvim/init.lua

    .. literalinclude:: ../../nvim/init.lua
       :language: lua

Why tmux instead of Zellij
==========================

其实我还真的挺喜欢\ :literal:`Rust`\的，但是对于\ :literal:`Zellij`\的使用体验确实不太好。
所以最后还是选用了\ :literal:`tmux`\.

具体的启用包括复制下面的config到\ :code:`~/.tmux.conf`\,然后\ :code:`tmux source-file .tmux.conf`\即可。

.. code-block:: bash

  curl -SL https://raw.githubusercontent.com/hotchilipowder/my_config/refs/heads/main/tmux/.tmux.conf -o ~/.tmux.conf
  tmux source-file ~/.tmux.conf





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


.. tab-set::

   .. tab-item:: Lazy.nvim

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
         

   .. tab-item:: Plug

     .. code-block:: bash
     

         Plug 'christoomey/vim-tmux-navigator',

        let g:tmux_navigator_no_mappings = 1
        noremap <silent> {Left-Mapping} :<C-U>TmuxNavigateLeft<cr>
        noremap <silent> {Down-Mapping} :<C-U>TmuxNavigateDown<cr>
        noremap <silent> {Up-Mapping} :<C-U>TmuxNavigateUp<cr>
        noremap <silent> {Right-Mapping} :<C-U>TmuxNavigateRight<cr>
     
     






Awesome Neovim Plugins
======================

vim-tmux-navigator
------------------

`vim-tmux-navigator <https://github.com/christoomey/vim-tmux-navigator>`_

more config see  :doc:`tmux.rst <./tmux>` 

这里之前有



bufferline.nvim
---------------

`bufferline.nvim <https://github.com/akinsho/bufferline.nvim>`_

This is a very interesting plugin for the bufferline. 
不过由于这个插件只开buffer，不好关闭（点击叉关闭对于纯键盘党而言太麻烦)，所以需要定义一个关闭的快捷键, 我定义为 \ :code:`<Space>q`\, see \ `close current buffer <https://github.com/akinsho/bufferline.nvim/issues/513>`_

另外 \ :code:`<Space> + RightArrow`\ 可以实现关闭当前buffer右侧的buffer。这个也比较好用.

.. code-block:: bash

    {
      'akinsho/bufferline.nvim',
      version = "v3.*", 
      dependencies = 'nvim-tree/nvim-web-devicons',
      keys={
        {'<Tab>', '<Cmd>BufferLineCycleNext<CR>'},
        {'<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', {}},
        {'<Space><Right>', '<Cmd>BufferLineCloseRight<CR>', {}},
        {'<Space>q', '<Cmd>:bp <BAR> bd #<CR>', {}},
        {'<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>'},
        {'<leader>2', '<Cmd>BufferLineGoToBuffer 2<CR>'},
        {'<leader>3', '<Cmd>BufferLineGoToBuffer 3<CR>'},
        {'<leader>4', '<Cmd>BufferLineGoToBuffer 4<CR>'},
        {'<leader>5', '<Cmd>BufferLineGoToBuffer 5<CR>'},
        {'<leader>6', '<Cmd>BufferLineGoToBuffer 6<CR>'},
        {'<leader>7', '<Cmd>BufferLineGoToBuffer 7<CR>'},
        {'<leader>8', '<Cmd>BufferLineGoToBuffer 8<CR>'},
        {'<leader>9', '<Cmd>BufferLineGoToBuffer 9<CR>'},
        {'<leader>$', '<Cmd>BufferLineGoToBuffer -1<CR>'},
      }
      config = function()
        require("bufferline").setup()
      end,
    },

alpha-nvim
----------

这个比较简单，就是开启后的欢迎页面.

.. figure:: https://user-images.githubusercontent.com/24906808/133367667-0f73e9e1-ea75-46d1-8e1b-ff0ecfeafeb1.png
    :alt: alpha-nvim start 


tpope大佬系列
--------------

主要包括 
    
+ `tpope/vim-surround <https://github.com/tpope/vim-surround>`_ : \ :code:`di<`\ for \ :code:`<xxx>`\
+ `tpope/vim-fugitive <https://github.com/tpope/vim-fugitive>`_ : \ :code:`:Git`\
+ `tpope/vim-rhubarb <https://github.com/tpope/vim-rhubarb>`_ : \ :code:`:GBrower`\
+ `tpope/vim-sleuth <https://github.com/tpope/vim-sleuth>`_ : Automatically adjusts 'shiftwidth' and 'expandtab' heuristically based on the current file


之前还有一个 \ `vim-commentary <https://github.com/tpope/vim-commentary>`_\ , 不过我还是用 \ `Comment.nvim <https://github.com/numToStr/Comment.nvim>`_\ 替代了。我相信 \ :code:`lua is better than vimscript`\ (see \ `你们的vim配置都换成lua了吗？ <https://www.zhihu.com/question/445290918>`_\ .


toggleterm.nvim
---------------

`toggleterm <thttps://github.com/akinsho/toggleterm.nvim>`_

.. code-block:: bash

    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end
    
    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')


nvim-tree.lua
-------------

`nvim-tree.lua <https://github.com/nvim-tree/nvim-tree.lua>`_

其实最早我用的是 \ `nerdtree <https://github.com/preservim/nerdtree>`_ ，但是 \ `开发者退休了 <https://github.com/preservim/nerdtree/issues/1280>`_. （很感谢他的付出）

核心的配置: 

+ \ :code:`<space>pt`\ open tree
+ \ :code:`<space>r`\ refresh
+ \ :code:`r`\ rename 
+ \ :code:`a`\ add


.. code-block:: bash

  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    opts={
      sort_by = "case_sensitive",
      view = {
        adaptive_size = true,
      },
      renderer = {
        group_empty = true,
      },
      git = {
        ignore = false
      },
      filters = {
        dotfiles = false,
      },
    },
    keys = {
      {'<leader>pt', ':NvimTreeToggle<CR>', mode=''},
      {'<leader>r', ':NvimTreeRefresh<CR>', mode='n'}
    }
  }


.. attention::
  hey!

Symbols-outline
---------------

\ `Symbols-outline <https://github.com/simrat39/symbols-outline.nvim>`_

核心的命令包括:

.. list-table:: Symbols-outline Commands
   :widths: 50 50
   :header-rows: 1

   * - Commonds 
     - Meannings
   * - \ :code:`SymbolsOutline`\ 
     - Toggle symbols outline
   * - \ :code:`SymbolsOutlineOpen`\
     - Open symbols outline
   * - \ :code:`SymbolsOutlineClose`\
     - Close symbols outline

Which-key
---------

\ `Which-key.nvim <https://github.com/folke/which-key.nvim>`_

这个插件用来看当前的快捷键的后续，比较类似emcas里面的很多。
配置如下，主要需要设置vim.o.timeoutlen = 500.

.. code-block:: bash

  { 
    'folke/which-key.nvim', 
    opts = {} ,
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  

gitsigns.nvim
-------------

\ `gitsigns.nvim <https://github.com/lewis6991/gitsigns.nvim>`_

这个插件带来的好处就是能看到改动。还是比较实用的。


null-ls
-------

这个插件可以带来很多格式化的帮助，基本上来说非常的重要。

关于配置方面，主要是以下的配置, 更多的信息查看 \ `BUILTINS.md <https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md>`_

.. code-block:: lua

   {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "mason.nvim" },
    opts = function()
      local null_ls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- see https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.shfmt,
          -- python
          null_ls.builtins.formatting.autopep8,
          null_ls.builtins.diagnostics.flake8,
          -- js
          null_ls.builtins.code_actions.eslint,
          -- rust
          null_ls.builtins.formatting.rustfmt
        },
      }
    end,
  },



.. attention::
  关于如何配置，选中的文本进行格式化，我本来以为需要配置 \ :code:`range_formatting`\, 但是根据 \ `这里的解释 <https://www.reddit.com/r/neovim/comments/zv91wz/comment/j1ot75x/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button>`_，可以直接用 \ :code:`vim.lsp.buf.format`\. 

Neovim Fonts
============

在配置了上述的一些插件后，由于字体的nerd原因，所以需要安装一些必要的字体，才能正确的现实图标。

\ `nerdfonts <https://www.nerdfonts.com/font-downloads>`_ 列出了目前可用的常见字体。

操作如下：


.. tab-set::

   .. tab-item:: MacOS-brew

     brew install font-fantasque-sans-mono-nerd-font

     # 如果想要其他的字体，直接尝试安装，如果失败了，brew会给出建议，这不用担心。


   .. tab-item:: Linux

     Linux

   .. tab-item::  Windows

      NA








Updates for null-ls
===================

之前就知道null-ls的作者弃坑了，所以null-ls处于无人维护的状态。

一直想要迁移，后来有了none-ls，等了一段时间，现在 2024-05-05 觉得还是试一下。

整体改动不大，不过有一些formater需要进行修改，而且好像没有看到rust的formater。








Why not coc.nvim
================

事实上，我原来也是用coc.nvim， 但是部分功能的缺失(see :doc:`snippets`，外加开发者对功能的补足不感兴趣)。






Reference
=========


.. [lazy.nvim] `lazy.nvim <https://github.com/folke/lazy.nvim>`_

.. [kickstart] `kickstart <https://github.com/nvim-lua/kickstart.nvim>`_



.. raw:: html

   <div class="section" />
