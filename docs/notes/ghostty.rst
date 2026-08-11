====================
Ghostty
====================

Ghostty 是一个原生、跨平台的终端模拟器。本仓库保存了日常使用的
Ghostty 配置，方便在新机器上快速恢复字体、字号和主题。

.. contents::
   :local:
   :depth: 2


安装
====

macOS 可以直接下载官方安装包，也可以通过 Homebrew 安装：

.. code-block:: bash

   brew install --cask ghostty

Linux 的软件包由各发行版或社区维护，安装方式请参考
`Ghostty 官方安装文档 <https://ghostty.org/docs/install/binary>`_。


使用仓库中的配置
==================

Ghostty 会读取 XDG 配置目录。克隆本仓库后，在仓库根目录执行：

.. code-block:: bash

   mkdir -p ~/.config/ghostty
   mv ~/.config/ghostty/config \
      ~/.config/ghostty/config.bak.$(date +%Y%m%d-%H%M%S)
   cp "$(pwd)/ghostty/config" ~/.config/ghostty/config

如果本机还没有 ``~/.config/ghostty/config``，可以跳过 ``mv``。先 ``mv`` 备份再
``cp`` 覆盖，仓库中的修改可以直接同步到本机，原配置则保存在带时间戳的备份文件中。

Ghostty 1.2.3 及之后版本推荐使用 ``config.ghostty`` 作为文件名，旧的 ``config``
仍可兼容读取。本仓库仍以 ``config`` 为同步目标，保持文件名简单；如果本机之前使用
了其他文件名（例如 ``config.ghostty``），把备份后 ``cp`` 的目标名称改成对应文件
即可，例如：

.. code-block:: bash

   cp "$(pwd)/ghostty/config" ~/.config/ghostty/config.ghostty

macOS 还会读取
``~/Library/Application Support/com.mitchellh.ghostty/`` 下的配置，并在发生冲突时
覆盖 XDG 配置。为了只维护一份配置，应避免在该目录重复设置相同选项。


当前配置
========

仓库中的 ``ghostty/config`` 内容如下：

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

字体需要提前安装。如果字体名称不匹配，可以用下面的命令查询 Ghostty 能识别的
字体名称：

.. code-block:: bash

   # macOS
   /Applications/Ghostty.app/Contents/MacOS/ghostty +list-fonts

   # Linux
   ghostty +list-fonts


检查与重载
==========

修改配置后，可以先进行语法检查：

.. code-block:: bash

   # macOS：在仓库根目录执行
   /Applications/Ghostty.app/Contents/MacOS/ghostty \
      +validate-config --config-file=ghostty/config

   # Linux：在仓库根目录执行
   ghostty +validate-config --config-file=ghostty/config

在 macOS 中按 :kbd:`Command-Shift-,`，在 Linux 中按
:kbd:`Control-Shift-,`，即可重新加载配置。部分选项只会作用于新建的终端窗口，
必要时需要重启 Ghostty。

完整的配置路径、语法和选项说明见
`Ghostty 官方配置文档 <https://ghostty.org/docs/config>`_。
