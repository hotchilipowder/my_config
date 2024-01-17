python
------

.. dropdown:: [pytornado_begin]  pytornado_begin"

   .. code-block:: json

        {
          "prefix": "pytornado_begin",
          "body": [
            "#!/usr/bin/env python",
            "",
            "import os",
            "import sys",
            "import logging",
            "",
            "import tornado.httpserver",
            "import tornado.ioloop",
            "import tornado.wsgi",
            "import tornado.web",
            "",
            "logger = logging.getLogger('tornado_proxy')",
            " # https://github.com/senko/tornado-proxy/blob/master/tornado_proxy/proxy.py",
            "class MainHandler(tornado.web.RequestHandler):",
            "    async def get(self):",
            "        self.write(\"Hello world!\")",
            "        self.finish()",
            "",
            "",
            "",
            "if __name__ == \"__main__\":",
            "    # path to your settings module",
            "    os.environ['DJANGO_SETTINGS_MODULE'] = 'xxx.settings'",
            "    os.environ[\"DJANGO_ALLOW_ASYNC_UNSAFE\"] = \"true\"",
            "    # from xxx.wsgi import application",
            "    # container = tornado.wsgi.WSGIContainer(application)",
            "",
            "    tornado_app = tornado.web.Application(",
            "        [",
            "            # python manage.py collectstatic to get django statics",
            "            (r'/static/(.*)', tornado.web.StaticFileHandler, {\"path\": './staticfiles'}),",
            "            (r'/uploads/(.*)', tornado.web.StaticFileHandler, {\"path\": './uploads'}),",
            "            # (r'/admin.*', tornado.web.FallbackHandler, dict(fallback=container)),",
            "            (r'.*', MainHandler),",
            "        ],",
            "        debug=True,",
            "        autoreload=True",
            "    )",
            "    http_server = tornado.httpserver.HTTPServer(tornado_app)",
            "    http_server.bind(21318, address='0')",
            "    http_server.start(0)  # forks one process per cpu",
            "    tornado.ioloop.IOLoop.current().start()",
            ""
          ]
        }

    

.. dropdown:: [pydjango_setup]  pydjango_setup"

   .. code-block:: json

        {
          "prefix": "pydjango_setup",
          "body": [
            "import os",
            "import sys",
            "BASE_DIR =os.path.abspath(__file__)",
            "django_project_path = os.path.abspath(os.path.join(BASE_DIR, 'xxx'))",
            "print(django_project_path)",
            "sys.path.append(django_project_path)",
            "print(sys.path)",
            "os.environ['DJANGO_SETTINGS_MODULE'] = 'xxx.settings'",
            "os.environ['DJANGO_ALLOW_ASYNC_UNSAFE'] = 'True'",
            "import django",
            "django.setup()",
            ""
          ]
        }

    

.. dropdown:: [jupyterbegin]  jupyterbegin"

   .. code-block:: json

        {
          "prefix": "jupyterbegin",
          "body": [
            "import os",
            "import re",
            "import sys",
            "import time",
            "import json",
            "import math",
            "import random",
            "import pickle",
            "import logging",
            "import subprocess",
            "",
            "from collections import defaultdict",
            "",
            "import scipy as sc",
            "import pandas as pd",
            "import seaborn as sns",
            "import numpy as np",
            "import matplotlib",
            "",
            "import networkx as nx",
            "from tqdm import tqdm_notebook",
            "",
            "### this config add some fonts to the ttflist dir",
            "import matplotlib.font_manager as font_manager",
            "font_dirs = ['/home/huangjunjie/fonts']",
            "font_files = font_manager.findSystemFonts(fontpaths=font_dirs)",
            "font_list = font_manager.createFontList(font_files)",
            "# print(font_list) # list what fonts you have",
            "font_manager.fontManager.ttflist.extend(font_list)",
            "",
            "## this set to matplotlib",
            "matplotlib.rcParams['font.family'] = \"sans-serif\"",
            "matplotlib.rcParams['font.sans-serif'] = [\"CMU Sans Serif\"]",
            "import matplotlib.pyplot as plt",
            "plt.style.context('journal')",
            "",
            "%matplotlib inline",
            "sns.set_context(\"paper\", font_scale=1.5, rc={'text.usetex' : True})",
            "sns.set_style(\"white\")",
            "sns.set_style({'font.family': 'sans-serif'})",
            "sns.set_style({'font.sans-serif': [\"Helvetica\"]})"
          ]
        }

    

