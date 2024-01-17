======================
HomeLab Configurations
======================

Introduction
============

[HomeLab]_ 是一个比较好的环境，可以跑一些docker和linux，服务于自己。我主要是采用pve进行虚拟化。
其中软件上有不少的坑，都记录在这里，方便查阅。

Configurations For u200
========================


Install Basic Developments
--------------------------

docker-compose
^^^^^^^^^^^^^^

Just see \ `https://docs.docker.com/compose/install/standalone/ <https://docs.docker.com/compose/install/standalone/>`_ and use

.. code-block:: bash

    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose

and just use following links for \ :code:`/usr/bin/docker-compose`\

.. code-block:: bash

    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose



htop
^^^^

Download from \ `https://github.com/htop-dev/htop/releases/download/3.2.2/htop-3.2.2.tar.xz <https://github.com/htop-dev/htop/releases/download/3.2.2/htop-3.2.2.tar.xz>`_
Then, \ :code:`./configure;make;make install`\




Python3.12
^^^^^^^^^^
Dependecy:

.. code-block:: bash

    apt-get install build-essential gdb lcov pkg-config \
      libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev \
      libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev \
      lzma lzma-dev tk-dev uuid-dev zlib1g-dev




.. code-block:: bash

    curl -OL https://www.python.org/ftp/python/3.12.0/Python-3.12.0.tar.xz
    tar -xvf Python-3.12.0
    
    ./configure --enable-optimizations --with-lto
    make 
    make install



References: 

+ \ `https://devguide.python.org/getting-started/setup-building/#linux <https://devguide.python.org/getting-started/setup-building/#linux>`_  
+ \ `https://www.python.org/downloads/release/python-3120/ <https://www.python.org/downloads/release/python-3120/>`_





Docker
======


Install Docker
---------------


.. tabs::

   .. tab:: MacOS

     .. code-block:: bash

         brew install --cask docker


   .. tab:: Linux (Using getdocker)


    .. code-block:: bash
    
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
    
   .. tab:: Linux (Using apt)

    See  `Linux Install <https://docs.docker.com/engine/install/>`_

    .. code-block:: bash
    
        sudo apt-get remove docker docker-engine docker.io containerd runc
        sudo apt-get update
        sudo apt-get install \
            ca-certificates \
            curl \
            gnupg
        sudo install -m 0755 -d /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        sudo chmod a+r /etc/apt/keyrings/docker.gpg
        echo \
          "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
          "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


Frp dockers
-----------










PVE
===


PVE IPv6 Issues
---------------

这个问题主要是PVE的使用下，IPv6一直无法正常使用。
首先，我的网路的入口是一个路由器，这个路由器会分发一个ipv6的地址。
但是在使用了PVE后，无法再分配对应的IPv6到各个虚拟机。
事实上，我当时无法获取ipv6地址的问题是PVE7.0之后的一个问题。
See `Proxmox网桥通过SLAAC配置公网ipv6地址 - 海运的博客 <https://www.haiyun.me/archives/1416.html>`_

Proxmox安装后默认没有通过SLAAC配置公网ipv6地址，使用debian/ubuntu的方法配置ipv6提示错误不支持的方法auto。

.. code-block:: bash

    iface vmbr0 inet6 auto

原来Proxmox使用的是ifupdown2，非debian/ubuntu使用ifupdown。
查看内核也已经开启ipv6自动配置：

.. code-block:: bash

     cat /proc/sys/net/ipv6/conf/vmbr0/accept_ra
     1
     cat /proc/sys/net/ipv6/conf/vmbr0/autoconf
     1
     cat /proc/sys/net/ipv6/conf/vmbr0/forwarding
     1

需要将accept_ra值改成2才能自动配置SLAAC ipv6地址：
在\ :code:`/etc/sysctl.conf`\文件末添加
   
.. code-block:: bash

   net.ipv6.conf.all.accept_ra=2
   net.ipv6.conf.default.accept_ra=2
   net.ipv6.conf.vmbr0.accept_ra=2
   net.ipv6.conf.all.autoconf=1
   net.ipv6.conf.default.autoconf=1
   net.ipv6.conf.vmbr0.autoconf=1


然后ipv6的地址就有了。

这个时候\ :code:`/etc/network/interface`\的配置为:

.. code-block:: bash

    source /etc/network/interfaces.d/*
    auto lo
    iface lo inet loopback

    iface enp1s0 inet manual

    auto vmbr0
    iface vmbr0 inet static
       address 192.168.123.86/24
       gateway 192.168.123.1
       bridge-ports enp1s0
       bridge-stp off
       bridge-fd 0
    iface vmbr0 inet6 auto

Research Server
===============



网络接入
--------


通常而言，内部服务器都是不连入互联网的，为了保证其内网的安全。
因此我们通常通过代理的方式连出，假设我们的代理为 \ :code:`http://192.168.1.1`\

我们可以在 \ :code:`~/.bashrc`\ 文件中添加如下配置，联入互联网


.. code-block:: bash
  :linenos:

    export all_proxy=http://192.168.1.1:1081
    export http_proxy=http://192.168.1.1:1081
    export https_proxy=http://192.168.1.1:1081
    export PATH=$HOME/.local/bin:$PATH
    export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
    export MANPATH=$HOME/.local/share/man:$MANPATH

Pytorch安装
-----------

由于pytorch使用较多，下面的示例安装pytorch


.. code-block:: bash

    channels:
      - defaults
    show_channel_urls: true
    default_channels:
      - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
      - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
      - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/msys2
    custom_channels:
      conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
      simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
    proxy_servers:
      http: http://192.168.1.1:1081
      https: http://192.168.1.1:1081




Nodejs Install
--------------


.. tabs::

   .. tab:: download/release

     see \ `https://nodejs.org/download/release/ <https://nodejs.org/download/release/>`_

     .. code-block:: bash
        :linenos:

        curl -OL https://nodejs.org/download/release/latest-v16.x/node-v16.14.0-linux-x64.tar.gz
        tar -xvf node-*
        mv node-*/ ~/.local
        rm node-*
        pip3 install neovim


   .. tab:: 编译

     just download from \ `https://nodejs.org/en/download <https://nodejs.org/en/download>`_

     .. code-block:: bash
       :linenos:
       
        ./configure --prefix=~/.local
        make && make install
     








  



References
==========

.. [HomeLab] a laboratory of (usually slightly outdated) awesome in the domicile. See https://icyleaf.com/2022/02/how-to-homelab-part-0


