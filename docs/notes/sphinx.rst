=====================
Sphinx 
=====================


Why sphinx
==========

之前一直纠结了很久的文档生成器。包括
核心的文档语言包括

+ markdown
+ rst
+ mdx
+ org
+ tex

很显然如果想要简单，选用markdown即可。但是markdown的功能收到限制，因此需要进一步扩展起能力，就得往下。
而mdx虽然很好，交互丰富，但是想来还是使用python更多，因此，最后还是选择了rst.
不过还有包括 [MyST]_ 这种有趣的md扩展。


Install 常用的sphinx扩展
================================
常用的设置

.. dropdown:: 我的吐槽

    最烦的就是默认功能不开启，需要额外安装，等你想用的时候，查文档才能知道是安装的时候某个功能没有启用。
    而且有些功能居然需要你重新编译，这种设置还不如不开启。。。
    这里需要注意的就是，你使用的myst-parser,需要开启的插件功能需要安装 linkify-it-py 。

    .. code-block:: bash
    
        myst_enable_extensions = [
            "amsmath",
            "attrs_inline",
            "colon_fence",
            "deflist",
            "dollarmath",
            "fieldlist",
            "html_admonition",
            "html_image",
            "linkify",
            "replacements",
            "smartquotes",
            "strikethrough",
            "substitution",
            "tasklist",
        ]
    
    




.. code-block:: bash

    uv pip install myst-parser[linkify] \
                sphinxcontrib-mermaid \
                sphinx_design \
                sphinx-copybutton \
                sphinxcontrib-bibtex\
                sphinx-comments \
                sphinxemoji



.. code-block:: python

    extensions=[
        "myst_parser",
        "sphinx_design",
        "sphinx_copybutton",
        "sphinxcontrib.bibtex",
        "sphinx_comments",
        "sphinxcontrib.mermaid",
        "sphinxemoji.sphinxemoji",
    ]

    html_css_files = [
     "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"
    ]

    bibtex_bibfiles = ['refs.bib']



MyST-Parser
-----------


为了支持直接写markdown, 可以引入这个包.


更多的信息查看这个文档. \ `myst-parser <https://myst-parser.readthedocs.io/en/latest/>`_


sphinxcontrib-mermaid
---------------------

由于在 `MyST-Parser`_ 介绍了关于这个 \ `mermaid <https://mermaid.js.org/>`_, 感觉非常好用。

更多的文档，请查看 \ `https://mermaid.js.org/intro/ <https://mermaid.js.org/intro/>`_


例如，生成一个简单的pie图

.. code-block:: markdown

    .. mermaid::
    
       pie title Pets adopted by volunteers
         "Dogs" : 386
         "Cats" : 85
         "Rats" : 15



.. mermaid::

   pie title Pets adopted by volunteers
     "Dogs" : 386
     "Cats" : 85
     "Rats" : 15


而且这个sphinx的扩展包也支持主题配置，有点6的，具体使用就是在原始的文档中的代码前面加上 \ :code:`.. mermaid::`\的directive就可以了

例如,代码如下：

.. code-block:: bash

    %%{
      init: {
        'theme': 'base',
        'themeVariables': {
          'primaryColor': '#BB2528',
          'primaryTextColor': '#fff',
          'primaryBorderColor': '#7C0000',
          'lineColor': '#F8B229',
          'secondaryColor': '#006100',
          'tertiaryColor': '#fff'
        }
      }
    }%%
            graph TD
              A[Christmas] -->|Get money| B(Go shopping)
              B --> C{Let me think}
              B --> G[/Another/]
              C ==>|One| D[Laptop]
              C -->|Two| E[iPhone]
              C -->|Three| F[fa:fa-car Car]
              subgraph section
                C
                D
                E
                F
                G
              end




.. mermaid::

    %%{
      init: {
        'theme': 'base',
        'themeVariables': {
          'primaryColor': '#BB2528',
          'primaryTextColor': '#fff',
          'primaryBorderColor': '#7C0000',
          'lineColor': '#F8B229',
          'secondaryColor': '#006100',
          'tertiaryColor': '#fff'
        }
      }
    }%%
            graph TD
              A[Christmas] -->|Get money| B(Go shopping)
              B --> C{Let me think}
              B --> G[/Another/]
              C ==>|One| D[Laptop]
              C -->|Two| E[iPhone]
              C -->|Three| F[fa:fa-car Car]
              subgraph section
                C
                D
                E
                F
                G
              end





