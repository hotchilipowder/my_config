#!/usr/bin/env python3
#-*- coding: utf-8 -*-
"""
@author: hotchilipowder
@file: update_ultisnip_from_local.py
@time: 2023/09/11
"""

import os


BASE_DIR = os.path.dirname(os.path.abspath(__file__))

parser = argparse.ArgumentParser()
parser.add_argument('--dirpath', default=BASE_DIR, help='当前目录')
args = parser.parse_args()


def main():
    pass


if __name__ == "__main__":
    main()


