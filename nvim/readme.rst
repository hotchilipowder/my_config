======================
Something about neovim
======================


Proxy settings
==============

If you have some issues on network, please use proxy as follows:

.. code-block:: bash

    export http_proxy=http://127.0.0.1:1081
    export https_proxy=http://127.0.0.1:1081
    export all_proxy=http://127.0.0.1:1081


Profiles
========

This config now has two startup switches:

.. code-block:: bash

    # default: full profile, LSP disabled
    nvim

    # enable LSP (mason/lspconfig/conform/none-ls)
    NVIM_ENABLE_LSP=1 nvim

    # fast profile for server usage
    NVIM_PROFILE=server nvim

    # or use helper script in this repo
    ./nvim-server.sh

In Neovim, you can also run:

.. code-block:: vim

    :LspEnableHint
    :NvimServerProfileHint
