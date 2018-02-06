from __future__ import division


import os
import numpy as np


print "Determining Distance to Barrels..."
rootdir = os.getcwd()



w = np.load(os.path.join('Train','w.npy'))

X_Val = np.load(os.path.join(rootdir, 'Validation','X.npy'))
X_Val = np.reciprocal(X_Val)
Y_Val = np.dot(X_Val,w)
#np.save(os.path.join(rootdir, 'Validation','Y'),Y_Val)

X_Test = np.load(os.path.join(rootdir, 'Test','X.npy'))
X_Test = np.reciprocal(X_Test)
Y_Test = np.dot(X_Test,w)
#np.save(os.path.join(rootdir, 'Test','Y'),Y_Test)

print "Distances Found\n"