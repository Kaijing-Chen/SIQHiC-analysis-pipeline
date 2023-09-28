import numpy as np
import straw as straw
from matplotlib.colors import LinearSegmentedColormap
from matplotlib import pyplot as plt
from matplotlib import gridspec
import matplotlib.pyplot as plt 
import seaborn as sns
 
 
num=1
while num < 23:
    file_name="./raw/chr"+str(num)+"_5kb.txt"
    f = open(file_name, 'w')   #file name will be replaced by the user input
    chromosome="H"+str(num)
    result = straw.straw("observed", 'NONE', 'inter_30.hic', chromosome, chromosome, 'BP', 5000)
    for i in range(len(result)):
        print("{0}\t{1}\t{2}".format(result[i].binX, result[i].binY, result[i].counts),num,file=f)
    f.close()
    
    num+=1;



file_name="./raw/chrX_5kb.txt"
f = open(file_name, 'w')   #file name will be replaced by the user input
chromosome="HX"
result = straw.straw("observed", 'NONE', 'inter_30.hic', chromosome, chromosome, 'BP', 5000)
for i in range(len(result)):
      print("{0}\t{1}\t{2}".format(result[i].binX, result[i].binY, result[i].counts),num,file=f)
f.close()


file_name="./raw/chrY_5kb.txt"
f = open(file_name, 'w')   #file name will be replaced by the user input
chromosome="HY"
result = straw.straw("observed", 'NONE', 'inter_30.hic', chromosome, chromosome, 'BP', 5000)
for i in range(len(result)):
      print("{0}\t{1}\t{2}".format(result[i].binX, result[i].binY, result[i].counts),num,file=f)
f.close()