sphinx_design
-------------

sphinx_design 包括grid，card, dropdown, tab, badegs。


Tabs using sphinx_design
^^^^^^^^^^^^^^^^^^^^^^^^
`Sphinx Design Tabs <https://sphinx-design.readthedocs.io/en/latest/tabs.html>`_

.. code-block:: bash

    .. tab-set::
    
        .. tab-item:: MacOS
            :sync: key1
    
            MacOS
    
        .. tab-item:: linux
            :sync: key2
    
            linux 
    
        .. tab-item:: windows
            :sync: key3
    
            windows 

.. tab-set::

    .. tab-item:: Macos
        :sync: key1

        macos

    .. tab-item:: linux
        :sync: key2

        linux 

    .. tab-item:: windows
        :sync: key3

        windows 


Tabs using sphinx_tabs (Abandon)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
`Sphinx Tab 文档 <https://sphinx-tabs.readthedocs.io/en/latest/#basic-tabs>`_

.. note::
    由于sphinx_desin可以实现tab，因此这个extension的可用性比较低，就可以不用了。

.. code-block:: bash

    .. tabs::
    
       .. tab:: MacOS
    
         MacOS 
    
       .. tab:: Linux
    
         Linux
    
       .. tab::  Windows
    
            Windows


Drop using sphinx_design
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
`Sphinx Design Drop <https://sphinx-design.readthedocs.io/en/latest/dropdowns.html>`_

.. code-block:: bash

    .. dropdown:: Dropdown title

        Dropdown content	


.. dropdown:: Dropdown title

    Dropdown content	


Card using sphinx_design
^^^^^^^^^^^^^^^^^^^^^^^^
`Sphinx Design Card <https://sphinx-design.readthedocs.io/en/latest/cards.html>`_

.. code-block:: bash

    .. card:: Card Title
    
        Header
        ^^^
        Card content
        +++
        Footer



.. card:: Card Title

    Header
    ^^^
    Card content
    +++
    Footer


Grid using sphinx design
^^^^^^^^^^^^^^^^^^^^^^^^
`Sphinx Design Grid <https://sphinx-design.readthedocs.io/en/latest/grids.html>`_

.. code-block:: bash

    .. grid:: 2
        :gutter: 2 2 2 2 

        .. grid-item-card::

            A

        .. grid-item-card::

            B


.. grid:: 2
    :gutter: 2 2 2 2 

    .. grid-item-card::

        A

    .. grid-item-card::

        B


Badges, Button, Icons using sphinx_design
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
`Sphinx Design BBI <https://sphinx-design.readthedocs.io/en/latest/badges_buttons.html>`_


Inline icon roles are available for the `GitHub octicon <https://primer.style/octicons/>`_, `Google Material Design Icons <https://fonts.google.com/icons>`_, or `FontAwesome <https://fontawesome.com/icons?d=gallery&m=free>`_ libraries.


+ octicon: :octicon:`logo-github;1em;sd-text-info` :code:`:octicon:\`logo-github;1em;sd-text-info\``
+ Google Material Design: :material-outlined:`g_translate` :code:`:material-outlined:\`g_translate\``
+ FontAwesome: :fab:`fa-brands fa-github-alt` :code:`:fab:\`fa-brands fa-github-alt\``




:bdg:`plain badge`

:bdg-primary:`primary`, :bdg-primary-line:`primary-line`

:bdg-secondary:`secondary`, :bdg-secondary-line:`secondary-line`

:bdg-success:`success`, :bdg-success-line:`success-line`

:bdg-info:`info`, :bdg-info-line:`info-line`

:bdg-warning:`warning`, :bdg-warning-line:`warning-line`

:bdg-danger:`danger`, :bdg-danger-line:`danger-line`

:bdg-light:`light`, :bdg-light-line:`light-line`

:bdg-dark:`dark`, :bdg-dark-line:`dark-line`

.. button-link:: https://hotchilipowder.github.io

.. button-link:: https://hotchilipowder.github.io

    Button text

.. button-link:: https://hotchilipowder.github.io
    :color: primary
    :shadow:

