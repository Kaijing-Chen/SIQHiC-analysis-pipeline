#!/bin/bash
############# get information from configure_juicer.txt  #########
output_folder=`grep "output_folder" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
output_name=`grep "output_name" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
fastq_path=`grep "fastq_path" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
fastq_num=`grep "fastq_num" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
if [ "$fastq_num" -gt 1 ]
then
        mkdir fastq
        cat $fastq_path/*_R1.fastq.gz > ./fastq/${output_name}_R1.fastq.gz
        cat $fastq_path/*_R2.fastq.gz > ./fastq/${output_name}_R2.fastq.gz
        fastq_path=$output_folder/fastq
fi


thread=`grep "thread" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
bwa_path=`grep "bwa_path" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
if [ -z "$bwa_path" ]
then
        bwa_path=bwa
fi


The_path_of_code=`grep "The_path_of_code" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
The_path_of_juicer_tools=`grep "The_path_of_juicer_tools" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
if [ -z "$The_path_of_code/human_scripts/common/juicer_tools.jar" ]
then
        ln -s $The_path_of_juicer_tools $The_path_of_code/human_scripts/common/juicer_tools.jar
else
    echo "Already have juicer_tools.jar under human_scripts, please check it!"
fi
if [ -z "$The_path_of_code/mouse_scripts/common/juicer_tools.jar" ]
then
        ln -s $The_path_of_juicer_tools $The_path_of_code/mouse_scripts/common/juicer_tools.jar
else
    echo "Already have juicer_tools.jar under mouse_scripts, please check it!"
fi
#ln -s $The_path_of_juicer_tools $The_path_of_code/human_scripts/common/juicer_tools.jar
#ln -s $The_path_of_juicer_tools $The_path_of_code/mouse_scripts/common/juicer_tools.jar

restriction_enzyme=`grep "restriction_enzyme" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
ligation=`grep "ligation" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
if [ -z "$ligation" ]
then
    case $restriction_enzyme in
        HindIII) ligation="AAGCTAGCTT";;
        DpnII) ligation="GATCGATC";;
        MboI) ligation="GATCGATC";;
        NcoI) ligation="CCATGCATGG";;
        Arima) ligation="'GAATAATC|GAATACTC|GAATAGTC|GAATATTC|GAATGATC|GACTAATC|GACTACTC|GACTAGTC|GACTATTC|GACTGATC|GAGTAATC|GAGTACTC|GAGTAGTC|GAGTATTC|GAGTGATC|GATCAATC|GATCACTC|GATCAGTC|GATCATTC|GATCGATC|GATTAATC|GATTACTC|GATTAGTC|GATTATTC|GATTGATC'" ;;
        none) ligation="XXXX";;
        *)  ligation="XXXX"
            echo "$site not listed as recognized enzyme. Using $site_file as site file"
            echo "Ligation junction is undefined"
    esac
fi


restriction_file_of_human=`grep "restriction_file_of_human" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
restriction_file_of_mouse=`grep "restriction_file_of_mouse" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`

genome_file_of_human=`grep "genome_file_of_human" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
genome_file_of_mouse=`grep "genome_file_of_mouse" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`

reference_file_of_mix=`grep "reference_file_of_mix" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`

###################################  mix  ##########################

reference_file_of_human=`grep "reference_file_of_human" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`
reference_file_of_mouse=`grep "reference_file_of_mouse" configure_juicer.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "`

if [ "$fastq_num" -eq 1 ]
then
        mkdir fastq
        ln -s $fastq_path/*R1* $output_folder/fastq/${output_name}_R1.fastq.gz
        ln -s $fastq_path/*R2* $output_folder/fastq/${output_name}_R2.fastq.gz
fi

mkdir splits
cp $The_path_of_code/countligations.sh ./
source countligations.sh

echo "start the bwa....."
$bwa_path mem -SP5M -t $thread $reference_file_of_mix $output_folder/fastq/${output_name}_R1.fastq.gz $output_folder/fastq/${output_name}_R2.fastq.gz > $output_folder/splits/${output_name}.fastq.gz.sam    #change the name of sam
echo "$bwa_path mem -SP5M -t $thread $reference_file_of_mix $output_folder/fastq/${output_name}_R1.fastq.gz $output_folder/fastq/${output_name}_R2.fastq.gz > $output_folder/splits/${output_name}.fastq.gz.sam"
cp $The_path_of_code/split.pl ./
perl split.pl

sed -i 's/chrh/chr/g' human.sam
sed -i 's/chrm/chr/g' mouse.sam

samtools view -@ $thread -T $reference_file_of_human -h human.sam > human_header.sam 2>line.log      
samtools flagstat -@ $thread human_header.sam > human_flagstat.txt
sed -n '7p' human_flagstat.txt | awk '{print $1*4}' > human_line.txt
awk '{print $1}' mouse.sam | sort | uniq | wc -l | awk '{print $1*4}'> mouse_line.txt
rm human_header.sam

echo "mix genome alignment finish!"
####################  human   #########################
echo "HUMAN: start human part."

mkdir human
cp -r $The_path_of_code/human_scripts/ ./human/scripts/
cd ./human/
./scripts/juicer.sh -D $output_folder/human -y $restriction_file_of_human -s $restriction_enzyme -p $genome_file_of_human -z $reference_file_of_human -t $thread 2> juicer.log
cd $output_folder
#rm human.sam    # not add this first.

echo "HUMAN: human part done."

########################   mouse  ####################
echo "MOUSE: start mouse part."

mkdir mouse
cp -r $The_path_of_code/mouse_scripts/ ./mouse/scripts/
cd ./mouse/
./scripts/juicer.sh -D $output_folder/mouse -y $restriction_file_of_mouse -s $restriction_enzyme -p $genome_file_of_mouse -z $reference_file_of_mouse -t $thread 2> juicer.log
cd $output_folder
#rm mouse.sam     # not add this first.

echo "MOUSE: mouse part done."
