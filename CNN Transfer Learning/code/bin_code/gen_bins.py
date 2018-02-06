import numpy as np
from keras.models import Model, Sequential
from keras.layers import Dense, Flatten, Input,Dropout
from keras.preprocessing.image import load_img, img_to_array
from keras.preprocessing.image import ImageDataGenerator
from keras.applications import vgg16

partner_id = 1
num_images = 29780
num_partners = 5
indices = np.round(num_images / num_partners * np.arange(0, num_partners + 1))
indices = np.array([int(k) for k in indices])
BATCH_SIZE = 2
START_IMG = indices[partner_id] + 1
IM_COUNT = indices[partner_id + 1] - indices[partner_id]
BIN_DIR = 'cal_predictions/'
img_size=(224, 224)

model = vgg16.VGG16( weights='imagenet', include_top=True ) #downloads prebuilt

for layer in model.layers:
    layer.trainable = False

model.compile( loss="categorical_crossentropy", optimizer="adagrad", metrics=["accuracy"] )
datagen = ImageDataGenerator(rescale=1./255)

generator = datagen.flow_from_directory(
            'data',
            target_size=img_size,
            batch_size=BATCH_SIZE,
            class_mode=None,
            shuffle=False)

for _ in range(START_IMG - 1):
    generator.next()

print('Beginning eval')
features = model.predict_generator(generator, IM_COUNT)
print('fin')
with open(BIN_DIR + 'features_{0}_{1}.npy'
          ''.format(START_IMG, START_IMG+IM_COUNT-1), 'wb') as bin_fil:
    np.save(bin_fil, features)
