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
## required

## others
parser.add_argument('--device', default='cuda:0', help='Devices')
parser.add_argument('--mode', type=str, default='train', help="Train or test")
parser.add_argument('--lr', type=float, default=1e-4, help="Learning rate")
parser.add_argument('--weight_decay', type=float, default=0.0001, help="Weight Decay")
### less important
parser.add_argument('--seed', type=int, default=12, help="Seed")
parser.add_argument('--basepath', default=BASE_DIR, help='当前目录')
parser.add_argument('--dir', type=str, default='ckpt', help="Checkpoint directory")



opt = parser.parse_args()

torch.manual_seed(opt.seed)
torch.cuda.manual_seed(opt.seed)
random.seed(opt.seed)
np.random.seed(opt.seed)


if not os.path.exists(opt.dir):
    os.mkdir(opt.dir)

def load_from_json(fin):
    datas = []
    for line in fin:
        data = json.loads(line)
        datas.append(data)
    return datas

def dump_to_json(datas, fout):
    for data in datas:
        fout.write(json.dumps(data, sort_keys=True, separators=(',', ': '), ensure_ascii=False))
        fout.write('\n')
    fout.close()

class Model(nn.Module):
    """
    here you can write sth about your model
    """
    def __init__(self):
        super(Model, self).__init__()
    
    def forward(self):
        pass

class MyDataset(torch.utils.data.Dataset):
    """[here you write your dataset]
    
    Arguments:
        torch {[type]} -- [description]
    """
    def __init__(self, data_pth, is_train=True):
        self.datas = []
        pass

    def __len__(self):
        return len(self.datas)
    
    def __getitem__(self, index):
        data = self.datas[index]

        X = '0'
        Y = '0'
        return X, Y

def get_dataset(data_path, is_train=True):
    return MyDataset(data_path, is_train=is_train)

def get_dataloader(dataset, batch_size, is_train=True):
    return torch.utils.data.DataLoader(dataset=dataset, batch_size=batch_size, shuffle=is_train)

def save_model(path, model):
    model_state_dict = model.state_dict()
    torch.save(model_state_dict, path)

def train():
    train_path = '' ###
    dev_path = '' ### 

    train_set = get_dataset(train_path, is_train=True)
    dev_set = get_dataset(dev_path, is_train=False)
    train_batch = get_dataloader(train_set, opt.batch_size, is_train=True)
    model = Model() #### 

    if opt.restore != '':
        model_dict = torch.load(opt.restore)
        model.load_state_dict(model_dict)

    model.to(opt.devices)
    optim = torch.optim.Adam(filter(lambda p: p.requires_grad, model.parameters()), 
                            lr=opt.lr,
                            weight_decay=opt.weight_decay
                        )
    
    for epoch in range(1, opt.epoch+1):
        model.train()
        report_loss, start_time = 0, time.time()
        for batch in train_batch:
            model.zero_grad()
            X, Y = batch

            pred_x = model(X)
            loss = model.loss(X, y)
            loss.backward()
            optim.step()
    
    return model



def eval(dev_set, model):
    pass

def test(test_set, model):
    print('string testing...')


def main():
    if opt.mode == 'train':
        train()
    else:
        test_path = ''
        test_set = get_dataset(test_path, is_train=False)
        model = Model() ##
        model_dict = torch.load(opt.restore)
        model.load_state_dict(model_dict)
        model.to(opt.device)
        test(test_set, model)

if __name__ == "__main__":
    main()

