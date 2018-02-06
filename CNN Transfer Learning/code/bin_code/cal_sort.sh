#!/bin/bash
dat_root=./data
trn_targ=$dat_root/train/
val_targ=$dat_root/validation/
bin_targ=$dat_root/cal_predictions/
NUM_TRN=32
NUM_VAL=8

if [ ! -d "$bin_targ" ]; then
    mkdir $bin_targ
fi
if [ ! -d "$trn_targ" ]; then
    mkdir $trn_targ
fi
if [ ! -d "$val_targ" ]; then
    mkdir $val_targ
fi

for f in $dat_root/*
do
    d=${f##*/}
    if [ ! "$d" == "train" ] && [ ! "$d" == "validation" ]; then
    	if [ ! -d "$trn_targ$d" ]; then
    	    mkdir $trn_targ$d
    	fi
    	if [ ! -d "$val_targ$d" ]; then
    	    mkdir $val_targ/$d
    	fi
    	echo "On class $f"
	for p in $f/*
	do
	    x=${p##*/}
	    a="${p##*\_}"
	    b=${a%%.*}
	    b=$[10#$b]
	    t=$(readlink -f $p)
	    if [ $b -le $NUM_TRN ]; then
	    	if [ ! -e "$trn_targ$d/$x" ]; then
	    	    ln -s $t $trn_targ$d/$x
	    	fi
	    elif [ $b -le $[NUM_TRN + NUM_VAL] ]; then
	    	if [ ! -e "$val_targ$d/$x" ]; then
	    	    ln -s $t $val_targ$d/$x
	    	fi
	    fi
	done
    fi
done

if [ -e data/train/257.clutter ]
then rm -r data/train/257.clutter
     rm -r data/validation/257.clutter
fi
