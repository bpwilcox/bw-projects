#gif.py 
import sys
import os
import datetime
import imageio

from stat import S_ISREG, ST_CTIME, ST_MODE
import time


rootdir = os.getcwd()
imdir = os.path.join(rootdir, 'Plots')

#dir_path = imdir   
#data = (os.path.join(dir_path, fn) for fn in os.listdir(dir_path))
#data = ((os.stat(path), path) for path in data)    
#data = ((stat[ST_CTIME], path)
#       for stat, path in data if S_ISREG(stat[ST_MODE]))
#for cdate, path in sorted(data):
#    print(os.path.basename(path))



def create_gif(imdir, duration): 
    images = []
    
    dir_path = imdir   
    data = (os.path.join(dir_path, fn) for fn in os.listdir(dir_path))
    data = ((os.stat(path), path) for path in data)    
    data = ((stat[ST_CTIME], path)
           for stat, path in data if S_ISREG(stat[ST_MODE]))
    
    for cdate, path in sorted(data):       
        file = os.path.join(rootdir, 'Figures2',path)
        images.append(imageio.imread(file))
    
#    for filename in os.listdir(imdir):
##        print(filename)
#        path = os.path.join(rootdir, 'Figures',filename)
#        images.append(imageio.imread(os.path.basename(path)))
        
    output_file = 'Gif-%s.gif' % datetime.datetime.now().strftime('%Y-%M-%d-%H-%M-%S')
    imageio.mimsave(output_file, images, duration=duration)
#    return images

images = create_gif(imdir,0.15)

#if __name__ == "__main__":
#    script = sys.argv.pop(0)
#
#    if len(sys.argv) < 2:
#        print('Usage: python {} <duration> <path to images separated by space>'.format(script))
#        sys.exit(1)
#
#    duration = float(sys.argv.pop(0))
#    filenames = sys.argv
#
#
#    if not all(f.lower().endswith(VALID_EXTENSIONS) for f in filenames):
#        print('Only png and jpg files allowed')
#        sys.exit(1)
#
#    create_gif(filenames, duration)
