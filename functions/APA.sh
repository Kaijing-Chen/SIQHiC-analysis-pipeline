#    APA  part
APA_path=`find ./ -name APA.txt| tr -d "\n" | tr -d " "`    #change ./ to $line(the folder in the while, also the folder have inter_30.hic)
The_path_of_code="/media/tempdata1/kaijing/pipeline_test/code"


cp $APA_path max.txt
sed -i 's/\[//g' max.txt
sed -i 's/\]//g' max.txt

sed -i 's/, /\t/g' max.txt
cat ${The_path_of_code}/header.txt max.txt > tmp.txt
paste ${The_path_of_code}/row.txt tmp.txt > apa_plot.txt
rm tmp.txt


sed -i 's/\t/\n/g' max.txt
awk 'BEGIN{max = 0}{if($1 > max) max = $1}END{print max}' max.txt > MAX.txt
Rscript APA.R
rm max.txt
rm MAX.txt