.. button-link:: https://hotchilipowder.github.io
    :color: primary
    :outline:

.. button-link:: https://hotchilipowder.github.io
    :color: secondary
    :expand:

sphinx_copybutton
-----------------
`Sphinx CopyButton <https://sphinx-copybutton.readthedocs.io/en/latest/>`_ 将会让代码可以被copy


sphinx_emoji
------------

`Sphinx Emoji <https://sphinxemojicodes.readthedocs.io/en/stable/>`_


.. Just use |:+1:|, :code:`|:+1:|`.

当然，我也如同 \ `vim-snippets <https://github.com/honza/vim-snippets/blob/master/UltiSnips/rst.snippets#L265>`_\ ，实现了一个类似的版本，可以查询当前的emoji.


sphinx comments
---------------

`sphinx-comments <https://github.com/executablebooks/sphinx-comments>`_

因为这个代码是挂载在 \ :code:`sections = document.querySelectorAll("div.section");`\. 因此在需要评论的下方，加一个

.. code-block:: bash

    .. raw::html

        <div class="section" />

就可以启用这个插件了。


Sphinx with Latex
=================

首先，由于文档很多时候是包括中文的，因此选用 \ :code:`xelatex`\ 而不是 \ :code:`pdflatex`\。然后倒入 \ :code:`ctex`\
.

最简单的设置如下:

.. code-block:: bash

    latex_engine = 'xelatex'
    latex_elements = {
      'preamble': r'''
    \addto\captionsenglish{\renewcommand{\chaptername}{}}
    \usepackage[UTF8, scheme = plain]{ctex}
    ''',
    }

然后使用 \ :code:`make latexpdf`\


修改为单个页面的pdf
-------------------

关于定制化单个页面，如何实现latex的有效编译，需要查看手册: \ `Latex customization <https://www.sphinx-doc.org/en/master/latex.html>`_

例如:

.. code-block:: python

    latex_engine = 'xelatex'
    latex_elements = {
        'passoptionstopackages': r'''
    \PassOptionsToPackage{svgnames}{xcolor}
    ''',
        'pointsize': '12pt',
        'fontpkg': r'''
    \setmainfont{Georgia}
    ''',
        'maketitle': r'''
        \date{Fall 2024}
        \maketitle
    ''',
        'tableofcontents': "",
        'preamble': r'''
    \usepackage{xeCJK}
    \usepackage{hyperref}
    \usepackage{url}
    \raggedbottom  % 避免章节之间产生多余的空白页
    
    \setlength{\parskip}{5pt}    % 段落之间空格
    ''',
        'sphinxsetup': r'''
        TitleColor=DarkGoldenrod
    ''',
        'printindex': r'\footnotesize\raggedright\printindex',
    }
    latex_show_urls = 'footnote'
    
    latex_documents = [
    ('project1/index', 'project1.tex', 'Title 1', 'Author 1', 'howto'),
    ]
    
    latex_additional_files = ["iclr2024_conference.sty"]


特别需要指出的，如果改成了 \ :code:`howto`\ 那么对应的是 article类。
如果是默认的会是 \ :code:`Manual`\。



多个配置文件对于不同的页面
--------------------------


例如，我们的某个教学项目，包括教程、练习题和代码手册等。
但是上述的单个页面的 \ :code:`conf.py`\ 比较难满足这种需求，因为tex的预加载可能存在差异。
这个时候最好的方式便是分不同的 \ :code:`conf.py`\ , 然后进行处理。

例如，我们可以创建一个 \ :code:`confs/projects/conf.py`\ 

然后使用 \ :code:`make latexpdf`\ 的时候指定配置文件 

.. code-block:: bash

    make latexpdf SPHINXOPTS="-c ./confs/projects" 




Interesting links for sphinx extensions
=======================================

Groups for sphinx
-----------------

[excutable-book]_ 

[sphinx-contrib]_ 

[sympy]_ : 这个是当时找 math + dollar 发现的 github, 



References
==========


.. [MyST] https://github.com/executablebooks/MyST-Parser

.. [sphinx-contrib] https://github.com/sphinx-contrib

.. [excutable-book] https://github.com/executablebooks

.. [sympy] https://github.com/sympy


.. raw:: html

   <div class="section" />
