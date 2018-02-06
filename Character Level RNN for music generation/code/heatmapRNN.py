# coding: utf-8

# In[272]:

import numpy as np
from keras.models import Model, Sequential
from keras.layers import Dense, Flatten, Input, Dropout, SimpleRNN, Lambda
from keras.preprocessing.image import load_img, img_to_array
from keras.preprocessing.image import ImageDataGenerator
from keras.applications import vgg16

import pdb


def choose(p):
    flip = np.random.random()
    prob = 0
    for (label, chance) in enumerate(p):
        prob += chance
        if (flip < prob):
            return label


def best(p):
    return np.argmax(p)


def insert_temp(model, k, T):
    new_mod = Sequential()
    for layer in model.layers[:k]:
        new_mod.add(layer)
    scale = Lambda(lambda x: x / T)
    new_mod.add(scale)
    for layer in model.layers[k:]:
        new_mod.add(layer)
    return new_mod


# stuff
raw_file = 'drop20song_header.txt'
dat_dir = 'data_bw/'
weight_dir = dat_dir + 'dropout_weights_h/'
mod_cfg_fil = dat_dir + 'modeldrop20.npy'
last_file = 'weights.15-2.00.hdf5'
weight_fil = weight_dir + last_file

# reading in data from file
raw_text = open(raw_file).read()
label = sorted(list(set(raw_text)))
label_dict = dict()

for (i, c) in enumerate(label):
    label_dict[c] = i

# getting number of classes (one-hot encoding so this is number of unique chars)
NUM_CLASSES = len(label)
BATCH_SIZE = 32
SEQ_LEN = 32

# creating model
config = np.load(mod_cfg_fil)
model = Sequential.from_config(config)

model.summary()
model.load_weights(weight_fil)

T = 1
temp_mod = insert_temp(model, 1, T)
for layer in temp_mod.layers:
    layer.trainable = False

# create start
start_ind = []

labeled_text = list(label_dict[c] for c in raw_text)
i = np.random.randint(len(raw_text) - 1)
sequence = labeled_text[i:i + SEQ_LEN]
seq_ind = np.arange(SEQ_LEN)
result = raw_text[i:i + SEQ_LEN]
x = None
c = None

# pdb.set_trace()

while c is not '`':
    if x is None:
        x = np.zeros((1, SEQ_LEN, NUM_CLASSES))
        x[0, seq_ind, sequence] = 1
    else:
        new_col = np.zeros(NUM_CLASSES)
        new_col[sequence[-1]] = 1
        x = np.concatenate((x[:, 1:, :], new_col[None, None, :]), axis=1)

    p = model.predict(x)[0]
    l = choose(p)
    c = label[l]

    sequence = sequence[1:]
    sequence.append(l)
    result += c
print(result)