.. dropdown:: [pydjango_simple]  pydjango_simple"

   .. code-block:: json

        {
          "prefix": "pydjango_simple",
          "body": [
            "import os",
            "import sys",
            "",
            "from django.conf import settings",
            "",
            "DEBUG = os.environ.get('DEBUG', 'on') == 'on'",
            "SECRET_KEY = os.environ.get('SECRET_KEY', os.urandom(32))",
            "ALLOWED_HOSTS = os.environ.get('ALLOWED_HOSTS', 'localhost').split(',')",
            "",
            "",
            "",
            "settings.configure(",
            "    DEBUG=DEBUG,",
            "    SECRET_KEY=SECRET_KEY,",
            "    ALLOWED_HOSTS=ALLOWED_HOSTS,",
            "    ROOT_URLCONF=__name__,",
            "    MIDDLEWARE_CLASSES=(",
            "        'django.middleware.common.CommonMiddleware',",
            "        'django.middleware.csrf.CsrfViewMiddleware',",
            "        'django.middleware.clickjacking.XFrameOptionsMiddleware',",
            "    )",
            ")",
            "",
            "",
            "from django.conf.urls import re_path",
            "from django.http import HttpResponse",
            "from django.core.wsgi import get_wsgi_application",
            "",
            "def index(request):",
            "    return HttpResponse('Hello World')",
            "",
            "",
            "urlpatterns = (",
            "    re_path(r'^', index),",
            ")",
            "",
            "application = get_wsgi_application()",
            "",
            "",
            "if __name__ == \"__main__\":",
            "    from django.core.management import execute_from_command_line",
            "",
            "    execute_from_command_line(sys.argv)",
            "",
            "## run it by python xxx.py runserver",
            "",
            "",
            "## writing views, creating settings, and running management commands"
          ]
        }

    

.. dropdown:: [pyloggerbegin]  pyloggerbegin"

   .. code-block:: json

        {
          "prefix": "pyloggerbegin",
          "body": [
            "import logging",
            "# https://docs.python.org/3/howto/logging.html#logging-advanced-tutorial",
            "",
            "logger = logging.getLogger(__file__)",
            "logger.setLevel(logging.DEBUG)",
            "",
            "ch = logging.StreamHandler()",
            "ch.setLevel(logging.DEBUG)",
            "",
            "fh = logging.FileHandler(f'{__file__}.log')",
            "fh.setLevel(logging.INFO)",
            "",
            "# create formatter",
            "formatter = logging.Formatter('%(asctime)s %(levelname)s [%(filename)s:%(lineno)d] %(message)s')",
            "",
            "# add formatter to ch",
            "ch.setFormatter(formatter)",
            "fh.setFormatter(formatter)",
            "",
            "# add handler to logger",
            "logger.addHandler(ch)",
            "logger.addHandler(fh)",
            "",
            "# 'application' code",
            "logger.debug('debug message')",
            "logger.info('info message')",
            "logger.warning('warn message')",
            "logger.error('error message')",
            "logger.critical('critical message')"
          ]
        }

    

.. dropdown:: [pyaiohttp]  pyaiohttp"

   .. code-block:: json

        {
          "prefix": "pyaiohttp",
          "body": [
            "from aiohttp import web",
            "",
            "async def handler(request):",
            "    return web.Response(text=\"Hello, world!\")",
            "",
            "app = web.Application()",
            "app.add_routes([web.get('/', handler)])",
            "",
            "if __name__ == '__main__':",
            "    web.run_app(app)"
          ]
        }

    

.. dropdown:: [pytorchtemplate]  pytorchtemplate"

   .. code-block:: json

        {
          "prefix": "pytorchtemplate",
          "body": [
            "import os",
            "import re",
            "import sys",
            "import time",
            "import json",
            "import math",
            "import random",
            "import pickle",
            "import logging",
            "import argparse",
            "import subprocess",
            "",
            "from collections import defaultdict",
            "",
            "import scipy as sc",
            "import numpy as np",
            "import pandas as pd",
            "",
            "import torch",
            "import torch.nn as nn",
            "import torch.nn.functional as F",
            "",
            "from tqdm import tqdm",
            "",
            "BASE_DIR = os.path.dirname(os.path.abspath(__file__))",
            "",
            "parser = argparse.ArgumentParser()",
            "## required",
            "",
            "## others",
            "parser.add_argument('--device', default='cuda:0', help='Devices')",
            "parser.add_argument('--mode', type=str, default='train', help=\"Train or test\")",
            "parser.add_argument('--lr', type=float, default=1e-4, help=\"Learning rate\")",
            "parser.add_argument('--weight_decay', type=float, default=0.0001, help=\"Weight Decay\")",
            "### less important",
            "parser.add_argument('--seed', type=int, default=12, help=\"Seed\")",
            "parser.add_argument('--basepath', default=BASE_DIR, help='\u5f53\u524d\u76ee\u5f55')",
            "parser.add_argument('--dir', type=str, default='ckpt', help=\"Checkpoint directory\")",
            "",
            "",
            "",
            "opt = parser.parse_args()",
            "",
            "torch.manual_seed(opt.seed)",
            "torch.cuda.manual_seed(opt.seed)",
            "random.seed(opt.seed)",
            "np.random.seed(opt.seed)",
            "",
            "",
            "if not os.path.exists(opt.dir):",
            "    os.mkdir(opt.dir)",
            "",
            "def load_from_json(fin):",
            "    datas = []",
            "    for line in fin:",
            "        data = json.loads(line)",
            "        datas.append(data)",
            "    return datas",
            "",
            "def dump_to_json(datas, fout):",
            "    for data in datas:",
            "        fout.write(json.dumps(data, sort_keys=True, separators=(',', ': '), ensure_ascii=False))",
            "        fout.write('\\n')",
            "    fout.close()",
            "",
            "class Model(nn.Module):",
            "    \"\"\"",
            "    here you can write sth about your model",
            "    \"\"\"",
            "    def __init__(self):",
            "        super(Model, self).__init__()",
            "",
            "    def forward(self):",
            "        pass",
            "",
            "class MyDataset(torch.utils.data.Dataset):",
            "    \"\"\"[here you write your dataset]",
            "",
            "    Arguments:",
            "        torch {[type]} -- [description]",
            "    \"\"\"",
            "    def __init__(self, data_pth, is_train=True):",
            "        self.datas = []",
            "        pass",
            "",
            "    def __len__(self):",
            "        return len(self.datas)",
            "",
            "    def __getitem__(self, index):",
            "        data = self.datas[index]",
            "",
            "        X = '0'",
            "        Y = '0'",
            "        return X, Y",
            "",
            "def get_dataset(data_path, is_train=True):",
            "    return MyDataset(data_path, is_train=is_train)",
            "",
            "def get_dataloader(dataset, batch_size, is_train=True):",
            "    return torch.utils.data.DataLoader(dataset=dataset, batch_size=batch_size, shuffle=is_train)",
            "",
            "def save_model(path, model):",
            "    model_state_dict = model.state_dict()",
            "    torch.save(model_state_dict, path)",
            "",
            "def train():",
            "    train_path = '' ###",
            "    dev_path = '' ###",
            "",
            "    train_set = get_dataset(train_path, is_train=True)",
            "    dev_set = get_dataset(dev_path, is_train=False)",
            "    train_batch = get_dataloader(train_set, opt.batch_size, is_train=True)",
            "    model = Model() ####",
            "",
            "    if opt.restore != '':",
            "        model_dict = torch.load(opt.restore)",
            "        model.load_state_dict(model_dict)",
            "",
            "    model.to(opt.devices)",
            "    optim = torch.optim.Adam(filter(lambda p: p.requires_grad, model.parameters()),",
            "                            lr=opt.lr,",
            "                            weight_decay=opt.weight_decay",
            "                        )",
            "",
            "    for epoch in range(1, opt.epoch+1):",
            "        model.train()",
            "        report_loss, start_time = 0, time.time()",
            "        for batch in train_batch:",
            "            model.zero_grad()",
            "            X, Y = batch",
            "",
            "            pred_x = model(X)",
            "            loss = model.loss(X, y)",
            "            loss.backward()",
            "            optim.step()",
            "",
            "    return model",
            "",
            "",
            "",
            "def eval(dev_set, model):",
            "    pass",
            "",
            "def test(test_set, model):",
            "    print('string testing...')",
            "",
            "",
            "def main():",
            "    if opt.mode == 'train':",
            "        train()",
            "    else:",
            "        test_path = ''",
            "        test_set = get_dataset(test_path, is_train=False)",
            "        model = Model() ##",
            "        model_dict = torch.load(opt.restore)",
            "        model.load_state_dict(model_dict)",
            "        model.to(opt.device)",
            "        test(test_set, model)",
            "",
            "if __name__ == \"__main__\":",
            "    main()",
            ""
          ]
        }

    

.. dropdown:: [pylib]  pylib"

   .. code-block:: json

        {
          "prefix": "pylib",
          "body": [
            "import os",
            "import re",
            "import sys",
            "import time",
            "import json",
            "import math",
            "import random",
            "import pickle",
            "import logging",
            "import argparse",
            "import subprocess",
            "",
            "from collections import defaultdict",
            "",
            "import scipy as sc",
            "import numpy as np",
            "import pandas as pd",
            "",
            "import torch",
            "import torch.nn as nn",
            "import torch.nn.functional as F",
            "",
            "from tqdm import tqdm",
            "",
            "BASE_DIR = os.path.dirname(os.path.abspath(__file__))",
            "",
            "parser = argparse.ArgumentParser()",
            "parser.add_argument('--dirpath', default=BASE_DIR, help='\u5f53\u524d\u76ee\u5f55')",
            "args = parser.parse_args()",
            "",
            "",
            "def main():",
            "    pass",
            "",
            "",
            "if __name__ == \"__main__\":",
            "    main()",
            "",
            ""
          ]
        }

    
latex
-----

.. dropdown:: [beamer_only_fig]  beamer_only_fig"

   .. code-block:: json

        {
          "prefix": "beamer_only_fig",
          "body": [
            "\\begin{frame}{xxx}",
            "    \\begin{tikzpicture}[remember picture,overlay]",
            "    \\node[anchor=center] (a) at ($(current page.center) + (0, 0cm)$)",
            "    {",
            "            \\includegraphics[width=\\linewidth]{figure/xxx}",
            "    };",
            "    \\node[below left=of a.south, xshift=0.5\\linewidth, yshift=1.3cm] {xxx};",
            "\\end{tikzpicture}",
            "",
            "\\end{frame}"
          ]
        }

    

.. dropdown:: [beamer_img]  beamer_img"

   .. code-block:: json

        {
          "prefix": "beamer_img",
          "body": [
            "\\begin{tikzpicture}[remember picture,overlay,]",
            "    \\node[anchor=center] (a) at ($(current page.center)+(0, -1cm)$)",
            "    {",
            "        \\includegraphics[width=0.8\\linewidth]{./figure/graphsage.png}",
            "    };",
            "    \\node[below left=of a.south, xshift=0.5\\linewidth, yshift=1.3cm] {\\tinycite[NIPS2018]{hamilton2017inductive}};",
            "",
            "\\end{tikzpicture}"
          ]
        }

    
restructuredtext
----------------

.. dropdown:: [ablog_img_new]  ablog_img_new"

   .. code-block:: json

        {
          "prefix": "ablog_img_new",
          "body": [
            ".. figure:: ./assets/$1",
            "    :width: 80%",
            "",
            "    $2"
          ]
        }

    

.. dropdown:: [ablog_begin]  ablog_begin"

   .. code-block:: json

        {
          "prefix": "ablog_begin",
          "body": [
            ".. post:: $CURRENT_MONTH_NAME_SHORT, $CURRENT_DATE, $CURRENT_YEAR",
            "   :tags: ICT, PhD",
            "   :category: PhD",
            "   :author: hotchilipowder",
            "   :location: Beijing",
            "   :language: zh",
            "",
            "=======================",
            "$1",
            "======================="
          ]
        }

    
