So I wrote some scripts that will run the model we're using on the images we have available.  The idea is that ~30000 images is way too much for anybody to run on their own computer, so we can each run about a fifth of them, which will not take so much compute time.  At any rate, to contribute your computation, please do the following:

(1)  If you HAVE DOWNLOADED the CalTech data already, please put it in a folder called "data" or "256_ObjectCategories" in the "bin_code" folder.  In particular, if you do
     $ ls data (or $ ls 256_ObjectCategories)
     You should see "001.ak47 002.american-flag ..." etc.
     *** The data folder should ONLY HAVE those directories and their contents inside.
     *** Also, there's no need to copy all the data into the 'code' directory -- instead, you can make a shortcut in 'code' that points to the data folders elsewhere.  Either way is fine, since I've added 'code/data' to the .gitignore, so it's your choice.  Either way, make sure 'code' has a folder called 'data' pointing to those folders.

(2) If you HAVE NOT DOWNLOADED the data yet, don't worry about it!  The first script will get you set up.

(3)  After situating (or not) your data, please run
     $ ./onboard_allbin.sh
     This will just check that your data is in the place that the next scripts expect.

(3')  For safety's sake, please check that you have a folder named 'data' and a folder named 'cal_predictions' in the 'code' directory.

(4)  After that, please edit line 8 in 'gen_bins.py' to say:

     "partner_id = 0" ---> "partner_id = <my_id>"

     where <my_id> is:
     Preskitt: 0
     Tran: 1
     Wilcox: 2
     Ustaris: 3
     Clara: 4

(5)  After that, please run (in python3)
     >>> import gen_bins

(6)  Cross your fingers and hope it runs through!  It should take 1.5-2 hours (at least that's what I expect on my machine).

(6)  After all that, please run
     $ ./bin_moves.sh
