import sys
if len(sys.argv) < 3:
    print("filename: in & out")
    sys.exit(0)

filename = sys.argv[1]
f = open(filename)

line_list = []
idt_list = {}
for line in f:
    line_list.append(line)

l_num = 0
for line in line_list:
    if ':' in line:
        idt = line[0:line.find(':')]
        print(idt)
        idt_list[idt] = l_num
        line_list[l_num] = "NOP\n"
    l_num += 1

print(idt_list)

l_num = 0
for line in line_list:
    line_items = line.split()
    for idt in idt_list:
        if idt in line_items:
            offset = idt_list[idt] - l_num - 1
            if offset >= 0:
                line_list[l_num] = line.replace(idt, str(hex(offset))[2:])
            else:
                offset += 256
                line_list[l_num] = line.replace(idt, str(hex(offset))[2:])
            print(line_list[l_num])
    l_num += 1

output = ""
for line in line_list:
    output += line
print(output)

out_filename = sys.argv[2]
fout = open(out_filename, 'w')
fout.write(output)
