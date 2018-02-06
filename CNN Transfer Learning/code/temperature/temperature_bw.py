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

nb_epoch = 4
num_cls = 32
cls_per_fil = 32
tot_cls = 32

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


T = 16


tr_dat = None
vl_dat = None


tr_lab = []
vl_lab = []

for k in range(0, tot_cls, cls_per_fil):
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



#print(np.size(tr_lab))
#print(np.size(vl_lab))
tr_lab = np_utils.to_categorical(tr_lab)
vl_lab = np_utils.to_categorical(vl_lab)

vgg = vgg16.VGG16(weights='imagenet', include_top=True)
vgg_sm = vgg.layers[-1]
vgg_sm.trainable=False

#print(vgg_sm.get_weights())



inp = Input(tr_dat.shape[1:])

temp = Dense(1000)(inp)
temp = Lambda(lambda x: x / T)(temp)
temp = Activation('softmax')(temp)
out = Dense(num_cls, activation='softmax')(temp)

#scale = Lambda(lambda x: x / T)(inp)
#temp = vgg_sm(scale)
#temp_out = Dense(num_cls, activation='softmax')(temp)
#out = Dense(num_cls, activation='softmax')(inp)


temp_model = Model(input=inp, output=out)
temp_model.summary()
#model = Model(input=inp, output=out)

temp_model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])
#model.compile(optimizer='rmsprop',
  #            loss='categorical_crossentropy',
  #            metrics=['accuracy'])

temp_model.fit(tr_dat, tr_lab, nb_epoch=nb_epoch, batch_size=batch_size,
               validation_data=(vl_dat, vl_lab))
#model.fit(tr_dat, tr_lab, nb_epoch=nb_epoch, batch_size=batch_size,
 #              validation_data=(vl_dat, vl_lab))
