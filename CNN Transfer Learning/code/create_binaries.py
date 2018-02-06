
# coding: utf-8

# In[296]:

import numpy as np
from keras.models import Model
from keras.preprocessing.image import ImageDataGenerator
from keras.applications import vgg16
from PIL import Image


# In[297]:

#constants
BATCH_SIZE = 4
NCPF = 32 #number of classes per file
TRAIN_SAMPLES = 16
VAL_SAMPLES = 4

STARTING_CLASS = 0*NCPF #change to the class we left off from

DATA_DIR = '../data/'
BIN_DIR = '../data/cal_predictions/no_norm/'


# In[ ]:




# In[298]:

#create model
vgg_model = vgg16.VGG16( weights='imagenet', include_top=True ) #downloads prebuilt
for layer in vgg_model.layers:
    layer.trainable = False
vgg_out = vgg_model.layers[-2].output
model = Model( input=vgg_model.input, output=vgg_out )
model.compile( loss="categorical_crossentropy", optimizer="rmsprop", metrics=["accuracy"] )


# In[ ]:




# In[299]:

datagen = ImageDataGenerator(samplewise_center=False, samplewise_std_normalization=False)#standardizes per sample


# In[ ]:




# In[300]:

#create a generator for the training samples starting from the class we left off from
generator = datagen.flow_from_directory(
            DATA_DIR + 'train',
            target_size=(224, 224),
            batch_size=BATCH_SIZE,
            class_mode=None,
            shuffle=False)
for _ in range(STARTING_CLASS*TRAIN_SAMPLES//BATCH_SIZE): #skip up to the starting class
    generator.next() 


# In[301]:

#Image.fromarray(np.uint8(generator.next()[0]))


# In[302]:

features = model.predict_generator(generator, TRAIN_SAMPLES*NCPF) #push through vgg_model


# In[303]:

np.save(open(BIN_DIR + 'train/{0}_{1}.npy'.format(STARTING_CLASS,STARTING_CLASS+NCPF), 'wb'), features) #save features


# In[ ]:




# In[304]:

#create a generator for the validation samples starting from the class we left off from
generator = datagen.flow_from_directory(
            DATA_DIR + 'validation',
            target_size=(224, 224),
            batch_size=BATCH_SIZE,
            class_mode=None,
            shuffle=False)
for _ in range(STARTING_CLASS*VAL_SAMPLES//BATCH_SIZE): #skip up to the starting class
    generator.next()


# In[305]:

features = model.predict_generator(generator, VAL_SAMPLES*NCPF) #push through vgg_model


# In[306]:

np.save(open(BIN_DIR + 'validation/{0}_{1}.npy'.format(STARTING_CLASS,STARTING_CLASS+NCPF), 'wb'), features) #save features


# In[ ]:



