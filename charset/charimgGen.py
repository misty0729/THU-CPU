# coding=utf-8
__author__ = 'ZYF'
from PIL import Image
import string
img = Image.open('TATAQQQ.png')
sx = 60
sy = 110  #每个字符图片的大小
charSet = [[x for x in string.ascii_lowercase],  #第一行
            [x for x in string.ascii_uppercase],  #第二行
            [str(x) for x in range(0,10)], #第三行
            ['!', '"', '#', '$', '%', '&', '\'', '(', ')', '*', '+', ',', '-', '.', '/', ':', ';'],
            ['<', '=', '>', '?', '@', '[', '\\', ']', '^','_', '{', '|', '}', '~', ' ']] #第五行
lx, ly = 0, 0
ind = 0
for charArray in charSet:
    ind += 1
    print(ind)
    lx = 2
    for char in charArray:
        newimg = img.crop((lx , ly , lx + sx , ly + sy )).resize((8,16),Image.ANTIALIAS)
        newimg.save("./img/%d.png" % ord(char))

        print(char,ord(char))
        print(char)
        lx += sx
    ly += sy
    if ind == 4:
        ly += 6
print(charArray)