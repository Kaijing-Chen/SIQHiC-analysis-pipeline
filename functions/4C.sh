#!/bin/bash
#------------------------using straw to get the chromsome infromation that we need to see virtual 4C----------------------
if [ -z $view_point ]
then 
	echo -e "Don't run virtual 4C part\n"
else
	echo $view_point > location.txt
	sed -i 's/,/\n/g' location.txt
	python 4C.py	


#-----------------------only extract the region have view point----------------------------------------------
	mkdir view_point
	i=0
	while read line
	do
		i=$(( $i + 1 ))
		file=${i}"_5000.bed"
		position=${line#*:}
		echo "track type=bedGraph name="$line" description="$line" visibility=full" > ./view_point/${file%.*}".bedGraph"
		awk '{if($2=="'$position'" || $3=="'$position'") print $0}'  ./$file >> ./view_point/${file%.*}".bedGraph"
	done < location.txt	
fi

rm location.txt
