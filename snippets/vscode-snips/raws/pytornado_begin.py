#!/usr/bin/env python

import os
import sys
import logging

import tornado.httpserver
import tornado.ioloop
import tornado.wsgi
import tornado.web

logger = logging.getLogger('tornado_proxy')
 # https://github.com/senko/tornado-proxy/blob/master/tornado_proxy/proxy.py
class MainHandler(tornado.web.RequestHandler):
    async def get(self):
        self.write("Hello world!")
        self.finish()



if __name__ == "__main__":
    # path to your settings module
    os.environ['DJANGO_SETTINGS_MODULE'] = 'xxx.settings'
    os.environ["DJANGO_ALLOW_ASYNC_UNSAFE"] = "true"
    # from xxx.wsgi import application
    # container = tornado.wsgi.WSGIContainer(application)

    tornado_app = tornado.web.Application(
        [
            # python manage.py collectstatic to get django statics
            (r'/static/(.*)', tornado.web.StaticFileHandler, {"path": './staticfiles'}),
            (r'/uploads/(.*)', tornado.web.StaticFileHandler, {"path": './uploads'}),
            # (r'/admin.*', tornado.web.FallbackHandler, dict(fallback=container)),
            (r'.*', MainHandler),
        ],
        debug=True,
        autoreload=True
    )
    http_server = tornado.httpserver.HTTPServer(tornado_app)
    http_server.bind(21318, address='0')
    http_server.start(0)  # forks one process per cpu
    tornado.ioloop.IOLoop.current().start()

