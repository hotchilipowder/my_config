import os
import re
import sys
import time
import json
import math
import random
import pickle
import logging
import argparse
import subprocess

from collections import defaultdict

import scipy as sc
import numpy as np
import pandas as pd

import torch
import torch.nn as nn
import torch.nn.functional as F

from tqdm import tqdm

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

parser = argparse.ArgumentParser()
parser.add_argument('--dirpath', default=BASE_DIR, help='当前目录')
args = parser.parse_args()


def main():
    pass


if __name__ == "__main__":
    main()

    