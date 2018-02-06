
# coding: utf-8

# In[14]:

import numpy as np
from keras.models import Model, Sequential
from keras.layers import Dense, Flatten, Input, Dropout, SimpleRNN
from keras.preprocessing.image import load_img, img_to_array
from keras.preprocessing.image import ImageDataGenerator
from keras.applications import vgg16
from keras.callbacks import ModelCheckpoint
from keras.utils import np_utils
import matplotlib.pyplot as plt

import pdb

# In[15]:

#what data are we creating
raw_file='just_note.txt'
weight_dir='data_bw/dropout_weights/'
last_file= None
last_epoch=0


# In[16]:

#reading in data from file
songs = []

with open(raw_file) as f:
    songs = f.read()
label = sorted(list(set(songs)))
label_dict = dict()

for (i, c) in enumerate(label):
    label_dict[c] = i


# In[17]:

#getting number of classes (one-hot encoding so this is number of unique chars)
NUM_CLASSES = len(label)
BATCH_SIZE = 32
SEQ_LEN = 32

# pdb.set_trace()

#formatting training/validation data and labels
train_data = list(songs[:round(len(songs)*0.8)])
validation_data = list(songs[round(len(songs)*0.8):])

train_labels = list(label_dict[c] for c in train_data)
validation_labels = list(label_dict[c] for c in validation_data)

X = np.zeros(((len(train_data) - SEQ_LEN), SEQ_LEN, NUM_CLASSES))
y = train_labels[SEQ_LEN:]
seq_ind = np.arange(SEQ_LEN)

for i in range(X.shape[0]):
    X[i, seq_ind, train_labels[i : i + SEQ_LEN]] = 1
    
val_X = np.zeros(((len(validation_data) - SEQ_LEN), SEQ_LEN, NUM_CLASSES))
val_y = validation_labels[SEQ_LEN:]

for i in range(val_X.shape[0]):
    val_X[i, seq_ind, validation_labels[i : i + SEQ_LEN]] = 1
    
y = np_utils.to_categorical(y)
val_y = np_utils.to_categorical(val_y)

# pdb.set_trace()

#creating model
model = Sequential()
layers = [1, 100, NUM_CLASSES]
model.add(SimpleRNN(input_shape=(SEQ_LEN, NUM_CLASSES), output_dim=layers[1], return_sequences=False))
model.add(Dropout(0.2))
model.add(Dense(layers[2], activation='softmax'))
model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])

if last_file:
    model.load_weights(weight_dir+last_file)

model.summary()

config = model.get_config()
filename = 'data_bw/modeldrop20_n'
np.save(filename,config)


# In[ ]:

#training model
# filepath=weight_dir + "weights.{epoch:02d}-{val_loss:.2f}.hdf5"
# checkpoint = ModelCheckpoint(filepath)
#
# res = model.fit(X, y, nb_epoch=16, batch_size=BATCH_SIZE,
#                 validation_data=(val_X, val_y), callbacks=[checkpoint],
#                 initial_epoch=last_epoch)
#
# print(res.history)
#
# plt.plot(res.history['acc'])
# plt.plot(res.history['val_acc'])
# plt.title('model accuracy (headers only, dropout = 0.2)')
# plt.ylabel('accuracy')
# plt.xlabel('epoch')
# plt.legend(['train', 'test'], loc='upper left')
# plt.show()
# # summarize history for loss
# plt.plot(res.history['loss'])
# plt.plot(res.history['val_loss'])
# plt.title('model loss (headers only, dropout = 0.2)')
# plt.ylabel('loss')
# plt.xlabel('epoch')
# plt.legend(['train', 'test'], loc='upper left')
# plt.show()
#
# filename = 'data_bw/bw_drop20_h'
# np.save(filename,res.history)
#
# # x = np.load(filename+'.npy')
# # print(x)
