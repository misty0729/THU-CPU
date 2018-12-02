# coding=utf-8
__author__ = 'ZYF'
import os
from PIL import Image
import cv2
import numpy as np
path='./img'
pos = 0x4000
fp = open('flash.data','w')
fps = open('startindex.txt','w')
startAddr = 0x1000
for file in os.listdir(path):
    img = Image.open(os.path.join(path,file))
    img_array = img.load()
    num = os.path.splitext(file)[0]
    fps.write(("%s %06X\n" % (num, pos)))
    n,m = img.size
    pos = startAddr + int(num) * 128
    print('%s %d %06X\n' %(num, pos, pos))
    #im = cv2.imread(os.path.join(path,file))
    #kernel = np.array([[-1, -1, -1], [-1, 9, -1], [-1, -1, -1]])
    #im = cv2.filter2D(im, -1, kernel)

    convertImage = Image.new("RGB", (8, 16))
    for i in range(0, m):
        for j in range(0, n):
            r, g, b,a = img_array[j, i]
            color = int(b / 32) * 64 + int(g / 32) * 8 + int(r / 32)
            convertImage.putpixel((j,i),(int(r/32)*32,int(g/32)*32,int(b/32)*32))
            fp.write("%06X=%04X\n" % (pos, color))
            pos = pos + 1
    convertImage.save("TAT%s.png" % num)


