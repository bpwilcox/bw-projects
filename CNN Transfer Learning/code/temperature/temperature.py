import time
import numpy as np
import os
from set_dat import prepare_folders
from keras.models import Model, Sequential
from keras.layers import Dense, Input, Lambda, Activation
from keras.utils import np_utils
from keras.preprocessing.image import load_img, img_to_array
from keras.preprocessing.image import ImageDataGenerator
from keras.applications import vgg16

start = time.time()
batch_size = 2

nb_epoch = 16
num_cls = 64

cls_per_fil = 32
tot_cls = 256

tr_samp = 16
vl_samp = 4
strt_cls = 0
cur_dir = 'code/temperature/'
bin_dir = 'data/cal_predictions/no_norm/'
trn_dir = bin_dir + 'train/'
val_dir = bin_dir + 'validation/'
trn_dir = os.path.relpath(trn_dir, cur_dir) + '/'
val_dir = os.path.relpath(val_dir, cur_dir) + '/'
#dat_dir = 'data/'

tr_head = ''
vl_head = ''
tr_fil = trn_dir + tr_head + '{0:d}_{1:d}.npy'
vl_fil = val_dir + vl_head + '{0:d}_{1:d}.npy'

#cls_dirs = list(np.sort(os.listdir(dat_dir)))
cls_mode = 'categorical'
img_size=(224, 224)



tr_dat = None
vl_dat = None


tr_lab = []
vl_lab = []

for k in range(0, num_cls, cls_per_fil):
    tr = np.load(tr_fil.format(k, k + cls_per_fil))
    vl = np.load(vl_fil.format(k, k + cls_per_fil))
    for cls in range(k, k + cls_per_fil):
        tr_lab = tr_lab + tr_samp * [cls]
        vl_lab = vl_lab + vl_samp * [cls]    
    if tr_dat is None:
        tr_dat = tr
        vl_dat = vl
    else:
        tr_dat = np.vstack((tr_dat, tr))
        vl_dat = np.vstack((vl_dat, vl))



print(np.size(tr_lab))
print(np.size(vl_lab))
tr_lab = np_utils.to_categorical(tr_lab)
vl_lab = np_utils.to_categorical(vl_lab)

vgg = vgg16.VGG16(weights='imagenet', include_top=True)
vgg_sm = vgg.layers[-1]
vgg_sm.trainable=False


inp = Input(tr_dat.shape[1:])
temps_to_use = np.geomspace(1, 8, 8)
results = []

for T in temps_to_use:
    scale = Lambda(lambda x: x / T)(inp)
    temp = vgg_sm(scale)
    temp_out = Dense(num_cls, activation='softmax')(temp)
    temp_model = Model(input=inp, output=temp_out)
    temp_model.compile(optimizer='rmsprop',
                       loss='categorical_crossentropy',
                       metrics=['accuracy'])
    res = temp_model.fit(
        tr_dat, tr_lab,
        nb_epoch=nb_epoch,
        batch_size=batch_size,
        validation_data=(vl_dat, vl_lab))
    results = results + [res]

res_arr = [r.history['val_acc'] for r in results]
whole_test = {'results' : res_arr,
              'nb_epoch' : nb_epoch,
              'num_cls' : num_cls,
              '(tr_samp, vl_samp)' : (tr_samp, vl_samp),
              'strt_cls' : strt_cls,
              'temps_to_use' : temps_to_use
}

