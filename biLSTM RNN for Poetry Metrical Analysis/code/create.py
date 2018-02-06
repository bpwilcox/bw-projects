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
weight_dir='weights/aws_bidir/'
weight_fil = weight_dir + 'weights.15-4.50.hdf5'
poem_dir='data/generate_poem/'
padding = '*'*50 + '\n'


# In[157]:

#get label maps
english_chars = set(['*'])
problem_files = open('problem_files.txt').read().split("\n")

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
english = padding
for filename in os.listdir(poem_dir):
    f = open(poem_dir + filename)
    lines = f.readlines()

    english += "".join(lines) + padding

    f.close()

# In[159]:

SEQ_LEN = 16
BATCH_SIZE = 32


# In[160]:

#formatting training/validation data and labels
train_english = list(english)

train_labels = [english_labels[c] for c in train_english]

X = np.array([train_labels[i:i+SEQ_LEN] for i in range(len(train_labels)-SEQ_LEN)])
X = np.reshape(X,(len(train_labels) - SEQ_LEN, SEQ_LEN, len(english_sorted)))


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

model.load_weights(weight_fil)

y = model.predict([X,X], batch_size=BATCH_SIZE, verbose=0)
out = ''
for arr in y:
    out += meter_sorted[np.argmax(arr)]


for line,line2 in zip(out.split('\n'),english.split('\n')):
    print(line2)
    print(line)
#res = model.fit([X,X], y, nb_epoch=16, batch_size=1, callbacks=[checkpoint])

# In[ ]:
