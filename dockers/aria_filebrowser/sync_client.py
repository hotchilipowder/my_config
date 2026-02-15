#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
@author: pepper
@file: sync_fb.py
@time: 2022/07/27

uv pip install aiohttp tqdm
"""
import os
import re
import time
import argparse
import urllib.parse
import asyncio

import aiohttp
from tqdm import tqdm

import logging
logger = logging.getLogger(__file__)

# create logger
logger = logging.getLogger(__file__)
logger.setLevel(logging.DEBUG)

# create console handler and set level to debug
ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)

# create file handler and set level to debug
fh = logging.FileHandler(f'{__file__}.log')
fh.setLevel(logging.INFO)

# create formatter
formatter = logging.Formatter(
    '%(asctime)s - %(levelname)s - %(filename)s:%(lineno)d - %(message)s')

# add formatter to console handler and file handler
ch.setFormatter(formatter)
fh.setFormatter(formatter)

# add console handler and file handler to logger
logger.addHandler(ch)
logger.addHandler(fh)


BASE_DIR = os.path.dirname(os.path.abspath(__file__))

parser = argparse.ArgumentParser()
parser.add_argument('--dirpath', default=BASE_DIR, help='当前目录')
args = parser.parse_args()

file_regs = [
    r'^B.*mp4$',
    r'.mkv$',
    r'.mp4$',
    r'.*rar$',
    r'.*ts$',
    r'.*TS$',
    r'.*avi$',
    r'^IMG.*mp4$'
]


class FBDownloader:
    def __init__(self, hostname, username='admin', password='xxxx') -> None:
        self.hostname = hostname
        self.username = username
        self.password = password
        self.token = None

    async def get_token(self):
        if self.token is None:
            url = f'{self.hostname}/api/login'
            datas = {
                "username": self.username,
                "password": self.password
            }
            async with aiohttp.ClientSession(trust_env=True) as session:
                # you need use json instead of data
                async with session.post(url, json=datas) as resp:
                    token = await resp.text()
                    self.token = token
        return self.token

    async def download_file(self, path, filename=None, token=None):
        url = f'{self.hostname}/api/raw{path}'
        token = await self.get_token()

        headers = {
            'x-auth': token,
            'Accept': 'application/json'
        }
        if filename is None:
            _, _, filename = url.rpartition('/')

        # int(response.headers.get('content-length', 0))
        total_size_in_bytes = 0
        progress_bar = None
        fpath = os.path.join('tss', filename)
        if os.path.exists(fpath):
            return f'{filename} has downloaded'
        # else continue downloading

        path = urllib.parse.quote(path)
        url = f'{self.hostname}/api/raw{path}'

        fpath = os.path.join('tss', f'{filename}.part')

        if os.path.exists(fpath):
            first_byte = os.path.getsize(fpath)
        else:
            first_byte = 0

        async with aiohttp.ClientSession(trust_env=True) as session:
            async with session.get(url, headers=headers) as resp:
                total_size_in_bytes = int(
                    resp.headers.get('content-length', 10))
            header_len = {"Range": f"bytes={first_byte}-{total_size_in_bytes}"}
            headers.update(header_len)
            if total_size_in_bytes == 0:
                return f"{filename}"
            logger.info(total_size_in_bytes)

            async with session.get(url, headers=headers) as resp:
                if first_byte < total_size_in_bytes:
                    progress_bar = tqdm(
                        initial=first_byte, total=total_size_in_bytes, unit='iB', unit_scale=True)
                    with open(fpath, 'ab') as f:
                        async for chunk, end_of_http_chunk in resp.content.iter_chunks():
                            progress_bar.update(len(chunk))
                            f.write(chunk)
                            if end_of_http_chunk:
                                progress_bar.close()
            os.rename(fpath, fpath.replace('.part', ''))
            await self.delete_resource(path)
            logger.info(f'delete {fpath}')
        return f'{filename} downloaded!'

    async def get_flist(self, path='/'):

        token = await self.get_token()
        headers = {
            'x-auth': token,
            'Accept': 'application/json'
        }

        url = f'{self.hostname}/api/resources{path}'
        jd = {}
        async with aiohttp.ClientSession(trust_env=True) as session:
            async with session.get(url, headers=headers) as resp:
                jd = await resp.json()
        file_list = []
        file_paths = [i['path'] for i in jd['items']]
        for item in jd['items']:
            is_dir = item['isDir']
            path = item['path']
            logger.debug(f'{is_dir} {path} 154')
            aria_fpath = f'{path}.aria2'
            if aria_fpath in file_paths:
                logger.debug(f'{aria_fpath} skipped')
                continue
            if is_dir:
                res = await self.get_flist(path)
                file_list.extend(res)
            else:
                file_list.append(item)
        file_list = sorted(file_list, key=lambda x: x['modified'])
        return file_list

    async def run_sync(self):
        fls = await self.get_flist()
        for f_reg in file_regs:
            for file in fls:
                path = file['path']
                _, _, fname = path.rpartition('/')
                fpath = os.path.join('tss', fname)
                fpath_part = os.path.join('tss', f'{fname}.part')
                if re.search(f_reg, fname) or os.path.exists(fpath_part):
                    if os.path.exists(fpath):
                        # downloaed
                        logger.info(f'{fpath} downloaed')
                        await self.delete_resource(path)
                        logger.info(f'{fpath} deleted')
                        continue
                    else:
                        logger.info(f'{fpath} downloading')
                        task = asyncio.create_task(self.download_file(path))
                        await task
                    await task

    async def delete_resource(self, path):
        url = f'{self.hostname}/api/resources{path}'
        token = await self.get_token()
        headers = {
            'x-auth': token,
            'Accept': 'application/json'
        }
        async with aiohttp.ClientSession(trust_env=True) as session:
            async with session.delete(url, headers=headers) as resp:
                logger.debug(f'{url} {resp} 168')


def scan_rar_files():
    tss_dir = 'tss'
    for fname in os.listdir('tss'):
        name, _, _ = fname.rpartition('.')
        src = os.path.join(tss_dir, fname)
        dst = os.path.join(tss_dir, name)
        if os.path.exists(dst):
            continue
        if fname.endswith('.rar') and not os.path.exists(name):
            cmdline = f'rar/unrar x -o+ {src} {tss_dir}'
            logger.debug(cmdline)
            os.system(cmdline)
            # cmdline = f'rm {src}'
            # os.system(cmdline)
        else:
            logger.info(f'{src} done!')


def main():
    servers = [
        ['http://xxxx', 'xxx', 'xxx'],
    ]

    while True:
        fb_ins = []
        for server in servers:
            s_in = FBDownloader(
                hostname=server[0], username=server[1], password=server[2])
            fb_ins.append(s_in)

        for fb_in in fb_ins:
            logger.debug(fb_in.hostname)
            try:
                asyncio.run(fb_in.run_sync())
            except Exception as e:
                logger.exception(e)
                time.sleep(60.0)


if __name__ == "__main__":
    main()
