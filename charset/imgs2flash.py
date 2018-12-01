# coding=utf-8
__author__ = 'ZYF'
import os
from PIL import Image
path='./img'
pos = 0x4000
fp = open('charset.data','w')
fps = open('startindex.txt','w')
for file in os.listdir(path):
    img = Image.open(os.path.join(path,file))
    img_array = img.load()
    fps.write(("%s %06X\n" % (os.path.splitext(file)[0], pos)))
    n,m = img.size
    for i in range(0, m):
        for j in range(0, n):
            r, g, b,a = img_array[j, i]
            color = int(b / 32) * 64 + int(g / 32) * 8 + int(r / 32)
            fp.write("%06X=%04X\n" % (pos, color))
            pos = pos + 1