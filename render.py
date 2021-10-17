#!/usr/bin/env python3

# loop through src/* folders
  # find render.py files
  # run `render.py <foldername>`
from genericpath import isdir
from os import listdir
import subprocess
# get project-directories
path_list = [ path for path in listdir(path='src') if isdir('src/' + path)]

# check if 'render.sh' script is present in folder
for f in path_list:
    path= 'src/'+ f
    if 'render.sh' in listdir(path=path):
        print("rendering " + path )
        subprocess.run(['bash', 'render.sh'], cwd=path)
