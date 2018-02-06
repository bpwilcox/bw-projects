#!/bin/bash
./reset.sh

dat_fold=data
dat_name=256_ObjectCategories

if [ ! -d "$dat_fold" ]; then
    if [ -d "../$dat_fold" ]; then
	mv ../$dat_fold ./
    elif [ -d "$dat_name" ]; then
	mv $dat_name $dat_fold
    elif [ -d "../$dat_name" ]; then
	mv ../$dat_name $dat_fold
    else
	if [ ! -e "$dat_name.tar" ]; then
	    wget "http://www.vision.caltech.edu/Image_Datasets/Caltech256/256_ObjectCategories.tar"
	fi
	tar -xvf $dat_name.tar
	mv $dat_name $dat_fold
    fi    
fi

if [ ! -d cal_predictions ]; then
    mkdir cal_predictions
fi

if [ -d "$dat_fold/257.clutter" ]; then
    rm -r $dat_fold/257.clutter
fi
