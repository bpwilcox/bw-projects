import os
from os.path import join
from numpy.random import permutation

def prepare_folders(tr_samp, vl_samp, dat_fold='data', trn_fold='train',
                    val_fold='val', bin_dir='cal_predictions'):
    if os.access(trn_fold, mode=1):
        os.system('rm -r ' + trn_fold)
    if os.access(val_fold, mode=1):
        os.system('rm -r ' + val_fold)
    if not os.access(bin_dir, mode=1):
        os.mkdir(bin_dir)
    os.mkdir(trn_fold)
    os.mkdir(val_fold)
    
    for folder in os.listdir(dat_fold):
        images = os.listdir(join(dat_fold, folder))
        pm = permutation(tr_samp + vl_samp)
        if folder not in os.listdir(trn_fold):
            os.mkdir(join(trn_fold, folder))
        if folder not in os.listdir(val_fold):
            os.mkdir(join(val_fold, folder))
        for k in range(tr_samp):
            dst = join(trn_fold, folder)
            src = join(dat_fold, folder, images[pm[k]])
            os.symlink(
                os.path.relpath(src, dst),
                join(dst, images[pm[k]]))
        for k in range(tr_samp, tr_samp + vl_samp):
            dst = join(val_fold, folder)
            src = join(dat_fold, folder, images[pm[k]])
            os.symlink(
                os.path.relpath(src, dst),
                join(dst, images[pm[k]]))
