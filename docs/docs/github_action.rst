=============
Github Issues 
=============

Introduction
============

首先，github action 已经成为了软件开发领域不可获取的部分。

关于 \ `Github Action <https://docs.github.com/zh/actions>`_ 文档学习,

首先，需要创建 \ :code:`.github/workflow/xxx.yml`\ 目录文件。


Actions I used
==============


My config
---------

.. dropdown:: \ :code:`mkdocs.yml`\

   .. literalinclude:: ../../github_action/my_config/mkdocs.yml



本项目使用的github，其主要包括以下功能：

* 安装依赖+构建文档 

* Make snippsts to rst

* push html to github page



Permission to x denied to github-actions[bot]
=============================================

遇到“Permission to "x" denied to github-actions[bot].”问题，按照下面的方法进行处理, see \ `this link <https://www.raulmelo.me/en/til/how-to-solve-permission-to-x-denied-to-github-actions-bot>`_


.. image:: https://www.raulmelo.me/_vercel/image?url=https%3A%2F%2Fcdn.sanity.io%2Fimages%2Fgc3hakk3%2Fproduction%2F8b5476684f1dfe262c1d8c0abe8b9fca7124311a-1220x1381.png%3Fw%3D1220%26h%3D1381%26auto%3Dformat&w=1280&q=100



My Github Issues
================

由于经常有开项目的习惯，存在多个账号，所以建议先设置local的 \ :code:`user.username`\ 和 \ :code:`user.email`\ ，并且进一步设置, 当前的项目的存储方式，这样可以少输入密码


.. code-block:: bash

   git config --local user.username "hotchilipowder"
   git config --local user.email "h12345jack@gmail.com"
   git config --local credential.helper cache

具体这些字段将会被写入到 \ :code:`project_xxx/.git/config`\中，

例如：

.. code-block:: bash

   [user]
   	username = hotchilipowder
   	email = h12345jack@gmail.com
   [credential]
   	helper = cache
   






