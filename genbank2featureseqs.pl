#!/usr/bin/perl
use 5.010;
use warnings;
use Bio::Perl;
use Bio::SeqIO;

	##########################################################################
	# version 0.1.2 2017-08-21                                               #
	# contact with Email: xinli_0111@foxmail.com                             #
	# default filename: sequence.gb                                          #
	##########################################################################

my $inputFile = $ARGV[0];
if (defined($inputFile)){
	if ($inputFile eq '-d') {
		$inputFile = 'sequence.gb';
	}
  print "Processing, Please wait...\n";
}else{ 
	print "\tPlease input arguemnt of genbank file name!\n\te.g. genbank2featureSeq.pl sequence.gb\n";
}
	
	
my $outputFile = "ExtractedSequencesInformation.txt";


my $in_obj = Bio::SeqIO->new(-file=>$inputFile,-format=>'genbank');
open OUT, '>', $outputFile;
print OUT "AccessionNum\tScientificName\tFeature\tGeneName\tStart\tEnd\tSeqLength\tSequence\tY/Ncircular\n";#input table headers
 while (my $seq_obj = $in_obj->next_seq() ) {
	    my $accesion = $seq_obj->accession;
    	my $seq_ver = $seq_obj->seq_version;
    	my $AccessionNum = $accesion.'.'.$seq_ver;
      	
  	  my @features = $seq_obj->get_SeqFeatures;
     for my $feature (@features){
     	
     	     
       	   #print seq informations
       	   print OUT $AccessionNum."\t";#AccessionNum
       	   
       	   if ($feature->has_tag("organism")){
       	      print OUT $feature->get_tag_values("organism"),"\t";#ScientificName
       	   }else{
       	   	 print OUT "\t";
       	   }
       	
       	   print OUT $feature->primary_tag,"\t";#Feature
       	   
       	     
       	   if ($feature->primary_tag eq 'CDS'){
       	   	    if ($feature->has_tag("gene")){
       	   	 	     print OUT $feature->get_tag_values("gene"),"\t";#CDS GeneName
       	   	    }else {
       	   	    	 print OUT "\t";
       	   	    }
       	   }elsif ($feature->primary_tag eq 'rRNA'){
       	   	 	  if ($feature->has_tag("product")){
       	   	 	    print OUT $feature->get_tag_values("product"),"\t";#rRNA GeneName       	   	 	
       	   	    }else {
       	   	    	 print OUT "\t";
       	   	    }
       	   }elsif ($feature->primary_tag eq 'tRNA'){
       	   	 	  if ($feature->has_tag("product")){
       	   	 	    print OUT $feature->get_tag_values("product"),"\t";#tRNA GeneName       	   	 	
       	   	    }else {
       	   	    	 print OUT "\t";
       	   	    }
       	   }else{
       	   	      print OUT "\t";#without GeneName
       	   }
       	     
       	   my $Start = $feature->start;#start location
           my $End = $feature->end;    #end location
       	   my $Sequence = $seq_obj->subseq($Start, $End);#gene sequence
       	   my $SeqLength = length($Sequence);#gene length  
       	     
       	     
            print OUT $Start."\t";
            print OUT $End."\t";
            print OUT $SeqLength."\t";
            print OUT $Sequence."\t";
            if ($feature->primary_tag eq 'source'){
              if ($seq_obj->is_circular) {
              	print OUT "circular\n";
              }else{
            	  print OUT "linear\n";
              }
            }else{
            	  print OUT "\t\n";
            }
     }
            
 }
 print "Completed!\n";
