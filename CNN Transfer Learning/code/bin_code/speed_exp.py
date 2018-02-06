import time
import numpy as np
from keras.models import Model, Sequential
from keras.layers import Dense, Flatten, Input,Dropout
from keras.preprocessing.image import load_img, img_to_array
from keras.preprocessing.image import ImageDataGenerator
from keras.applications import vgg16

start = time.time()
BATCH_SIZE = 2
NUM_CLASSES = 4
TRAIN_SAMPLES = 32
VAL_SAMPLES = 8
STARTING_CLASS = 0
BIN_DIR = 'cal_predictions/'
img_size=(224, 224)

model = vgg16.VGG16( weights='imagenet', include_top=True ) #downloads prebuilt

for layer in model.layers:
    layer.trainable = False

vgg_out = model.layers[-2].output
softmax_layer = Dense(256, activation='softmax')(vgg_out)

model.compile( loss="categorical_crossentropy", optimizer="adagrad", metrics=["accuracy"] )


datagen = ImageDataGenerator()

generator = datagen.flow_from_directory(
            'data/train',
            target_size=img_size,
            batch_size=BATCH_SIZE,
            class_mode=None,
            shuffle=False)

len([generator.next() for _ in range(STARTING_CLASS*TRAIN_SAMPLES)])

end = time.time()
print('Getting to trainig took {0} times'.format((end - start)))
start = time.time()
print('Beginning training eval')
bottleneck_features_train = model.predict_generator(generator, TRAIN_SAMPLES*NUM_CLASSES)
end = time.time()
print('fin')
print('{0} classes, {1} samples took {2} times'.format(NUM_CLASSES,
                                                       TRAIN_SAMPLES,
                                                       (end - start)))
with open(BIN_DIR + 'mnstd_features_train_{0}_{1}.npy'
          ''.format(STARTING_CLASS,STARTING_CLASS+NUM_CLASSES),
          'wb') as bin_fil:
    np.save(bin_fil, bottleneck_features_train)

generator = datagen.flow_from_directory(
            'data/validation',
            target_size=img_size,
            batch_size=BATCH_SIZE,
            class_mode=None,
            shuffle=False)

len([generator.next() for _ in range(STARTING_CLASS*VAL_SAMPLES)]) #skip up to the starting class
print('Beginning validation evaluation')
start = time.time()
bottleneck_features_validation = model.predict_generator(generator, VAL_SAMPLES*NUM_CLASSES)
end = time.time()
print('fin')
print('{0} classes, {1} samples took {2} times'.format(NUM_CLASSES,
                                                       VAL_SAMPLES,
                                                       (end - start)))
with open(BIN_DIR + 'mnstd_features_validation_{0}_{1}.npy'
          ''.format(STARTING_CLASS,STARTING_CLASS+NUM_CLASSES),
          'wb') as bin_fil:
    np.save(bin_fil, bottleneck_features_validation)
