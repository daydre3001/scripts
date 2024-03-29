import os
import shutil
from os.path import isfile
from posixpath import join


skipDirs = ['Pro Tools', 'Presonus', 'Native Instruments', 'iZotope', 'Universal Audio', 'Arduino', 'Studio One', 'Blue Cat Audio', 'iZotope Stutter Edit Presets', 'Unreal', 'Unity', 'Max 8', 'Adobe', 'Blackmagic Design', 'Eventide', 'Resolume Arena', 'Zoom', 'Rack', 'Autodesk']
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
            try:
                shutil.rmtree(fullPath)
            except OSError as e:
                continue
