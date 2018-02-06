
# coding: utf-8

# In[155]:

import numpy as np
import os
import re
from keras.models import Sequential
from keras.layers import Dense, Flatten, Input, Dropout, LSTM, Merge
from keras.callbacks import ModelCheckpoint


# In[156]:

#what data are we creating
weight_dir='weights/bidir/'
last_file=''
last_epoch=0
padding = '*'*50 + '\n'
print(len(os.listdir('data/changed_poems')))


# In[157]:

#get label maps
problem_files = open('problem_files.txt').read().split("\n")
filename = os.listdir('data/changed_poems')[0]

english_chars = set(['*'])

for filename in os.listdir('data/changed_poems'):
    if filename in problem_files or not filename.endswith('.txt'): continue
    f = open('data/changed_poems/' + filename)
    lines = f.readlines()
    english = '\n'.join(lines[::2])
    english_chars = english_chars.union(english)
    
def create_one_hot(s):
    res = {}
    for i,c in enumerate(s):
        res[c] = np.zeros(len(s))
        res[c][i] = 1
    return res
english_sorted = sorted(list(english_chars))
meter_sorted = sorted(['\n','*','.','-','+'])
english_labels = create_one_hot(english_sorted)
meter_labels = create_one_hot(meter_sorted)


# In[158]:

#get poem
problem_files = open('problem_files.txt').read().split("\n")
english = padding
meter = padding
for filename in os.listdir('data/changed_poems'):
    if filename in problem_files or not filename.endswith('.txt'):continue
    f = open('data/changed_poems/' + filename)
    lines = f.readlines()
    
    english += "".join(lines[::2]) + padding
    meter += "".join(lines[1::2]) + padding


# In[159]:

SEQ_LEN = 16
BATCH_SIZE = 32


# In[160]:

#formatting training/validation data and labels
train_english = list(english[:round(len(english)*0.8)])
train_meter = list(meter[:round(len(meter)*0.8)])

val_english = list(english[round(len(english)*0.8):])
val_meter = list(meter[round(len(meter)*0.8):])


train_labels = [english_labels[c] for c in train_english]
train_meter = [meter_labels[c] for c in train_meter]

val_labels = [english_labels[c] for c in val_english]
val_meter = [meter_labels[c] for c in val_meter]

X = np.array([train_labels[i:i+SEQ_LEN] for i in range(len(train_labels)-SEQ_LEN)])
X = np.reshape(X,(len(train_labels) - SEQ_LEN, SEQ_LEN, len(english_sorted)))
y = np.array(train_meter[SEQ_LEN//2:-SEQ_LEN//2])

val_X = np.array([val_labels[i:i+SEQ_LEN] for i in range(len(val_labels)-SEQ_LEN)])
val_X = np.reshape(val_X,(len(val_labels) - SEQ_LEN, SEQ_LEN, len(english_sorted)))
val_y = np.array(val_meter[SEQ_LEN//2:-SEQ_LEN//2])


# In[161]:

#creating model
model = Sequential()
layers = [1, 128, len(meter_sorted)]

left = Sequential()
left.add(LSTM(output_dim=layers[1], return_sequences=False, input_shape=(SEQ_LEN, len(english_sorted))))

right = Sequential()
right.add(LSTM(output_dim=layers[1], return_sequences=False,
               input_shape=(SEQ_LEN, len(english_sorted)), go_backwards=True))

model = Sequential()
model.add(Merge([left, right], mode='sum'))

model.add(Dense(layers[2], activation='softmax'))

model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])


# In[162]:

filepath=weight_dir + "weights.{epoch:02d}-{val_loss:.2f}.hdf5"
checkpoint = ModelCheckpoint(filepath)

res = model.fit([X,X], y, nb_epoch=16, batch_size=1,
                validation_data=([val_X,val_X], val_y), callbacks=[checkpoint],
                initial_epoch=last_epoch)


# In[ ]:



