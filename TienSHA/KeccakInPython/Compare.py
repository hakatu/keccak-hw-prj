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