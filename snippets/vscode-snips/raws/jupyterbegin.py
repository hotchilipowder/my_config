import os
import re
import sys
import time
import json
import math
import random
import pickle
import logging
import subprocess

from collections import defaultdict

import scipy as sc
import pandas as pd
import seaborn as sns
import numpy as np
import matplotlib

import networkx as nx
from tqdm import tqdm_notebook

### this config add some fonts to the ttflist dir
import matplotlib.font_manager as font_manager
font_dirs = ['/home/huangjunjie/fonts']
font_files = font_manager.findSystemFonts(fontpaths=font_dirs)
font_list = font_manager.createFontList(font_files)
# print(font_list) # list what fonts you have
font_manager.fontManager.ttflist.extend(font_list)

## this set to matplotlib
matplotlib.rcParams['font.family'] = "sans-serif"
matplotlib.rcParams['font.sans-serif'] = ["CMU Sans Serif"]
import matplotlib.pyplot as plt
plt.style.context('journal')

%matplotlib inline
sns.set_context("paper", font_scale=1.5, rc={'text.usetex' : True})
sns.set_style("white")
sns.set_style({'font.family': 'sans-serif'})
sns.set_style({'font.sans-serif': ["Helvetica"]})