#!/bin/bash

if [ -d 'data' ]; then
    mv data ..
else
    echo "You need to make the data folder first!"
    echo "(Or check that it is in 'code')"
fi
if [ -d 'cal_predictions' ]; then
    if [ -d '../cal_predictions' ]; then
	if [ ! -z "$(ls -A cal_predictions)" ]; then
	    mv cal_predictions/* ../cal_predictions
	    rm -r cal_predictions
	else
	    rm -r cal_predictions
	fi
    else
	mv cal_predictions ..
    fi
else
    echo "You need to populate the cal_predictions folder first!"
    echo "(Or check that it is in 'code')"
fi
