#!/bin/python
import numpy as np
import straw as straw
from matplotlib.colors import LinearSegmentedColormap
from matplotlib import pyplot as plt
from matplotlib import gridspec
import matplotlib.pyplot as plt 
import seaborn as sns

num=1
resolution=5000
location=open("location.txt",'r')
for line in location:
    file_name="./"+str(num)+"_"+str(resolution)+".bed"
    chromosome=str(line.split(":")[0])    
    f = open(file_name, 'w')  
    result = straw.straw("observed", 'KR', '../inter_30.hic', chromosome, chromosome, 'BP', resolution)   # KR or NONE is not sure now
    for m in range(len(result)):
        print("chr"+str(chromosome)+"\t{0}\t{1}\t{2}".format(result[m].binX, result[m].binY, result[m].counts),file=f)
    f.close()    
    del result
    num+=1
location.close()
