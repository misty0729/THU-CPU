# coding=utf-8
__author__ = 'ZYF'
from PIL import Image
import sys
if len(sys.argv) < 3:
    print("参数不够_(:з」∠)_")
    print("第一个参数是源文件文件名")
    print("第二个参数是写入flash的起始地址")
    print("第三、四个参数可选，是目标图片的大小，默认为640x480")
    sys.exit(0)
print('源文件 is ', sys.argv[1])
print('目标地址起始地址 is ', sys.argv[2])
tn = 640
tm = 480
if len(sys.argv) >= 5:
    tn = int(sys.argv[3])
    tm = int(sys.argv[4])
    print('目标文件的大小为 %d %d' % (tn, tm))
img = Image.open(sys.argv[1])
img = img.resize((tn, tm))
img_array=img.load()
print(img.size)
n, m = img.size
fp = open('ram2.data', 'w')
pos = int(sys.argv[2], 16)
for i in range(0, n):
    for j in range(0, m):
        r, g, b = img_array[i, j]
        color = int(b/32) * 64 + int(g/32) * 8 + int(r/32)
        fp.write("%06X=%04X\n" % (pos, color))
        pos = pos + 1

