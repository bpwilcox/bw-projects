#!/bin/bash          
if [ ! -e '256_ObjectCategories.tar' ]; then
   if [ ! -d 'data' ]; then
       wget 'http://www.vision.caltech.edu/Image_Datasets/Caltech256/256_ObjectCategories.tar'
       tar -xvf 256_ObjectCategories.tar
       mv 256_ObjectCategories data
   fi
fi

./cal_sort.sh
