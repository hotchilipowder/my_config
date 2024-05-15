============
Cookiecutter
============


Why Cookiecutter
================

使用这个工具最开始是因为觉得自己写的很多的项目其实有共同的脚手架。
使用了脚手架的项目相比build from scratch，确实更好用，因此尝试去看看别人的解决方案。

当然，在不同的语言下，区别还是比较大的(在JS下，也许你应该选择 \ :code:`next`\或者 \ :code:`vite`\而不是默认的 \ :code:`create-react-app`\或者 \ :code:`webpack`\。如果你用 [Django]_ , 其实本身使用 \ :code:`django-admin starprojects xxx`\就是一种脚手架。
但是由于库本身需要让新手和老手能区分开，所以很多的默认配置比较保守，或者不愿意修改。例如，我需要开启 \ :code:`ALLOWED_HOSTS = ['*']`\ 或者，我希望设置 \ :code:`TIME_ZONE = 'Asia/Shanghai'`\ 都需要再进行配置，非常的麻烦。

所以最后我选择的方案是使用 [Cookiecutter]_ 。


References
==========

.. [Cookiecutter] https://cookiecutter.readthedocs.io/

.. [Django] https://www.djangoproject.com/


.. raw:: html

   <div class="section" />
