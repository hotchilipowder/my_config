===========
Awesome Git
===========

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
