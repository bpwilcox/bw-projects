import time
import numpy as np
import os
from set_dat import prepare_folders
from keras.models import Model, Sequential
from keras.layers import Dense, Flatten, Input,Dropout
from keras.preprocessing.image import load_img, img_to_array
from keras.preprocessing.image import ImageDataGenerator
from keras.applications import vgg16

start = time.time()
batch_size=2
num_classes = 4
tr_samp = 32
vl_samp = 8
starting_class = 0
bin_dir = 'cal4/'
dat_dir = 'data/'
trn_dir = 'tr4/'
val_dir = 'val4/'
tr_fil = bin_dir + 'features_train_{0:d}_{1:d}.npy'
vl_fil = bin_dir + 'features_validation_{0:d}_{1:d}.npy'
cls_dirs = list(np.sort(os.listdir(dat_dir)))
cls_mode = 'categorical'
img_size=(224, 224)

prepare_folders(tr_samp, vl_samp, dat_dir, trn_dir, val_dir, bin_dir)

vgg_model = vgg16.VGG16( weights='imagenet', include_top=True ) #downloads prebuilt

for layer in vgg_model.layers:
    layer.trainable = False

vgg_out = vgg_model.layers[-2].output
softmax_layer = Dense(256, activation='softmax')(vgg_out)

model = Model(input=vgg_model.input, output=vgg_out)

datagen = ImageDataGenerator()
generator = datagen.flow_from_directory(
    trn_dir,
    target_size=img_size,
    batch_size=batch_size,
    classes=cls_dirs[starting_class:(starting_class + num_classes)],
    class_mode=cls_mode,
    shuffle=False)

end = time.time()
print('Getting to trainig took {0} times'.format((end - start)))
start = time.time()
print('Beginning training eval')

tr_feat = model.predict_generator(generator, tr_samp*num_classes)
end = time.time()

print('fin')
print('{0} classes, {1} samples took {2} times'.format(num_classes,
                                                       tr_samp,
                                                       (end - start)))
# with open(bin_dir + 'features_train_{0}_{1}.npy'
#           ''.format(starting_class,starting_class+num_classes-1),
#           'wb') as bin_fil:
fil = tr_fil.format(starting_class, starting_class+num_classes-1)
np.save(fil, tr_feat)

generator = datagen.flow_from_directory(
    val_dir,
    target_size=img_size,
    batch_size=batch_size,
    class_mode=cls_mode,
    classes=cls_dirs[starting_class:(starting_class + num_classes)],
    shuffle=False)

print('Beginning validation evaluation')
start = time.time()
vl_feat = model.predict_generator(generator, vl_samp * num_classes)
end = time.time()
print('fin')
print('{0} classes, {1} samples took {2} times'.format(num_classes,
                                                       vl_samp,
                                                       (end - start)))
# with open(BIN_DIR + 'mnstd_features_validation_{0}_{1}.npy'
#           ''.format(STARTING_CLASS,STARTING_CLASS+NUM_CLASSES),
#           'wb') as bin_fil:
fil = vl_fil.format(starting_class, starting_class+num_classes-1)
np.save(fil, vl_feat)
