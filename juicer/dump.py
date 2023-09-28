#!/bin/python
import numpy as np
import hicstraw as straw   #import straw as straw
from matplotlib.colors import LinearSegmentedColormap
from matplotlib import pyplot as plt
from matplotlib import gridspec
import matplotlib.pyplot as plt 
import seaborn as sns



numbers = list(range(1, 23))
numbers.append("X")
numbers.append("Y")

i,j,n=0,0,0
while i < 23:
 for j in numbers[n:]:
    file_name="./raw_30/"+str(numbers[i])+"_"+str(j)+"_5kb.txt"
    f = open(file_name, 'w')   #file name will be replaced by the user input
    chromosome1=str(numbers[i])
    chromosome2=str(j)
    result = straw.straw("observed", 'NONE', 'inter_30_raw.hic', chromosome1, chromosome2, 'BP', 5000)
    for m in range(len(result)):
        print("{0}\t{1}\t{2}".format(result[m].binX, result[m].binY, result[m].counts),numbers[i],j,file=f)
    f.close()
    del result   
    
 n+=1;
 i+=1;



i,j,n=0,0,0
while i < 23:
 for j in numbers[n:]:
    file_name="./raw_0/"+str(numbers[i])+"_"+str(j)+"_5kb.txt"
    f = open(file_name, 'w')   #file name will be replaced by the user input
    chromosome1=str(numbers[i])
    chromosome2=str(j)
    result = straw.straw("observed", 'NONE', 'inter_0_raw.hic', chromosome1, chromosome2, 'BP', 5000)
    for m in range(len(result)):
        print("{0}\t{1}\t{2}".format(result[m].binX, result[m].binY, result[m].counts),numbers[i],j,file=f)
    f.close()
    del result

 n+=1;
 i+=1;
