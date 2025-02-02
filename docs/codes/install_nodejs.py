import os
import re
import gzip
import argparse

import urllib.request

# url = 'VISUAL'
# headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'}
# req = urllib.request.Request(url, headers=headers)
# response = urllib.request.urlopen(req)
# content = response.read()

headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'}

url = 'https://nodejs.org/download/release/latest'
url_domain = 'https://nodejs.org'
req = urllib.request.Request(url, headers=headers)

res = urllib.request.urlopen(req)
content = res.read()
content = content.decode('utf8')
# print(content)
res = re.findall(r'href\=\"(.+?-linux-x64.tar.gz)\"\>', content)
if len(res) > 0:
    nodejs_url = url_domain + res[0]
else:
    nodejs_url = url_domain + '/download/release/latest/node-v23.7.0-linux-x64.tar.gz'

cmdline = rf"""
curl -OL {nodejs_url}
tar -xvf node-*.tar.gz  -C ~/.local --strip-components=1
""".strip()
print(cmdline)
