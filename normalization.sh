#!/bin/bash
############# get information from configure_juicer.txt  #########
The_output_path_of_A_sample=`grep "The_output_path_of_A_sample" configure_analysis.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
The_output_path_of_B_sample=`grep "The_output_path_of_B_sample" configure_analysis.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
The_path_of_code=`grep "The_path_of_code" configure_analysis.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`    #this one can be deleted when merge part1 and part2
The_path_of_analysis_output=`grep "The_path_of_analysis_output" configure_analysis.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
genome_version=`grep "genome_version" configure_analysis.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`

##############################             normalization & statistics             ##########################################################
echo -ne "$The_output_path_of_A_sample\t$The_output_path_of_B_sample\t$The_path_of_analysis_output\n" | perl $The_path_of_code/statistic.pl -
SIQHIC_ratio=`grep "ratio" $The_path_of_analysis_output/statistic.txt | awk -F "is" '{print $2}'| tr -d "\n" | tr -d " "`
normalized_sample=`grep "normalized" $The_path_of_analysis_output/statistic.txt | awk -F "Sample" '{print $2}'| tr -d "\n" | tr -d " "`

if [ $normalized_sample == "A" ]
then
	mkdir $The_path_of_analysis_output/normalization_A
	cd ./normalization_A
        cp $The_path_of_code/dump.py ./
        cp $The_output_path_of_A_sample/human/aligned/inter_30.hic ./inter_30_raw.hic
        cp $The_output_path_of_A_sample/human/aligned/inter.hic ./inter_0_raw.hic
	mkdir raw_0
	mkdir raw_30
	python dump.py
        cat ./raw_0/*.txt > ./raw_0/all.txt
	cat ./raw_30/*.txt > ./raw_30/all.txt
        mkdir SIQHICnorm
	awk '{print "0\tchr"$4"\t"$1"\t0\t0\tchr"$5"\t"$2"\t1\t"$3/"'$SIQHIC_ratio'"}' ./raw_0/all.txt > ./SIQHICnorm/SIQHICnorm_pre_0.txt    #everytime change HMRi
	awk '{print "0\tchr"$4"\t"$1"\t0\t0\tchr"$5"\t"$2"\t1\t"$3/"'$SIQHIC_ratio'"}' ./raw_30/all.txt > ./SIQHICnorm/SIQHICnorm_pre_30.txt
        $The_path_of_code/human_scripts/common/juicer_tools pre ./SIQHICnorm/SIQHICnorm_pre_0.txt inter.hic $genome_version
	$The_path_of_code/human_scripts/common/juicer_tools pre ./SIQHICnorm/SIQHICnorm_pre_30.txt inter_30.hic $genome_version

else
        mkdir $The_path_of_analysis_output/normalization_B
        cd ./normalization_B
        cp $The_path_of_code/dump.py ./
        cp $The_output_path_of_B_sample/human/aligned/inter_30.hic ./inter_30_raw.hic
        cp $The_output_path_of_B_sample/human/aligned/inter.hic ./inter_0_raw.hic
        mkdir raw_0
        mkdir raw_30
        python dump.py
        cat ./raw_0/*.txt > ./raw_0/all.txt
        cat ./raw_30/*.txt > ./raw_30/all.txt
        mkdir SIQHICnorm
        awk '{print "0\tchr"$4"\t"$1"\t0\t0\tchr"$5"\t"$2"\t1\t"$3/"'$SIQHIC_ratio'"}' ./raw_0/all.txt > ./SIQHICnorm/SIQHICnorm_pre_0.txt    #everytime change HMR
        awk '{print "0\tchr"$4"\t"$1"\t0\t0\tchr"$5"\t"$2"\t1\t"$3/"'$SIQHIC_ratio'"}' ./raw_30/all.txt > ./SIQHICnorm/SIQHICnorm_pre_30.txt
        $The_path_of_code/human_scripts/common/juicer_tools pre ./SIQHICnorm/SIQHICnorm_pre_0.txt inter.hic $genome_version
        $The_path_of_code/human_scripts/common/juicer_tools pre ./SIQHICnorm/SIQHICnorm_pre_30.txt inter_30.hic $genome_version
fi
