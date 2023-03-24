import os
import random 
vocab = ["0","1","2","3","4","5","6","7","8","9","A","B","C", "D", "E", "F"]
mode_list = ["E0", "100", "180", "200"]
total = 100
def capper(mystr):
    out=""
    for idx, i in enumerate(mystr):
        if not i.isdigit(): 
            out = out+ mystr[idx].capitalize()
        else:
            out = out + mystr[idx]
    return out
with open("Keccak_in.txt",'w',encoding = 'utf-8') as f:
    f.write(capper(str(hex(total))[2:]+"\n"))
    for index in range(total):
        mode = random.randint(0, 5)
        
        f.write(str(mode)+"\n")
        if (mode == 0 or mode == 3 or mode == 2 or mode == 1):
            num_char = mode_list[mode]
            f.write(num_char+"\n")
        else:
            num_char = capper(str(hex(random.randrange(64, 1024, 64)))[2:])
            f.write(num_char+"\n")
        
        for line_index in range(0,8):
            line = ""
            for row in range(0,16):
                line = line + vocab[random.randint(0, 15)]
            if (line_index<8):
                f.write(line+"\n")