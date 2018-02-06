
# coding: utf-8

# In[433]:

import numpy as np
from keras.models import Model
from keras.layers import Dense, Input


# In[ ]:




# In[434]:

#CONSTANTS
BATCH_SIZE = 4
NCPF = 32 #number of classes per file
NUM_CLASSES = 8*32
TRAIN_SAMPLES = 1
MAX_TRAIN_SAMPLES = 16
VAL_SAMPLES = 4
NUM_EPOCHS = 15

BIN_DIR = '../data/cal_predictions/no_norm/'


# In[435]:

def only_used(train_data):
    return np.concatenate([train_data[MAX_TRAIN_SAMPLES*i:MAX_TRAIN_SAMPLES*i+TRAIN_SAMPLES] for i in range(NCPF)])

#load training and validation data
train_data = only_used(np.load(open(BIN_DIR + 'train/{0}_{1}.npy'.format(0,NCPF),'rb')))
val_data = np.load(open(BIN_DIR + 'validation/{0}_{1}.npy'.format(0,NCPF),'rb'))
for i in range(1,NUM_CLASSES//NCPF):
    new_train_data = only_used(np.load(open(BIN_DIR + 'train/{0}_{1}.npy'.format(i*NCPF,(i+1)*NCPF),'rb')))
    new_val_data = np.load(open(BIN_DIR + 'validation/{0}_{1}.npy'.format(i*NCPF,(i+1)*NCPF),'rb'))
    train_data = np.concatenate((train_data, new_train_data))
    val_data = np.concatenate((val_data, new_val_data))


# In[436]:

#create training labels
train_labels = []
val_labels = []
for c in range(NUM_CLASSES):
    train_labels.extend([[0]*c + [1] + [0]*(NUM_CLASSES-c-1) for l in range(TRAIN_SAMPLES)])
    val_labels.extend([[0]*c + [1] + [0]*(NUM_CLASSES-c-1) for l in range(VAL_SAMPLES)])
train_labels = np.array(train_labels)
val_labels = np.array(val_labels)


# In[437]:

#shuffle samples and labels
train_perm = np.random.permutation(NUM_CLASSES*TRAIN_SAMPLES)
val_perm = np.random.permutation(NUM_CLASSES*VAL_SAMPLES)
train_data, train_labels = train_data[train_perm], train_labels[train_perm]
val_data, val_labels = val_data[val_perm], val_labels[val_perm]


# In[438]:

#create model
inp = Input( train_data.shape[1:] )
out = Dense(NUM_CLASSES, activation='softmax')(inp)
tl_model = Model( input=inp, output=out )
tl_model.compile(optimizer='rmsprop',
              loss='categorical_crossentropy',
              metrics=['accuracy'])


# In[439]:

#train model
tl_model.fit(train_data, train_labels,
          nb_epoch=NUM_EPOCHS, batch_size=BATCH_SIZE,
          validation_data=(val_data, val_labels))


# In[ ]:



