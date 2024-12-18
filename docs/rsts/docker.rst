=======
Dockers
=======

Install
=======

.. tab-set::

   .. tab-item:: Linux-Tsinghua

     可以使用别的安装方式，但是最简单的还是 \ `清华的安装链接 <https://mirrors.tuna.tsinghua.edu.cn/help/docker-ce/>`_
   
     .. code-block:: bash
     
        export DOWNLOAD_URL="https://mirrors.tuna.tsinghua.edu.cn/docker-ce"
        curl -fsSL https://get.docker.com/ | sh

        curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
     
   .. tab-item:: Linux

     可以使用别的安装方式，但是最简单的还是
   
     .. code-block:: bash
     
        curl -fsSL https://get.docker.com -o install-docker.sh
        sh install-docker.sh

        curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
     

   .. tab-item:: MacOS
      
      我尝试过Docker-desktop, 只能说体验很差，经常斯基。
      改用了 \ `orbstack <https://orbstack.dev/>`_ , 世界一下就变美好了。

   .. tab-item::  Windows

      Windows


Install docker-compose
----------------------

refer to \ `https://docs.docker.com/compose/install/standalone/ <https://docs.docker.com/compose/install/standalone/>`_


.. code-block:: bash

   curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose



Miscellaneous
=============

Proxy Settings
--------------

这个问题在 \ `SJTUG（上海交通大学 Linux 用户组）发布公告称已下架 Docker Hub 镜像 <https://t.me/lychee_wood/36286>`_ 后更加致命， 再看了  `如何为终端、docker 和容器设置代理 | Moralok <https://www.moralok.com/2023/06/13/how-to-configure-proxy-for-terminal-docker-and-container/>`_ 的博客描述后，感觉有了以下认识：

按照文档说明，如果你想要 \ :code:`docker-compose up`\ 或者 \ :code:`docker build`\ 的时候使用proxy。

see \ `Docker daemon configuration <https://docs.docker.com/config/daemon/#configure-the-docker-daemon>`_

see \ `Configure daemon with systemd <https://docs.docker.com/config/daemon/systemd/>`_

具体来说就是
编辑 \ :code:`/etc/docker/daemon.json`\

.. code-block:: bash

   {
     "default-address-pools": [
       {
         "base": "172.28.0.0/16",
         "size": 24
       }
     ],
     "proxies": {
       "http-proxy": "http://xxx",
       "https-proxy": "http://xxx",
       "no-proxy": "*.cn,*.edu.cn,127.0.0.0/8,172.0.0.0/8,10.0.0.0/8"
     }
   }





如果你想要docker跑在proxy下面，这里的意思是docker内部的网络是跑在proxy下面

see \ `Configure Docker to use a proxy server <https://docs.docker.com/network/proxy/#configure-the-docker-client>`_


编辑 \ :code:`~/.docker/config.json`\ 文件

.. code-block:: bash

   {
     "proxies": {
       "default": {
         "httpProxy": "http://xxx",
         "httpsProxy": "http://xxx",
         "noProxy": "*.cn,*.edu.cn,127.0.0.0/8,172.0.0.0/8,10.0.0.8/8"
       }
     }
   }





Docker-composes
===============

关于docker-compose，我个人是更支持的，因为不用每次都从头跑docker命令，很多时候还会忘记，写一个 \ :code:`run_docker.sh`\也没必要，还不如直接写 \ :code:`docker-compose up -d --build`\ 多么简单方便。


可以考虑从 \ `fatedier/frp <https://github.com/fatedier/frp/releases>`_ 这个页面查看当前的版本号和OS操作系统的名字。
例如, 

.. code-block:: bash

   ENV FRP_VERSION 0.49.0
   ENV OS linux_arm64


frp
---

frp主要包括客户端的 \ :code:`frpc`\ 和 服务端的 \ :code:`frps`\, 其主要是实现内网穿透的工具。这里是他的项目链接 \ `frp/github <https://github.com/fatedier/frp>`_

虽然有一些\ `frp的docker  <https://hub.docker.com/r/snowdreamtech/frps>`_, 但是有时候更新不是很及时。所以自己写了一个简单的，查看如下。

frpc
^^^^

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/frp/frpc/Dockerfile
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/frp/frpc/docker-compose.yml


