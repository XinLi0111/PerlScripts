#!/usr/bin/perl

#此Perl脚本用于注释线粒体环基因位置
#版本号：0.1.2 (2017-05-22)
#用法：perl Perl名称 序列全长名称 短序列模式匹配式
#例如：perl MitochondrialAnnotation.pl Ectophasia_roundivent.seq *.seq
#Name: LiXin (Eric) Mail: xinli_0111@foxmail.com



 $mt = $ARGV [0];
($new_mt = $mt) =~ s/\.seq/.saq/;
rename $mt, $new_mt; #防止本身进入位点标记

  open FILE, $new_mt; 
    chomp ( $whole_seq = <FILE>); #全长序列

#打开文件读取序列    
       $tRNAIle = glob '*tRNAIle*.seq';
       $srRNA = glob '*srRNA*.seq';
  open HEAD, $tRNAIle;
       $Ile_seq = <HEAD>;
  open TAIL, $srRNA;
       $sr_seq = <TAIL>;

     $whole_seq =~ m/$Ile_seq/; #tRNAIle左侧序列
  open HEAD, '>', "head-".$new_mt;
     print HEAD "$`";
  close HEAD;
     
     $whole_seq =~ m/$sr_seq/; #srRNA右侧序列
  open TAIL, '>', "tail-".$new_mt;
     print TAIL "$'";
  close TAIL;
 
     $whole_seq =~ m/($Ile_seq.*$sr_seq)/;#rm head & tail
          $len =length $&;
          $value_seq_name = $len."-".$new_mt; #有效使用 全长序列名称
  open FILE, '>', $value_seq_name;
     print FILE "$&"; 
  close FILE;  

#给片段标记位置
     
for $seq_name (glob $ARGV [1]) {  
  open SEQUENCE, $value_seq_name;
    $value_seq = <SEQUENCE>;  
  open SEQ, $seq_name;
    $seq = <SEQ>;
    $value_seq =~ m/$seq/; #序列匹配
         $seq_start = $-[0]+1;  #序列起始位置
         $name_plus = $seq_start."-".$+[0]."-".$seq_name; #序列终止位置
  close SEQ;
  close SEQUENCE;
     rename $seq_name, $name_plus;
}
  for $finalmt (glob '*.saq'){ #将saq还原成seq
     ($final_mt = $finalmt) =~ s/\.saq/.seq/;
      rename $finalmt, $final_mt;}
      
print "处理完成！\n";
   
