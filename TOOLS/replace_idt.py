import sys
if len(sys.argv) < 3:
    print("filename: in & out")
    sys.exit(0)

filename = sys.argv[1]
f = open(filename, encoding="utf-8")

line_list_1 = []
idt_list = {}
for line in f:
    print(line)
    if '//' in line:
        line = line[0:line.find('//')] + "\n"
    if not line == '':
        line_list_1.append(line)

line_list_2 = []
for line in line_list_1:
    if not len(line.split()) == 0:
        line_list_2.append(line)

line_list_3 = []
for line in line_list_2:
    if ':' in line:
        idt = line[0:line.find(':') + 1]
        next_line = line[line.find(':') + 1:]
        line_list_3.append(idt)
        line_list_3.append(next_line)
    else:
        line_list_3.append(line)

line_list_4 = []
for line in line_list_3:
    if not len(line.split()) == 0:
        line_list_4.append(line)

l_num = 0
for line in line_list_4:
    if ':' in line:
        idt = line[0:line.find(':')]
        idt_list[idt] = l_num
        line_list_4[l_num] = "NOP\n"
    l_num += 1

print(idt_list)

l_num = 0
for line in line_list_4:
    line_items = line.split()
    for idt in idt_list:
        if idt in line_items:
            offset = idt_list[idt] - l_num - 1
            if offset >= 0:
                line_list_4[l_num] = line.replace(idt, str(hex(offset))[2:])
            else:
                offset += 256
                if line_items[0] == "B":
                    line_list_4[l_num] = line.replace(idt, "7" + str(hex(offset))[2:])
                else:
                    line_list_4[l_num] = line.replace(idt, str(hex(offset))[2:])
            print(line_list_4[l_num])
    l_num += 1

output = ""
for line in line_list_4:
    output += line
print(output)

out_filename = sys.argv[2]
fout = open(out_filename, 'w')
fout.write(output)