.. dropdown:: \ :code:`Dockerfile`\

   .. literalinclude:: ../../dockers/frp/frpc/Dockerfile

.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/frp/frpc/docker-compose.yml


frps
^^^^

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/frp/frps/Dockerfile
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/frp/frps/docker-compose.yml


.. dropdown:: \ :code:`Dockerfile`\

   .. literalinclude:: ../../dockers/frp/frps/Dockerfile

.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/frp/frps/docker-compose.yml


server_status
-------------

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/server_status/Dockerfile
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/server_status/docker-compose.yml


.. dropdown:: \ :code:`Dockerfile`\

   .. literalinclude:: ../../dockers/server_status/Dockerfile


.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/server_status/docker-compose.yml



server_status_rust
------------------

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/server_status_rust/Dockerfile
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/server_status_rust/docker-compose.yml

.. dropdown:: \ :code:`Dockerfile`\

    .. literalinclude:: ../../dockers/server_status_rust/Dockerfile

.. dropdown:: \ :code:`docker-compose.yml`\

    .. literalinclude:: ../../dockers/server_status_rust/docker-compose.yml


rathole
-------

\ `Github <https://github.com/rapiz1/rathole/releases/latest>`_

rathole client
^^^^^^^^^^^^^^

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/rathole/client/Dockerfile
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/rathole/client/docker-compose.yml
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/rathole/client/client.toml

.. dropdown:: \ :code:`Dockerfile`\

    .. literalinclude:: ../../dockers/rathole/client/Dockerfile

.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/rathole/client/docker-compose.yml

.. dropdown:: \ :code:`client.toml`\

   .. literalinclude:: ../../dockers/rathole/client/client.toml

rathole server
^^^^^^^^^^^^^^

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/rathole/server/Dockerfile
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/rathole/server/docker-compose.yml
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/rathole/server/server.toml

.. dropdown:: \ :code:`Dockerfile`\

    .. literalinclude:: ../../dockers/rathole/server/Dockerfile

.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/rathole/server/docker-compose.yml

.. dropdown:: \ :code:`server.toml`\

   .. literalinclude:: ../../dockers/rathole/server/server.toml


Adhomeguard 
-----------

这个服务主要是用来改进dns服务。
可以去广告，并且通过多个dns的整合和缓存，加速。

一些有用的链接：

* \ `Cats-Team/AdRules <https://github.com/Cats-Team/AdRules>`_ 

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/adguradhome/docker-compose.yml
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/adguradhome/AdGuardHome.yaml

.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/adguradhome/docker-compose.yml

配置文件, 这个可以帮助快速设置一些常见的过滤器, 放在 \ :code:`docker-compose.yml`\对应的文件夹下面的 \ :code:`conf`\ 目录下:


.. dropdown:: \ :code:`AdGuardHome.yaml`\

    .. literalinclude:: ../../dockers/adguradhome/AdGuardHome.yaml


Aria filebrowser(TODO)
--------------------------------
 
这个是设置的aria-pro和filebrowser


.. dropdown:: \ :code:`docker-compose.yml`\
  
  .. literalinclude:: ../../dockers/aria_filebrowser/docker-compose.yml


traefik
-------

这个服务可以很好配合docker完成不同域名的转发工作，从而替代nginx。


.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/traefik/docker-compose.yml

.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/traefik/docker-compose.yml

为了配合 authentik 的使用，还需要添加如下 中间件 \ :code:`tls.yml`\ 和 \ :code:`route.yml`\


.. code-block:: bash

   mkdir -p traefik_conf
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/traefik/traefik_conf/tls.yml
   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/traefik/traefik_conf/route.yml

.. dropdown:: \ :code:`route.yml`\

   .. literalinclude:: ../../dockers/traefik/traefik_conf/tls.yml
   .. literalinclude:: ../../dockers/traefik/traefik_conf/route.yml


prom+grafana (TODO)
------------------------

可视化监控，

.. code-block:: bash

   curl -OL https://raw.githubusercontent.com/hotchilipowder/my_config/main/dockers/prom-grafana/docker-compose.yml

.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/prom-grafana/docker-compose.yml



Build My Docker Dev
=====================

由于经常要开启一些data science的项目，因此编写了一套自己的 cookie-cutter的模板。请参见: :logo-github:
