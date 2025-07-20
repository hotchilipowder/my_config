===========
Awesome Git
===========

Best Pratice for Git
====================

.. code-block:: bash

   git config --global core.editor "nvim"
   git config --global user.name "hotchilipowder"
   git config --global user.email "h12345jack@gmail.com"
   git config --global pull.rebase true
   git config --global credential.helper cache


1. 设置默认的编辑器
2. 设置默认的用户名和邮箱
3. 设置拉取合并行为
4. 设置Git凭证管理器


.. attention::
   `credential.helper store`将会存放到本地的文本文件中，这是一个比较危险的事情。
   也就意味着需要你保证本机的安全。 `~/.git-credentials`


.. tab-set::

   .. tab-item:: MacOS

      On Mac, Git comes with an “osxkeychain” mode, which caches credentials in the secure keychain that’s attached to your system account.

     .. code-block:: bash
     
        git config --global credential.helper osxkeychain
     
   .. tab-item:: Linux

     Linux

   .. tab-item::  Windows

    Windows




账户设置
========

之前在Mac用多个账户，经常出现要么不能git clone私有项目（因为是另外一个账户），要么错误的用了账户到别的repo中，并且一直管理上比较麻烦。

有如下的方案：

+ 方案1: 不配置global
+ 方案2: 配置global， 默认使用hotchilipowder的账号。


方案1的版本中，需要按照如下的方式清除默认的 `credential.helper` 。
对于

.. code-block:: bash

   git config --global --unset credential.helper


对于方案2，在进行拉取非默认账号的项目的时候可能会报404，使用如下的命令:


.. code-block:: bash

   git clone -c credential.helper=  -c credential.username=xxx https://github.com/xxx/xx





My Github Issues
================

MacOS osxkeychain
-----------------

Mac 上清除 git osxkeychain 保存的登录名密码

.. code-block:: bash

   git config --local --unset credential.helper
   git config --global --unset credential.helper
   git config --system --unset credential.helper

但是还有进一步删除这个文件下的配置, more detail see \ `this link <https://stackoverflow.com/questions/16052602/how-to-disable-osxkeychain-as-credential-helper-in-git-config>`_

.. code-block:: bash

   git config --show-origin --get credential.helper

How to change default editor into vim
-------------------------------------

不太习惯使用 nano, 默认的nano比较难搞，改成 \ :code:`vim`\

.. code-block:: bash

   git config --global core.editor vim


Permission to x denied to github-actions[bot]
---------------------------------------------

遇到“Permission to "x" denied to github-actions[bot].”问题，按照下面的方法进行处理, see \ `this link <https://www.raulmelo.me/en/til/how-to-solve-permission-to-x-denied-to-github-actions-bot>`_


.. image:: https://www.raulmelo.me/_vercel/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fgc3hakk3%2Fproduction%2F8b5476684f1dfe262c1d8c0abe8b9fca7124311a-1220x1381.png%3Fw%3D1220%26h%3D1381%26auto%3Dformat&w=1280&q=100



Github Save username and password
---------------------------------


由于经常有开项目的习惯，存在多个账号，所以建议先设置local的 \ :code:`user.name`\ 和 \ :code:`user.email`\ ，并且进一步设置, 当前的项目的存储方式，这样可以少输入密码


.. code-block:: bash

   git config --local user.name "hotchilipowder"
   git config --local user.email "h12345jack@gmail.com"
   git config --local credential.helper cache

具体这些字段将会被写入到 \ :code:`project_xxx/.git/config`\中，

例如：

.. code-block:: bash

   [user]
   	name = hotchilipowder
   	email = h12345jack@gmail.com
   [credential]
   	helper = cache
   


Config
======

.. list-table:: Title
   :widths: 50 25 25
   :header-rows: 1

   * - Command
     - Meaning
     - Note
   * - \ :code:`git config --global core.editor "vim"`\
     - 修改编辑器为Vim
     - 
   * - \ :code:`git config --global credential.helper "cache --timeout=604800"`
     - 修改cache过期事件为1周=60 * 60 * 24 * 7 = 604800
     - 
   * - \ :code:`git config --local credential.username "hotchilipowder"`\
     - 设置默认的本地的crediential的username，避免每次都要重复输入。
     -
=======
Useful Config
=============

No Password
-----------





Install
=======


.. tab-set::

   .. tab-item:: Linux (Apt)

      .. code-block:: bash
      
         apt install git-all

   .. tab-item:: Linux (From source)
      
      see \ `this link <https://mirrors.edge.kernel.org/pub/software/scm/git/>`_  for recent release.

      .. code-block:: bash
      
         apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

         cd tmp
         curl -OL https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.5.tar.gz
         tar -xvf git-2.38.5.tar.gz
         ./configure --prefix=$HOME/.local
         make && make install

   .. tab-item:: MacOS
      
      .. code-block:: bash

         brew install git 


Proxy
=====

Just set following cmdline:

.. code-block:: bash

   git config --global http.proxy http://xxx
   git config --global https.proxy http://xxx


Common git skill
================

关于git学习的资料，可以查看 \ `git教程 <https://www.liaoxuefeng.com/wiki/896043488029600>`_\ 



Change history user.name and user.email
--------------------------------------

这个需求我主要是多设备没设置user.name 或者 user.email导致有一些奇怪的用户出现在git history里面了。

.. code-block:: bash

   #!/bin/sh
   git filter-branch --env-filter '
   OLD_EMAIL="you@example.com"
   CORRECT_NAME="hotchilipowder"
   CORRECT_EMAIL="h12345jack@gmail.com"
   if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
   then
       export GIT_COMMITTER_NAME="$CORRECT_NAME"
       export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
   fi
   if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
   then
       export GIT_AUTHOR_NAME="$CORRECT_NAME"
       export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
   fi
   ' --tag-name-filter cat -- --branches --tags

当然，为了避免这些，最好还是设置一下 user.name和user.email.

.. code-block:: bash

   git config --local user.name "hotchilipowder"
   git config --local user.email "h12345jack@gmail.com"



Delete all history
------------------


这个需求比较常见，因为有些commit history确实不想让人看到，很愚蠢

.. code-block:: bash

   git checkout --orphan latest_branch
   git add .
   git commit -m "Update"
   git branch -D main
   git branch -m main


Lazygit
=======

`Lazygit <https://github.com/jesseduffield/lazygit>`_ is a simple terminal UI for git commands.






Github Action
=============

首先，github action 已经成为了软件开发领域不可获取的部分。

关于 \ `Github Action <https://docs.github.com/zh/actions>`_ 文档学习,

首先，需要创建 \ :code:`.github/workflow/xxx.yml`\ 目录文件。

下面是我在用的一些 Github Action


My config
---------

\ `Github Link <https://github.com/hotchilipowder/my_config>`_

.. dropdown:: \ :code:`mkdocs.yml`\

   .. literalinclude:: ../../github_action/my_config/mkdocs.yml



本项目使用的github，其主要包括以下功能：

* 安装依赖+构建文档 

* Make snippsts to rst

* push html to github page

Self-hosted Action
------------------

最近，得知了Github Action可以Self-hosted了。基于这个特性，将会非常好的使用Github Action去替换Jenkin。

具体的步骤主要是按照要求进行安装即可。




