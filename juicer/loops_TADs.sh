line=/media/tempdata1/kaijing/pipeline_test/function
hic_file_path=${line}/inter_30.hic
The_path_of_code=`grep "The_path_of_code" ./configure_analysis.txt | awk -F "=" '{print $2}'| tr -d "\n" | tr -d " "` 
TAD_resolution="NA"
normalization="KR"


loops=${hic_file_path%.*}"_loops"/merged_loops.bedpe
if [ -z $loops ]
then
	${The_path_of_code}/human_scripts/common/juicer_tools hiccups -k $normalization --ignore-sparsity ${hic_file_path} ${hic_file_path%.*}"_loops"
else
	echo -e "loops exist\n"
fi

if [ "`ls -A ${hic_file_path%.*}"_contact_domains"`" = "" ]
then
	if [ $TAD_resolution = "NA" ]
	then
		${The_path_of_code}/human_scripts/common/juicer_tools arrowhead -k $normalization --ignore-sparsity ${hic_file_path} ${hic_file_path%.*}"_contact_domains"
	else
		${The_path_of_code}/human_scripts/common/juicer_tools arrowhead -k $normalization --ignore-sparsity -r $TAD_resolution ${hic_file_path} ${hic_file_path%.*}"_contact_domains"
	fi
else
	echo -e "TADs exist\n"
fi
