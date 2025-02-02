import os
import re
import gzip

import urllib.request

# url = 'VISUAL'
# headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'}
# req = urllib.request.Request(url, headers=headers)
# response = urllib.request.urlopen(req)
# content = response.read()

headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'}


def python_install():
    url = 'https://www.python.org/downloads'
    req = urllib.request.Request(url, headers=headers)
    req.add_header('Accept-Encoding', 'gzip')
    response = urllib.request.urlopen(req)
    # after reading website, the response is gzip
    content = gzip.decompress(response.read())
    content = content.decode('utf8')
    res = re.findall(r'class=\"download-buttons\"\>.+?href=\"(.+?)\".+?\</p\>', content, re.DOTALL)
    if len(res) > 0:
        link = res[0].strip()
        return link
    return 'https://www.python.org/ftp/python/3.12.8/Python-3.12.8.tar.xz'

python_url = python_install()
cmdline = rf"""
curl -OL {python_url}
tar -xvf Python-*.tar.xz
./configure --enable-optimizations --with-lto --prefix=~/.local
make -j 4
make install
""".strip()
print(cmdline)
