===============
Snippets System
===============

Sync from github
================

.. code-block:: bash

    cd ~/.config/nvim/

    curl https://codeload.github.com/hotchilipowder/my_config/tar.gz/main | tar -xz --strip=2 my_config-main/snippets/ 

Introduction
============

使用Snippets无意是在日常工作流中非常重要的一环。
常见的编辑起无论是 \ :literal:`vscode`\还是 \ :literal:`neovim`\ 都有很多的snippets系统。

而且在 [#how-to-make-math-note]_ 中对于 \ :literal:`Ultisnipets`\ 有大量的使用。
更多的参考资料也包括: [#Supercharged-Latex]_。







Ultisnipets
===========

Just use \ :code:`UltiSnipsEdit`\


.. attention::
    特别的，当我们写python的时候，可能需要用到一些Rst的snippets。我们可以用 \ :code:`UltiSnipsAddFiletypes python.rst`\。这个功能很重要，然而 \ `it cannot provide a command like :UltiSnipsAddFiletypes <https://github.com/neoclide/coc-snippets/issues/121>`_ in coc.nvim. 建议还是换官方吧...

.. include:: ./_ultisnippet.rst


Vsnip
=====
Just use \ :code:`VsniptOpenEdit`\

.. include:: _vs-snippet.rst


vim-snippets 简要记录
=====================

如果你用 [#vim-snippets]_ 就会发现有一些经典的使用。简单的罗列一下snippets (2023-04-22).



Rst
---

+ part,Part
+ chap,Chapter
+ sec,Section
+ ssec,Subsection
+ sssec,Subsubsubsection
+ para,Paragraph
+ em,Emphasize string
+ st,Strong string
+ li N<tab>,n List
+ oi N<tab>,n Order List
+ cb, Code block
+ id, Includable Directives
+ di, Directives, csv-table
+ dt, Directives without title, code
+ ds, Directives for subscription, \|python\|
+ sa, Specific Admonitions, hint
+ ro, Text Roles, code
+ eu, Embedded URI
+ fnt, Footnote or Citation
+ sid, sidebar

Python
------

see `python.snippets <https://github.com/honza/vim-snippets/blob/master/UltiSnips/python.snippets>`_ 。

+ class,"class with docstrings"
+ slotclass,"class with slots and docstrings"
+ dcl,"dataclass" 
+ contain,"methods for emulating a container type"
+ context,"context manager methods"
+ attr,"methods for customizing attribute access" 
+ desc,"methods implementing descriptors" 
+ cmp,"methods implementing rich comparison"
+ repr,"methods implementing string representation"
+ numeric,"methods for emulating a numeric type"
+ deff,"function or class method"
+ def,"function with docstrings" 
+ defc,"class method with docstrings"
+ defs,"static method with docstrings"
+ from,"from module import name"
+ roprop,"Read Only Property" 
+ rwprop,"Read write property"
+ if,"If"
+ ife,"If / Else"
+ ifee,"If / Elif / Else"
+ match,"Structural pattern matching"
+ matchw,"Pattern matching with wildcard" b
+ try,"Try / Except"  
+ trye,"Try / Except / Else" b
+ tryf,"Try / Except / Finally"
+ tryef,"Try / Except / Else / Finally"
+ ae,"Assert equal"
+ at,"Assert True" 
+ af,"Assert False" 
+ aae,"Assert almost equal" 
+ ar,"Assert raises"
+ an,"Assert is None"
+ ann,"Assert is not None"
+ testcase "pyunit testcase"
+ ","triple quoted string (double quotes)"
+ ',"triple quoted string (single quotes)"





References
==========


.. [#Supercharged-Latex]  `Supercharged LaTeX using Vim/Neovim, VimTeX, and snippets <https://www.ejmastnak.com/tutorials/vim-latex/intro/>`_

.. [#how-to-make-math-note]  `How I'm able to take notes in mathematics lectures using LaTeX and Vim | Gilles Castel <https://castel.dev/post/lecture-notes-1/>`_

.. [#vim-snippets] https://github.com/honza/vim-snippets
