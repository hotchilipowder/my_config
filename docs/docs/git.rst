===========
Awesome Git
===========


Install
=======


.. tabs::

   .. tab:: MacOS

     MacOS 

   .. tab:: Linux (Apt)

      .. code-block:: bash
      
         apt install git-all

   .. tab:: Linux (From source)
      
      see \ `this link <https://mirrors.edge.kernel.org/pub/software/scm/git/>`_  for recent release.

      .. code-block:: bash
      
         apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev

         cd tmp
         curl -OL https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.38.5.tar.gz
         tar -xvf git-2.38.5.tar.gz
         ./configure --prefix=$HOME/.local
         make && make install
      


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
