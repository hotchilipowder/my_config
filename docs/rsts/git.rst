=================
Awesome Git (Notes)
=================

这个文档是我自己的 Git 查漏补缺笔记：偏“日常高频 + 容易混淆的点”。
风格：先给**心智模型**，再给**最常用命令**，最后给**坑点/排错**。

.. contents::
   :local:
   :depth: 2


Best Practice for Git
=====================

.. code-block:: bash

   git config --global core.editor "nvim"
   git config --global user.name "hotchilipowder"
   git config --global user.email "h12345jack@gmail.com"

   # 我倾向保持线性历史（但要理解 rebase 的代价）
   git config --global pull.rebase true

   # 多账号/避免明文：优先 cache（再按需调 timeout）
   git config --global credential.helper cache

说明：
1. 设置默认编辑器
2. 设置默认用户名和邮箱（影响 commit 的 author/committer）
3. 设置 pull 的默认整合策略（rebase/merge/ff-only）
4. 设置凭证管理器（避免每次输入密码/Token）


Git 的三层心智模型（最重要）
============================

很多命令之所以难记，是因为你没把它们映射到 Git 的三层：

- HEAD：当前分支指向的提交（历史/指针）
- Index / Staging：暂存区（git add 后那份）
- Worktree：工作区（你编辑器里看到的文件）

我记忆方式：

- restore：**只动文件内容**（Index/Worktree），一般不动 HEAD
- reset：**动 HEAD 指针**（并可选择是否同步 Index/Worktree）
- checkout：老命令，既能切分支又能还原文件，语义太多（所以后来拆出 switch/restore）
- rm：把“删除文件”也变成一次变更（放进 Index 等你 commit）


四个命令的关系：restore / reset / checkout / rm
================================================

Git Restore
-----------

:code:`git restore` 是“恢复文件内容”的新命令，用来替代一部分 :code:`git checkout -- <file>` 的用法。

- 不带 :code:`--staged`：默认从 **Index** 恢复到 **Worktree**
- 带 :code:`--staged`：默认从 **HEAD** 恢复到 **Index**
- :code:`--source <commit>`：指定从某个 commit/branch/tag 当作“恢复源”

.. code-block:: bash

   # 1) 丢弃工作区改动（未 add）：Worktree <- Index
   git restore .
   git restore path/to/file

   # 2) 取消暂存（已经 add 了想撤回）：Index <- HEAD
   git restore --staged .
   git restore --staged path/to/file

   # 3) 同时撤销暂存 + 工作区（把文件回到 HEAD）：Index+Worktree <- HEAD
   git restore --staged --worktree path/to/file
   # 常见：只恢复某个 commit 的版本
   git restore --source <commit> --staged --worktree path/to/file

   # 4) 交互式恢复（hunk级别）
   git restore -p path/to/file

.. note::
   restore **不会移动 HEAD**，所以不会“撤销提交历史”，它只是在改你当前这份文件状态。


Git Reset
---------

reset 的核心是“把 HEAD 指针挪到某个 commit”，然后选择是否同步 Index/Worktree。

.. code-block:: bash

   # soft：只移动 HEAD（保留 Index/Worktree）
   git reset --soft HEAD~1

   # mixed（默认）：移动 HEAD + 重置 Index（保留 Worktree）
   git reset HEAD~1
   git reset --mixed HEAD~1

   # hard：移动 HEAD + 重置 Index + 重置 Worktree（最危险）
   git reset --hard HEAD~1

.. warning::
   reset --hard 是“仓库级大杀器”，优先用 restore 精准恢复单文件/单目录，除非你确定要彻底丢弃。


Git Checkout / Switch
---------------------

checkout 是老命令：
- :code:`git checkout <branch>` 切分支
- :code:`git checkout -- <file>` 还原文件

后来 Git 拆成两个更清晰的命令：
- :code:`git switch`：只切分支
- :code:`git restore`：只还原文件

.. code-block:: bash

   git switch main
   git switch -c feat/xxx
   git switch -


Git RM
------

rm 是“产生删除变更”，不是撤销工具。

.. code-block:: bash

   # 删除并暂存（commit 后历史里就删了）
   git rm path/to/file

   # 只从 git 索引里移除（保留本地文件）
   git rm --cached path/to/file


常见“等价/不等价”对照表（防止混淆）
==================================

.. list-table::
   :widths: 40 30 30
   :header-rows: 1

   * - 你看到的命令
     - 直觉想法
     - 更准确的解释
   * - :code:`git restore .`
     - “是不是等于 reset？”
     - 不等价。restore 主要是 **Worktree <- Index**（不动 HEAD）
   * - :code:`git restore --staged file`
     - “是不是等于 reset？”
     - 这更像“取消暂存”：**Index <- HEAD**（不动 HEAD）
   * - :code:`git restore --staged --worktree file`
     - “是不是等于 reset --hard？”
     - **对这个文件**效果很像“回到 HEAD”，但不移动 HEAD，不影响其它文件
   * - :code:`git reset --hard`
     - “彻底回滚”
     - 可能移动 HEAD（如果指定了目标），并同步 Index+Worktree，通常是全仓库级别


Pull / Rebase / Merge / Fast-forward（你最困惑的点）
===================================================

git pull 的本质
---------------

:code:`git pull` = :code:`git fetch` + “把远端整合进来”。

整合方式常见三种：fast-forward / merge / rebase。


Fast-forward（快进）是什么？
---------------------------

如果本地分支 **没有额外提交**，只是落后远端，那么 Git 只需要把分支指针往前挪一下。
这叫 fast-forward（不会产生 merge commit）。

我理解成：**历史是一条线，指针快进**。

