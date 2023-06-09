======================
HomeLab Configurations
======================

Introduction
============

[HomeLab]_ 是一个比较好的环境，可以跑一些docker和linux，服务于自己。我主要是采用pve进行虚拟化。
其中软件上有不少的坑，都记录在这里，方便查阅。

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



References
==========

.. [HomeLab] a laboratory of (usually slightly outdated) awesome in the domicile. See https://icyleaf.com/2022/02/how-to-homelab-part-0


