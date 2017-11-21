#!/usr/bin/perl  
use strict;
use 5.010;

#运行方法：script_name.pl input_file.fa 
#input_file表示含有多条序列的Fasta文件路径
  
my $file = shift @ARGV;      #取得输入文件和输出文件夹  
open FILE, $file || die "Cannot open $file:$!";     #打开文件  

(my $prename = $file) =~ s/([a-zA-Z]+)\..*/$1/;
    system "md $prename";
    chdir $prename; #设定输出文件夹为输入文件名
    
    local $/ = ">";     #设置读取结束标记为>, 默认为\n  
while(<FILE>){  
        if(/^>$/){  
                next;  
        }  
        s/>//;      #去掉序列结束位置的>号  
        s/(\A.*)/>$1/;       #为分割出来的序列第一行添加>号  
        my $name = $1;        #以fasta序列第一行作为文件名  
        s/(\A\>.*\n)(.*\Z)/$2/; 
        open OUTPUT, '>', $prename.'-'.$name.'.seq';         
        print OUTPUT $_;  
        close OUTPUT;  
 
}  
close FILE;
