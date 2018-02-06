import numpy as np
import pickle

results = np.array([[0.1846, 0.2764, 0.3311,0.3555,0.3848, 0.3916, 0.4053, 0.4092], \
                    [0.1250, 0.2461, 0.2822, 0.3291,0.3818, 0.3936, 0.4072, 0.4043], \
                    [0.0430, 0.0605, 0.1221, 0.1592, 0.1631, 0.1738, 0.1875, 0.2236], \
                    [0.0088, 0.0156, 0.0166, 0.0205, 0.0215, 0.0576, 0.0508, 0.0469], \
                    [0.0039, 0.0068, 0.0039, 0.0088, 0.0039, 0.0098, 0.0078, 0.0039]])

#print(results)

#filename = 'bw_temp_results';
#np.save(filename,results)

#x = np.load('/' + filename+'.npy')
#print(x)

with open('results/0_64_16.pkl', 'rb') as file:
    dat = pickle.load(file)

#dat = pickle.load('results/0_64_16.pkl')
print(dat)