import pickle
import sys
import time 
import numpy as np

def tic():
  return time.time()
def toc(tstart, nm=""):
  print('%s took: %s sec.\n' % (nm,(time.time() - tstart)))

def read_data(fname):
  d = []
  with open(fname, 'rb') as f:
    if sys.version_info[0] < 3:
      d = pickle.load(f)
    else:
      d = pickle.load(f, encoding='latin1')  # need for python 3
  return d

filenum = 7
dataset=str(filenum)

# Training Set 
cfile = "train1/trainset/cam/cam" + dataset + ".p"
ifile = "train1/trainset/imu/imuRaw" + dataset + ".p"
vfile = "train1/trainset/vicon/viconRot" + dataset + ".p"



ts = tic()
camd = read_data(cfile)
#camd=[]
imud = read_data(ifile)
vicd = read_data(vfile)
toc(ts,"Data import")





