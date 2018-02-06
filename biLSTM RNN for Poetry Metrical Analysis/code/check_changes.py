import os
problem_files = open('problem_files.txt').read().split("\n")

for filename in os.listdir('data/changed_poems'):
  if filename in problem_files: continue
  f = open('data/changed_poems/' + filename)
  lines = f.readlines()
  english = lines[::2]
  meter = lines[1::2]
  if any(i for i in range(len(english)) if len(english[i]) != len(meter[i])):
    print(filename)