.. code-block:: text

   A---B---C  (origin/main)
   A---B      (main)

   pull 后（fast-forward）：

   A---B---C  (origin/main, main)


Merge（合并）是什么？
---------------------

如果本地也有提交、远端也有提交，历史分叉了：

.. code-block:: text

       D---E  (main)
      /
   A--B--C    (origin/main)

merge 会创建一个新的 merge commit，把两条线汇合：

.. code-block:: text

       D---E
      /     \
   A--B--C---M   (main)

好处：保留真实分叉/汇合
坏处：log 会多一个 M（你会觉得不友好）


Rebase（变基）是什么？
---------------------

rebase 的核心是：把你本地那串提交 **挪到远端最新提交的后面重放**（commit id 会变）。

.. code-block:: text

       D---E  (main)
      /
   A--B--C    (origin/main)

rebase 后（线性）：

   A--B--C--D'--E'   (main)
   A--B--C           (origin/main)

好处：历史线性好读
坏处：D/E 变成 D'/E'（重写历史）


pull.rebase / pull.ff 我应该怎么选？
----------------------------------

我自己的倾向（个人分支日常开发）：

- 想要线性：:code:`git config --global pull.rebase true`
- 想要绝不产生 merge commit（不能快进就报错）：:code:`git config --global pull.ff only`

.. code-block:: bash

   # 默认 pull 走 rebase（线性）
   git config --global pull.rebase true

   # 或者：只允许 fast-forward（不能快进就失败，逼你手动处理分叉）
   git config --global pull.ff only

.. attention::
   如果一个分支已经被别人基于它开发/已经共享，慎用 rebase（会让别人需要处理“历史被重写”的问题）。


多账号快速工作流（我现在推荐的“可解释版本”）
==========================================

你目前的方案是对的：**clone 时指定 credential.username + 进入 repo 配 local 身份**。

核心目的：
- commit 的 author 不串（user.name/user.email）
- push/pull 的认证不串（credential.username + helper）

步骤
----

.. code-block:: bash

   # 1) clone 时临时禁用 helper + 指定用户名（避免被旧凭证污染）
   git clone -c credential.helper= -c credential.username=xxx https://github.com/xxx/demo.git

   # 2) 进入仓库后：把“身份”写死在本仓库 config
   cd demo
   git config --local user.name "xxx"
   git config --local user.email "xxx@example.com"
   git config --local credential.username "xxx"

   # 3) 关键：让这个仓库（或全局）记住 token，不要每次输入
   #    cache 默认 900 秒（15分钟），我一般调长
   git config --local credential.helper "cache --timeout=604800"   # 1周
   # 或全局（看你是否所有 repo 都能接受同一个策略）
   # git config --global credential.helper "cache --timeout=604800"

解释：我到底要设置到什么程度？
----------------------------

- :code:`user.name/user.email`：只影响 commit 记录（不解决免密码）
- :code:`credential.username`：告诉 Git 默认用哪个用户名（减少重复输入）
- :code:`credential.helper cache --timeout=...`：决定“多久内不再输入 token”

.. note::
   cache 是内存缓存：重启/daemon 退出就没了。安全性更好，但不是永久保存。


常见坑：MacOS 的 osxkeychain 多账号不好用怎么办？
------------------------------------------------

我自己的经验是：多账号时 keychain 容易“串号/撞记录”，体验不稳定。
我一般用两个替代路线：

- 路线A（少折腾）：HTTPS + cache（把 timeout 调长）
- 路线B（最稳）：SSH 多 key（每个账号一把 key + ssh config 区分 host）

.. tab-set::

   .. tab-item:: 路线A：cache（我当前最常用）

      .. code-block:: bash

         # 全局 cache + 8小时
         git config --global credential.helper "cache --timeout=28800"

         # 对某个 repo 单独设置 1周（更常用）
         git config --local credential.helper "cache --timeout=604800"

         # 想立刻清空缓存（排错时很有用）
         git credential-cache exit

   .. tab-item:: 路线B：SSH 多 key（稳定但需要一次配置）

      思路：
      - 账号1：Host github-personal -> 使用 key1
      - 账号2：Host github-work     -> 使用 key2
      然后每个 repo 的 remote 用不同 host，从根上隔离身份。


排错：到底哪个 credential.helper 在生效？
---------------------------------------

.. code-block:: bash

   git config --show-origin --get credential.helper

清理（按优先级逐级排查）：

.. code-block:: bash

   git config --local  --unset credential.helper
   git config --global --unset credential.helper
   git config --system --unset credential.helper


Common git skill
================

Git Restore（再强调一次：适合“精准撤文件”）
------------------------------------------

.. code-block:: bash

   # 丢弃工作区改动（未 add）
   git restore .

   # 取消暂存（staged -> unstaged）
   git restore --staged .

   # 单文件回到 HEAD（相当于“这个文件彻底不要了”）
   git restore --staged --worktree path/to/file

   # 从某个 commit 恢复文件
   git restore --source <commit> -- path/to/file


Change history user.name and user.email
--------------------------------------

这个需求常见：多设备没设置 user.name/email，导致 history 里出现奇怪作者。
（注意：改历史会影响 commit id，做之前先备份/确认）

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

.. note::
   最好的办法还是：一开始就把 user.name/user.email 配好，避免后面“洗历史”。


Delete all history
------------------

这个需求也常见：有些历史不想让人看到（太蠢了）。
（注意：这会让历史断掉，等于开新仓库）

.. code-block:: bash

   git checkout --orphan latest_branch
   git add .
   git commit -m "Update"
   git branch -D main
   git branch -m main
   git push -f origin main



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



References
==========

- `git教程`_
- `Lazygit`_

.. _git教程: https://git-scm.com/book/en/v2
.. _Lazygit: https://github.com/jesseduffield/lazygit
