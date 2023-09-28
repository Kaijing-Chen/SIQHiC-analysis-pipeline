#/usr/bin/perl


$file_path=`ls ./splits/*.fastq.gz.sam| tr -d "\n"`;
open(F,"$file_path") or die ("can not open $file_path\n");
system("echo '' >> $file_path");

open file1,">human.sam";
open file2,">mouse.sam";
open file3,">filter.sam";


$inname=`head -n 500 $file_path | grep -v \"\@\" | head -n 1|  awk \'{print \$1}\'`;

$num=0;  
while($line1=<F>){
	@info1=split/\s+/,$line1;
	if($info1[0]!~/@/){
		   @first1=split/\//,$info1[0];
		   $name=$first1[0];
#	print "name:$inname\t$name\n";	   
		   if($inname eq $name){
		      $num+=1;
		      $store{$name}.=$line1;
		      $chr{$name}.=$info1[2];
		   }
		   else{
			
			$result=$store{$inname};
  			$value=$chr{$inname};
#print "result:$result\nvalue:$value\n";		
			$inname=$name;
       		 %store="";
			 $store{$name}.=$line1;
			 $chr{$name}.=$info1[2];
			  @info2=split/\s+/,$value;
			  $content=$value;
		      $content1=$value;
			  $l1=length($content);
			  $content=~s/chrm//g;
			  $l2=length($content);
			  $content1=~s/chrh//g;
			  $l3=length($content1);
			  $a=$l1-$l3;
              $b=$l1-$l2;
#print "aaaaabbbb:$a\t$b\n";
#print "numnummmmmmmmmmm:::$num\n";
			  if($a == 4*$num){
			    print file1 "$result";
			  }
			  if($b == 4*$num){
			    print file2 "$result";
			  }
			  if($a != 4*$num && $b != 4*$num){
			    
			    print file3 "$result";
			  }
			  
			$num=1;  
		   }
    }
}


system("sed -i '\$d' $file_path")

