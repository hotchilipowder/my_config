====================
Ghostty
====================

Ghostty 是一个原生、跨平台的终端模拟器。本仓库保存了日常使用的
Ghostty 配置，方便在新机器上快速恢复字体、字号和主题。

.. contents::
   :local:
   :depth: 2


从零安装
========

全新机器上按以下顺序执行即可完成安装与配置。

1. 安装 Ghostty。macOS 可以直接下载官方安装包，也可以通过 Homebrew 安装：

   .. code-block:: bash

      brew install --cask ghostty

   Linux 的软件包由各发行版或社区维护，安装方式请参考
   `Ghostty 官方安装文档 <https://ghostty.org/docs/install/binary>`_。

2. 安装配置中用到的字体 FantasqueSansM Nerd Font。macOS 直接用 Homebrew：

   .. code-block:: bash

      brew install --cask font-fantasque-sans-mono-nerd-font

   Linux 可从 `Nerd Fonts 下载页 <https://www.nerdfonts.com/font-downloads>`_
   下载后放入 ``~/.local/share/fonts``，再执行 ``fc-cache -fv``。

3. 克隆本仓库并执行安装脚本：

   .. code-block:: bash

      git clone https://github.com/hotchilipowder/my_config.git
      cd my_config
      ./ghostty/install.sh

``ghostty/install.sh`` 可以重复执行，它会：

- 在 macOS 上缺少 Ghostty 或字体时用 Homebrew 自动安装；
- 把已有的 ``~/.config/ghostty/config.ghostty`` 和旧的
  ``~/.config/ghostty/config`` 备份为带时间戳的 ``.bak`` 文件（内容与
  仓库一致时跳过备份）；
- 把仓库中的 ``ghostty/config.ghostty`` 复制到
  ``~/.config/ghostty/config.ghostty``；
- 删除 macOS 下 Application Support 目录中的空配置文件；
- 调用 ``ghostty +validate-config`` 校验配置语法。

不使用脚本时，也可以手动执行：

.. code-block:: bash

   mkdir -p ~/.config/ghostty
   for f in ~/.config/ghostty/config.ghostty ~/.config/ghostty/config; do
     [ -e "$f" ] && mv "$f" "$f.bak.$(date +%Y%m%d-%H%M%S)"
   done
   cp "$(pwd)/ghostty/config.ghostty" ~/.config/ghostty/config.ghostty


配置文件与优先级
================

Ghostty 1.2.3 起推荐使用 ``config.ghostty`` 作为配置文件名，旧的 ``config``
仍会读取；同一个目录下两者同时存在时，``config.ghostty`` 优先生效
（Ghostty 1.3.1 实测）。本仓库统一使用 ``config.ghostty``，避免手工维护
两份文件。

macOS 还会读取
``~/Library/Application Support/com.mitchellh.ghostty/`` 下的配置，并且
覆盖 XDG 配置中的同名选项。为了只维护一份配置，应避免在该目录保留非空
配置；``install.sh`` 会自动删除其中的空文件，非空时则给出提示。


当前配置
========

仓库中的 ``ghostty/config.ghostty`` 内容如下：

.. code-block:: text

   font-family = "FantasqueSansMNFM-Regular"
   font-size = 21

   theme = dark:Catppuccin Frappe,light:Catppuccin Latte
   term = xterm-256color

   keybind = cmd+left=previous_tab
   keybind = cmd+right=next_tab

这些选项分别用于：

- 使用 FantasqueSansM Nerd Font，并将字号设置为 21；
- 根据系统的深色或浅色外观自动切换 Catppuccin Frappe 与 Latte；
- 将 ``TERM`` 设置为兼容性较好的 ``xterm-256color``；
- 用 :kbd:`Cmd-Left` 和 :kbd:`Cmd-Right` 在标签页之间切换。

如果字体名称不匹配，可以用下面的命令查询 Ghostty 能识别的字体名称：

.. code-block:: bash

   # macOS
   /Applications/Ghostty.app/Contents/MacOS/ghostty +list-fonts

   # Linux
   ghostty +list-fonts


检查与重载
==========

修改或同步配置后，可以先进行语法检查：

.. code-block:: bash

   # macOS：在仓库根目录执行
   /Applications/Ghostty.app/Contents/MacOS/ghostty \
      +validate-config --config-file=ghostty/config.ghostty

   # Linux：在仓库根目录执行
   ghostty +validate-config --config-file=ghostty/config.ghostty

想确认当前实际生效的配置，可以执行：

.. code-block:: bash

   # macOS
   /Applications/Ghostty.app/Contents/MacOS/ghostty +show-config

   # Linux
   ghostty +show-config

在 macOS 中按 :kbd:`Command-Shift-,`，在 Linux 中按
:kbd:`Control-Shift-,`，即可重新加载配置。部分选项只会作用于新建的终端窗口，
必要时需要重启 Ghostty。

完整的配置路径、语法和选项说明见
`Ghostty 官方配置文档 <https://ghostty.org/docs/config>`_。
