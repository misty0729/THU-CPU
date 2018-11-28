# coding=utf-8
__author__ = 'ZYF'
from PIL import Image
import sys
if len(sys.argv) < 3:
    print("参数不够_(:з」∠)_")
    print("第一个参数是源文件文件名")
    print("第二个参数是写入flash的起始地址")
    print("注意我会将你的图片直接resize成640x480的，请自行保证比例>_<")
    sys.exit(0)
print('源文件 is ', sys.argv[1])
print('目标地址起始地址 is ', sys.argv[2])
img = Image.open(sys.argv[1])
img = img.resize((640, 480))
img_array=img.load()
print(img.size)
n, m = img.size
fp = open('demo.txt', 'w')
pos = int(sys.argv[2], 16)
for i in range(0, n):
    for j in range(0, m):
        r, g, b = img_array[i, j]
        color = int(r/32) * 64 + int(g/32) * 8 + int(b/32)
        fp.write("%06X=%04X\n" % (pos, color))
        pos = pos + 1

