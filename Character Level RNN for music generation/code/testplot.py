import matplotlib.pyplot as plt
import numpy as np

filename = 'bw_50hid_results'
#np.save(filename,res)

x = np.load(filename+'.npy')
print(x)
