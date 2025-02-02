
## Python Sphinx Extension

为了添加一些必要的交互性，添加了如下的一些插件

+ sphinx
+ sphinx-tabs
+ sphinxemoji
+ sphinx_design
+ sphinx-comments
+ sphinx-copybutton
+ sphinxcontrib-mermaid
+ jupyter-sphinx


## Include latest version

第一种基于latest的，例如neovim

```bash
curl -OL https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
```

第二种，通过api获取版本号然后得到的。

```bash
curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep "tag_name"
```

第三种，使用python脚本进行。这里可以简单调用以下 `jupyter-sphinx`进行

```python
.. jupyter-execute:: some_code.py
```
