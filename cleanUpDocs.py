import os
from os.path import isfile
from posixpath import join

skipDirs = ['Pro Tools', 'Presonus']
path = "/Users/student/Documents/"

x = os.listdir(path)

for f in x:
    fullPath = join(path,f)
    if isfile(fullPath):
        os.remove(fullPath)
    else:
        if f in skipDirs:
            continue
        else:
            os.rmdir(fullPath)
