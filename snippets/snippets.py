#!/usr/bin/env python3
#-*- coding: utf-8 -*-
"""
@author: hotchilipowder
@file: snippets.py
@time: 2023/04/21
@desc: This script will read the raw dir to output vsnip_snippet
Besides, it will generate some codes for me to better usage.
"""


import os
import re
import json
import shutil
import urllib.request


BASE_DIR = os.path.dirname(os.path.abspath(__file__))
VSTEMPLATE_DIR = os.path.join(BASE_DIR, 'vscode-snips', 'raws')
VSOUTPUT_DIR = os.path.join(BASE_DIR, 'vscode-snips', '..', 'vsnip_snippets')
ULOUTPUT_DIR = os.path.join(BASE_DIR, 'UltiSnips')
PROJECT_DIR = os.path.join(BASE_DIR, '..')
DOCOUPUT_DIR = os.path.join(PROJECT_DIR, 'docs', 'rsts')

# vs_affix_dict, you can add more
vs_affix_dict = {
    'py': 'python',
    'tex': 'latex',
    'js': 'javascript',
    'md': 'markdown',
    'rst': 'restructuredtext',
}

ul_affix_dict = {
    'python': 'python',
    'tex': 'latex',
    'md': 'markdown',
    'rst': 'restructuredtext',
}


def make_snippest(fname: str):
    """with open(fname)
    read affix

    """
    fpath = os.path.join(VSTEMPLATE_DIR, fname)

    res = {}
    name, _, _ = fname.rpartition('.')

    prefix, _, affix = fname.rpartition('.')
    filetype = vs_affix_dict[affix]

    res_l = []
    with open(fpath) as f:
        for line in f:
            res_l.append(line.rstrip())

    res[name] = {}
    res[name]['prefix'] = prefix
    res[name]['body'] = res_l

    result_path = os.path.join(VSOUTPUT_DIR, f"{filetype}.json")

    if not os.path.exists(result_path):
        dic = {}
    else:
        with open(result_path, 'r', encoding='utf8') as f:
            dic = json.loads(f.read())
    dic[name] = res[name]
    with open(result_path, 'w', encoding='utf8') as f:
        f.write(json.dumps(dic, indent=4))
    print(f'Done {fname}')


def list_raws():
    raw_dirpath = VSTEMPLATE_DIR
    for fname in os.listdir(raw_dirpath):
        for affix in vs_affix_dict.keys():
            if not fname.endswith(affix):
                continue
        make_snippest(fname)


def make_a_vssnippt_to_rst(k: str, v: dict):
    codes_json = json.dumps(v, indent=2)
    codes = ""
    for line in codes_json.split('\n'):
        codes += ' ' * 8 + line + '\n'
    prefix = v['prefix']
    template = f"""
.. dropdown:: [{prefix}]  {k}"

   .. code-block:: json

{codes}
    """
    return template


def make_vssnippet_to_rst():
    rst_path = os.path.join(DOCOUPUT_DIR, '_vs-snippet.rst')
    res_f = open(rst_path, 'w')
    for prefix, affix in vs_affix_dict.items():
        fpath = os.path.join(VSOUTPUT_DIR, f'{affix}.json')
        if not os.path.exists(fpath):
            continue
        res_f.write(affix + '\n')
        res_f.write(len(affix) * '-' + '\n')
        with open(fpath) as f:
            jd = json.load(f)
            for k, v in jd.items():
                res = make_a_vssnippt_to_rst(k, v)
                res_f.write(res + '\n')
        dst_path = os.path.join(VSOUTPUT_DIR, f'{prefix}.json')
        shutil.copy(fpath, dst_path)


def make_ultisnippet_to_rst():
    rst_path = os.path.join(DOCOUPUT_DIR, '_ultisnippet.rst')
    res_f = open(rst_path, 'w')
    for affix, affix_name in ul_affix_dict.items():
        fpath = os.path.join(ULOUTPUT_DIR, f'{affix}.snippets')
        print(fpath)
        if not os.path.exists(fpath):
            continue
        res_f.write(affix_name + '\n')
        res_f.write(len(affix_name) * '-' + '\n')

        with open(fpath) as f:
            content = f.read()
            pattern = r"snippet\s+(\w+)\s+\"(.*?)\"\s+.*\n(.*?)\nendsnippet"
            print(content)
            for prefix, desc, code  in re.findall(pattern, content):
                codes = ""
                for l in code.split('\n'):
                    codes += ' ' * 8 + l + '\n'
                template = f"""
.. dropdown:: [{prefix}]  {desc}

   .. code-block:: bash

{codes}
    """
                res_f.write(template + '\n')

def rewrite_content(fpath, pattern='##########', content=None):
    """
    rewrite with pattern.
    For example, find the pattern begining, and endding
    write the contnet if None, keep original content.
    """
    pass


def make_emoji_ultisnippets():
    """
    see `sphinxemojicodes <https://sphinxemojicodes.readthedocs.io/en/stable/#supported-codes>`_
    """
    url = 'https://sphinxemojicodes.readthedocs.io/en/stable/'
    headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'}
    req = urllib.request.Request(url, headers=headers)
    response = urllib.request.urlopen(req)
    content = response.read()
    import lxml.html
    dom = lxml.html.fromstring(content)
    emoji_xpath = '//table[@id="id1"]/tbody/tr'
    emoji_codes = []
    for item in dom.xpath(emoji_xpath):
        emoji = item.xpath('./td/p/text()')
        code  = "".join(item.xpath('./td/p/code//text()')).strip()
        code = code.replace(':', "")
        emoji_codes.append(code)
    print(json.dumps(emoji_codes, indent=2))
    

def make_gitignore_snippets():
    """
    see `github/gitignore <https://github.com/github/gitignore>`_
    """
    url = ''
    


def main():
    list_raws()
    make_vssnippet_to_rst()
    make_ultisnippet_to_rst()
    # make_emoji_ultisnippets()



if __name__ == "__main__":
    main()

