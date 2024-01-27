=======
Dockers
=======

Install
=======


.. tabs::

   .. tab:: Linux

     可以使用别的安装方式，但是最简单的还是
   
     .. code-block:: bash
     
        curl -fsSL https://get.docker.com -o install-docker.sh
        sh install-docker.sh

        curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
     

   .. tab:: MacOS
      
      我尝试过Docker-desktop, 只能说体验很差，经常斯基。
      改用了 \ `orbstack <https://orbstack.dev/>`_ , 世界一下就变美好了。

   .. tab::  Windows

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

按照文档说明，如果你想要 \ :code:`docker-compose up`\ 或者 \ :code:`docker build`\ 的时候使用proxy。

see \ `Docker daemon configuration <https://docs.docker.com/config/daemon/#configure-the-docker-daemon>`_

see \ `Configure Docker to use a proxy server <https://docs.docker.com/network/proxy/#configure-the-docker-client>`_



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


.. dropdown:: \ :code:`docker-compose.yml`\

   .. literalinclude:: ../../dockers/adguradhome/docker-compose.yml

配置文件, 这个可以帮助快速设置一些常见的过滤器, 放在 \ :code:`docker-compose.yml`\对应的文件夹下面的 \ :code:`conf`\ 目录下:


.. dropdown:: \ :code:`AdGuardHome.yaml`\

    .. literalinclude:: ../../dockers/adguradhome/AdGuardHome.yaml




Aria filebrowser
----------------
 
这个是设置的aria-pro和filebrowser


.. dropdown:: \ :code:`docker-compose.yml`\
  
  .. literalinclude:: ../../dockers/aria_filebrowser/docker-compose.yml

