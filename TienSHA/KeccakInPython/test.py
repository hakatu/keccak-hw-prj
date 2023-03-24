from email import message
import Keccak
test_len = 512
num_test = 100
myKeccak = Keccak.Keccak()
file = open("Keccak_in.txt", 'r')
Lines = file.readlines()
Lines.pop(0)
with open("Keccak_out_check.txt",'w',encoding = 'utf-8') as f:
    f.write("SHA3 value: \n")
for index in range(0,num_test):
    mode = Lines[index*10].strip()
    len_out = int(Lines[index*10 + 1].strip(),16)
    char=""
    for sub in range(0,8):
        char = char + Lines[index*10 + 1 + 1 +sub].strip()
    int_mode = int(mode)
    if (int_mode==0):
        print ("The ", index + 1, " hash value is: ")
        myKeccak.Keccak((test_len,char),1152,448,0x06,224,False) 
    elif (int_mode == 1):
        print ("The ",  index + 1, " hash value is: ")
        myKeccak.Keccak((test_len,char),1088,512,0x06,256,False) 
    elif (int_mode == 2):
        print ("The ",  index + 1, " hash value is: ")
        myKeccak.Keccak((test_len,char),832,768,0x06,384,False)
    elif (int_mode == 3):
        print ("The ",  index + 1, " hash value is: ")
        myKeccak.Keccak((test_len,char),576,1024,0x06,512,False)
    elif (int_mode == 4):
        print ("The ",  index + 1, " hash value is: ")
        myKeccak.Keccak((test_len,char),1344,256,0x1F,int(len_out),False)
    elif (int_mode == 5):
        print ("The ",  index + 1, " hash value is: ")
        myKeccak.Keccak((test_len,char),1088,512,0x1F,int(len_out),False)

### Compare 2 files
file1 = open("Keccak_out.txt", "r")
file2 = open("Keccak_out_check.txt", "r")
l1 = file1.readlines()
l2 = file2.readlines()
i = 0
is_the_same = True 
for index in range(0,len(l1)):
    if (l1[index].strip().upper() == l2[index].strip().upper()) and (i > 0):
        print("Line ",i,"\t: same")
    elif (l1[index].strip() != l2[index].strip()) and (i > 0):
        is_the_same = False
        print("Line ",i,"\t: diff")
    i += 1
file1.close()
file2.close()
if (is_the_same):
    print("No diff")
else:
    print("Diff")    



#SHA3-224
#myKeccak.Keccak((128,'00000000000000000000000000000000'),224,1152,448,0x06,224,True) 
#SHA3-256
#myKeccak.Keccak((128,'00000000000000000000000000000000'),256,1088,512,0x06,256,True) 
#SHA3-384
#myKeccak.Keccak((128,'00000000000000000000000000000000'),384,832,768,0x06,384,True)
#SHA3-512
#myKeccak.Keccak((128,'00000000000000000000000000000000'),512,576,1024,0x06,512,True)
#myKeccak.Keccak((512,'00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'),512,576,1024,0x06,512,True)

#myKeccak.Keccak((1024,'0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'),512,576,1024,0x06,512,True)

#SHAKE-128
#myKeccak.Keccak((128,'00112233445566778899AABBCCDDEEFF'),512,1344,256,0x1F,400,True)
#SHAKE-256
#myKeccak.Keccak((128,'00112233445566778899AABBCCDDEEFF'),512,1088,512,0x1F,400,True)

