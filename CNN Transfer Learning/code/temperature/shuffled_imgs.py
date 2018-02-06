import os
from os.path import join
from numpy.random import permutation

bad_fold = '257.clutter'
dat_fold = 'data'
trn_fold = 'train'
val_fold = 'val'

tr_samp = 16
vl_samp = 4

if bad_fold in os.listdir(dat_fold):
    os.rmdir(join(dat_fold, bad_fold))

if os.access(trn_fold, mode=1):
    os.system('rm -r ' + trn_fold)
if os.access(val_fold, mode=1):
    os.system('rm -r ' + val_fold)

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
