#!/bin/bash

hicConvertFormat -m ../inter_30.hic --inputFormat hic --outputFormat cool -o inter_30.cool --resolution $insulation_resolution   #change theposition of inter_30.hic 
hicConvertFormat -m inter_30_${insulation_resolution}.cool --inputFormat cool --outputFormat cool -o inter_30_${insulation_resolution}_KR.cool --correction_name KR  
hicFindTADs -m inter_30_${insulation_resolution}_KR.cool --outPrefix inter_30_${insulation_resolution}_KR --minDepth 30000 --maxDepth 100000 --correctForMultipleTesting fdr --thresholdComparisons 0.05 
