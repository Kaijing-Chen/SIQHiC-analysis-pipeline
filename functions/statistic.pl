#!/bin/perl

$line=<STDIN>;
@path=split/\t/,$line;
$The_output_path_of_A_sample=$path[0];
$The_output_path_of_B_sample=$path[1];
$The_path_of_analysis_output=$path[2];
chomp $The_path_of_analysis_output;
chomp $The_output_path_of_A_sample;
chomp $The_output_path_of_B_sample;

open file,">$The_path_of_analysis_output/statistic.txt";
print file "Sample\ttotal_reads\thuamn_contact\tmouse_contact\tHMR\n";


$human_contact_A=`grep "Hi-C Contacts:" $The_output_path_of_A_sample/human/aligned/inter_30.txt | awk '{print \$3}' | tr -d \",\"`;
$mouse_contact_A=`grep "Hi-C Contacts:" $The_output_path_of_A_sample/mouse/aligned/inter_30.txt | awk '{print \$3}' | tr -d \",\"`;
$total_reads_A=`cat $The_output_path_of_A_sample/splits/*_linecount.txt | awk '{print \$1/4\"\t\"}' |  tr -d \"\n\"`;
chomp $human_contact_A;
chomp $mouse_contact_A;
chomp $total_reads_A;
$HMR_A=$human_contact_A/$mouse_contact_A;
print file "A\t$human_contact_A\t$mouse_contact_A\t$HMR_A\n";

$human_contact_B=`grep "Hi-C Contacts:" $The_output_path_of_B_sample/human/aligned/inter_30.txt | awk '{print \$3}' | tr -d \",\"`;
$mouse_contact_B=`grep "Hi-C Contacts:" $The_output_path_of_B_sample/mouse/aligned/inter_30.txt | awk '{print \$3}' | tr -d \",\"`;
$total_reads_B=`cat $The_output_path_of_B_sample/splits/*_linecount.txt | awk '{print \$1/4\"\t\"}' |  tr -d \"\n\"`;
chomp $human_contact_B;
chomp $mouse_contact_B;
chomp $total_reads_B;
$HMR_B=$human_contact_B/$mouse_contact_B;
print file "B\t$human_contact_B\t$mouse_contact_B\t$HMR_B\n";



if( $HMR_A > $HMR_B ){
	$SIQHIC_ratio=$HMR_A/$HMR_B;
	print file "normalized Sample B\nSIQHIC ratio is $SIQHIC_ratio\n";
}
else{
	$SIQHIC_ratio=$HMR_B/$HMR_A;
	print file "normalized Sample A\nSIQHIC ratio is $SIQHIC_ratio\n";
}
