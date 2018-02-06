import pickle
import numpy as np
from matplotlib import pyplot as plt
from matplotlib.patches import Rectangle

pkl_dir = 'results/'
long_fil = pkl_dir + '0_256_16.pkl'
shrt_fil = pkl_dir + '0_64_16.pkl'

with open(long_fil, 'rb') as file:
    all_res = pickle.load(file)
with open(shrt_fil, 'rb') as file:
    sml_res = pickle.load(file)

all_acc = np.array(all_res['results'])
all_tmp = np.array(all_res['temps_to_use'])
sml_acc = np.array(sml_res['results'])
sml_tmp = np.array(sml_res['temps_to_use'])

plt.figure(1)
ep = np.arange(1, all_res['nb_epoch'] + 1)
a_lin = []
p = []
a_tmp = tuple(['{0:.2f}'.format(t) for t in all_tmp])
for k in range(all_acc.shape[0]):
    a_lin = a_lin + plt.plot(ep, all_acc[k, :], label='a')
    color = a_lin[-1].get_c()
    p = p + [Rectangle((0, 0), 1, 1, fc=color)]
plt.legend(p, a_tmp, loc=8)
plt.title("Accuracy over epochs, different temp's")
plt.xlabel('Epoch Number')
plt.ylabel('Validation Set Accuracy')

plt.figure(2)
plt.subplot(2, 1, 1)
plt.plot(all_tmp, np.max(all_acc, axis=1))
plt.title('Max accuracy vs. Temp (256 Classes)')
plt.xlabel('Temp value')
plt.ylabel('Validation Accuracy')
plt.subplot(2, 1, 2)
plt.title('Final Accuracy vs. Temp (256 Classes)')
plt.xlabel('Temp value')
plt.ylabel('Validation Accuracy')
plt
plt.plot(all_tmp, all_acc[:, -1])


plt.figure(3)
ep = np.arange(1, sml_res['nb_epoch'] + 1)
s_lin = []
p = []
s_tmp = tuple(['{0:.2f}'.format(t) for t in sml_tmp])
for k in range(sml_acc.shape[0]):
    s_lin = s_lin + plt.plot(ep, sml_acc[k, :], label='a')
    color = s_lin[-1].get_c()
    p = p + [Rectangle((0, 0), 1, 1, fc=color)]
plt.legend(p, s_tmp, loc=8)
plt.title("Accuracy over epochs, different temp's")
plt.xlabel('Epoch Number')
plt.ylabel('Validation Set Accuracy')

plt.figure(4)
plt.subplot(2, 1, 1)
plt.plot(sml_tmp, np.max(sml_acc, axis=1))
plt.title('Max accuracy vs. Temp (64 Classes)')
plt.xlabel('Temp value')
plt.ylabel('Validation Accuracy')
plt.subplot(2, 1, 2)
plt.title('Final Accuracy vs. Temp (64 Classes)')
plt.xlabel('Temp value')
plt.ylabel('Validation Accuracy')
plt
plt.plot(sml_tmp, sml_acc[:, -1])

plt.show()

# # Plot the results -- Precision vs. recall...
# plt.figure(1)
# plt.plot(recall, precision)
# plt.title('Precision Vs. Recall')
# plt.xlabel('Recall')
# plt.ylabel('Precision')
# plt.axis([0.,1.,0.,1.])

# # ...and Prec/Recall vs. number of predictions used.
# plt.figure(2)
# k = np.arange(1, Ns + 1)
# lines = plt.plot(k, recall, 'b', k, precision, 'r')
# plt.legend(lines, ('Recall', 'Precision'), loc=0)
# plt.xlabel('k (Predictions Considered)')
# plt.ylabel('Prec and Recall')
# plt.axis([0,Ns + 1,0.,1.])
# plt.title('Precision@k and Recall@k ')

# # Display plots
# plt.show()

