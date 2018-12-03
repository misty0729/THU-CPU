import sys
if len(sys.argv) < 3:
    print("filename: in & out")
    sys.exit(0)

filename = sys.argv[1]
f = open(filename, encoding="utf-8")

line_list_1 = []
idt_list = {}
for line in f:
    if '//' in line:
        line = line[0:line.find('//')] + "\n"
    if not line == '':
        line_list_1.append(line)

line_list_2 = []
for line in line_list_1:
    if not len(line.split()) == 0:
        line_list_2.append(line)

for line in line_list_2:
    print(line)

l_num = 0
for line in line_list_2:
    if ':' in line:
        idt = line[0:line.find(':')]
        print(idt)
        idt_list[idt] = l_num
        line_list_2[l_num] = "NOP\n"
    l_num += 1

print(idt_list)

l_num = 0
for line in line_list_2:
    line_items = line.split()
    for idt in idt_list:
        if idt in line_items:
            offset = idt_list[idt] - l_num - 1
            if offset >= 0:
                line_list_2[l_num] = line.replace(idt, str(hex(offset))[2:])
            else:
                offset += 256
                line_list_2[l_num] = line.replace(idt, str(hex(offset))[2:])
            print(line_list_2[l_num])
    l_num += 1

output = ""
for line in line_list_2:
    output += line
print(output)

out_filename = sys.argv[2]
fout = open(out_filename, 'w')
fout.write(output)
