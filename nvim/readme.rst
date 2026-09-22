=====================
Neovim：两套独立配置
=====================

定位
====

LLM 负责生成代码后，编辑器仍需要快速查找、阅读差异、跳转和小范围修改。
这里保留两份单文件配置，不再让“快速模式”经过完整插件管理器。

* ``nvim-lite``：``init-lite.lua``，Neovim 0.10+，零第三方插件，离线可用。
  内置语法高亮、文件浏览、撤销历史、注释、单词补全、分屏和剪贴板快捷键。
* ``nvim-daily``：``init.lua``，Neovim 0.12+，保留 Telescope、Git、文件树、
  bufferline、终端、Tree-sitter、VimTeX、个人 UltiSnips 和 nvim-cmp。
  沿用原来默认关闭 LSP 的习惯，需要时开启。

一键安装配置
============

先安装 Neovim；macOS 可用 ``brew install neovim``。
在本仓库根目录执行：

.. code-block:: bash

   bash nvim/install.sh         # 安装两套配置和启动命令
   # 或只安装快速版：bash nvim/install.sh light
   # 或只安装日常版：bash nvim/install.sh daily
   export PATH="$HOME/.local/bin:$PATH"  # 如果尚未加入 PATH

   nvim-lite notes.md
   nvim-daily project.py

安装器支持 macOS/Linux，复制配置到 ``${XDG_CONFIG_HOME:-~/.config}/nvim-lite``
和 ``nvim-daily``。启动命令通过 ``NVIM_APPNAME`` 隔离数据、插件、缓存和历史。
原有 ``~/.config/nvim`` 不会被覆盖，普通 ``nvim`` 继续使用原配置。
重复安装会将同名配置、启动命令移动到随机命名的 ``*.backup.*`` 目录，
可从其中的 ``config`` / ``launcher`` 恢复。新安装不会自动合并本地修改。

可选参数：``--config-home DIR --bin-dir DIR``，便于自定义或临时试用。
安装器不安装系统软件，也不修改 shell 配置；快速版安装后即可使用，
日常版首次启动需要 Git 和联网下载插件。

不安装也能试用快速版：

.. code-block:: bash

   bash nvim/nvim-server.sh notes.md

原来的 ``NVIM_PROFILE=server`` 开关已由独立入口代替。
若希望普通 ``nvim`` 也默认使用快速版，可自行给 shell 添加
``alias nvim='NVIM_APPNAME=nvim-lite command nvim'``。

日常版按需准备
==============

* 全文搜索需要 ``ripgrep``，macOS：``brew install ripgrep``。
* Tree-sitter 解析器安装需要 C 编译器、tar、curl 和 ``tree-sitter-cli >= 0.26.1``。
  macOS：``brew install tree-sitter-cli``，如缺编译器则安装 Xcode Command Line Tools。
  进入编辑器执行 ``:TSInstallDefaults``；之后按需 ``:TSInstall <language>``。
  平时启动不会下载解析器，未安装的语言使用普通语法高亮。
  升级插件时用 ``:TSUpdate`` 同步解析器；安装完成后重新打开文件启用高亮。
* 默认保留个人 UltiSnips，需要 Python 的 ``pynvim`` provider。
  例如已有 uv 时执行 ``uv tool install pynvim``，再用
  ``:checkhealth vim.provider`` 检查。无需片段时：
  ``NVIM_ENABLE_ULTISNIPS=0 nvim-daily``，LSP 片段改用内置 ``vim.snippet``。
  仓库里的 JSON/vsnip 片段仍保留，但日常版只启用 UltiSnips 这一套个人片段来源。
* VimTeX 只在打开 TeX 文件时加载；编译仍需本机 TeX/latexmk 环境。

.. code-block:: bash

   NVIM_ENABLE_LSP=1 nvim-daily

首次按需要运行 ``:LspInstall pyright``、``:LspInstall ts_ls`` 等。
已配置 Python、Rust、TypeScript/JavaScript、LaTeX 和 Typst 的语言服务。
Mason 不再每次启动自动安装全部服务；系统 PATH 中已有的服务也可使用。
Node.js 只在所选服务（例如 pyright、ts_ls）需要时安装，无需为快速版安装。
安装后重新打开文件；用 ``:checkhealth vim.lsp`` 检查连接。

格式化独立于 LSP，通过 ``<Space>cf`` 手动执行，不在保存时改写文件。
用 ``:Mason`` 安装所需格式化器，或使用 PATH 中现有工具；
Python 优先 Ruff，否则 isort + Black，Lua 用 StyLua，Shell 用 shfmt，
前端使用 prettierd/prettier。``:ConformInfo`` 可查看工具是否可用。
移除了面向所有文件的 codespell/Prettier 兜底，防止无关文件被错误处理。

快捷键
======

两套配置的 leader 都是空格。

* ``<Space>ff``：快速版输入文件路径并用 Tab 补全；日常版模糊搜索。
* ``<Space>pt``：文件浏览（快速版 netrw，日常版 nvim-tree）。
* ``Tab`` / ``Shift-Tab``：切换 buffer；``<Space>q``：关闭 buffer。
* ``<Space>ws`` / ``<Space>wv``：水平/垂直分屏。
* ``<Space>y`` / ``<Space>p``：系统剪贴板复制/粘贴；普通 y/p 使用内部寄存器。
  SSH 下复制可使用 Neovim 原生 OSC 52，需终端支持；远端读取剪贴板取决于终端能力。
* ``gc`` / ``gcc``：原生注释；快速版 ``Ctrl-n`` / ``Ctrl-p``：内置单词补全。
* ``<Space>fed``：编辑当前配置。
* 日常版：``<Space>fg`` 全文搜索，``:Git`` Git 操作，``<Space>cf`` 格式化。
* LSP 开启并连接后：``gd`` 定义、``gr`` 引用、``<Space>cs`` / ``<Space>ds`` 文档符号、
  ``<Space>ss`` 工作区符号、``gK`` 签名帮助、``<Space>cq`` 诊断列表。
  修复了原来诊断列表与关闭 buffer、工作区符号与分屏、签名帮助与窗口导航的按键冲突。

清理与迁移依据
==============

不是所有插件都需要换成新项目；优先处理不兼容接口、停止维护和重复功能。

* `Tree-sitter main <https://github.com/nvim-treesitter/nvim-treesitter>`_
  是不兼容重写；沿用 main，使用新安装 API 和 ``vim.treesitter.start()``。
  高亮与折叠由 Neovim 提供，实验性缩进仍来自插件；Python 保留原有缩进。
* `nvim-lspconfig <https://github.com/neovim/nvim-lspconfig>`_
  本身没有废弃，旧 ``require('lspconfig').xxx.setup`` 接口已废弃；改用
  ``vim.lsp.config`` / ``vim.lsp.enable``，匹配 Mason 2 的接口。
* `neodev <https://github.com/folke/neodev.nvim>`_ 已停止开发。
  原配置没有 lua_ls，先移除；以后确实需要 Lua 开发辅助时再加 lazydev。
* `symbols-outline <https://github.com/simrat39/symbols-outline.nvim>`_ 已归档，
  使用现有 Telescope 的文档符号搜索，不再新增另一套符号插件。
* 删除 Comment.nvim、vim-oscyank：使用内置注释和剪贴板 provider。
* 删除 none-ls：当前配置里主要与 Conform 重复，统一格式化入口。
  原 none-ls 的 djlint 诊断也不再提供；需要时单独配置。
* 删除欢迎页 alpha、rhubarb、fidget、原生 fzf 编译扩展、未配置的 cmp-cmdline、
  重复的 vsnip/cmp-vsnip。保留 nvim-cmp，不为追新强制迁移补全引擎。
* 保留 UltiSnips 和个人 vim-snippets 依赖：已有片段包含 Python 动态逻辑及 helper 导入，
  不能简单换成静态片段而保持行为一致。

维护
====

日常版插件按事件/命令加载，Tree-sitter 按上游要求启动时加载。
``:Lazy`` 检查插件，``:Lazy update`` 主动更新，``:Lazy restore`` 按 lockfile 恢复。
安装目录里的 ``lazy-lock.json`` 记录具体版本，验证更新后可保存回本仓库。
两套配置均保持单文件，避免为了配置编辑器再维护复杂框架。

网络受限时，按本地代理实际端口设置 ``https_proxy`` / ``http_proxy`` 后再安装插件。


本地验证：``python3 nvim/tests/smoke.py`` 检查快速版和安装器；
已有插件时使用 ``python3 nvim/tests/smoke.py --plugins ~/.local/share/nvim/lazy``
同时检查日常版。测试在临时 XDG 目录运行，不修改现有配置。

将已安装配置同步回仓库：``bash nvim/update_init_lua_from_current_os.sh daily``
或 ``light``。
