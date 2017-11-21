#!/usr/bin/perl


print "
  ##########################################################################
	# version 0.1.3 2017-11-09                                               #
	# contact with Email: xinli_0111@foxmail.com                             #
	# default filename: sequence.gb                                          #
	##########################################################################
\n";


$gbFile = $ARGV[0];                                                                             
if (defined($gbFile)){                                                                             
	if ($gbFile eq '-d') {                                                                         
		$gbFile = 'sequence.gb';                                                                   
	} 
	print "Processing $gbFile, please wait...\n";                                                                                                
}else{                                                                                                
	print "\tPlease input arguemnt of genbank file name!\n\te.g. genbank2featureSeq.pl sequence.gb\n";
}                                                                                                     

#if (@ARGV==undef) {
#	print "Please input genbank file!\n";
#}elsif ($ARGV[0]=="-d") {
#	$gbFile = "sequence.gb";
#	print "Processing $gbFile, please wait...\n";
#}else {
#	$gbFile = $ARGV[0];
#	print "Processing $gbFile, please wait...\n";
#}


$/ = "//";

open GB, "$gbFile";
open TI, '>', "ExtractedTaxonInformation.txt";
print TI "Accession\tSpeciesName\tTaxon\n";

for $seqInfo (@seqInfo=<GB>){ 
	    $accession = $seqInfo =~ s/.+VERSION\s+([A-Z]{2}_?[0-9.]+).+/$1/sr;
	    $taxonInfo = $seqInfo =~ s/.+ORGANISM(.+?)REFERENCE.+/$1/rs;
	    $taxonInfo =~ s/\n/@/;
	    ($speciesName, $taxon) = split /\@/, $taxonInfo;
	    $speciesName =~ s/\s+/_/g;
	    $speciesName =~ s/^_([A-Z][a-z])/$1/g;
	    $taxon =~ s/\n/>/g;
        $taxon =~ s/\s+/_/g;
	    $taxon =~ s/\>\>/;/g;
	    $taxon =~ s/;(_|>)/>/g;
	    $taxon =~ s/_([A-Z][a-z])/$1/g;
	    
	    print TI "$accession\t$speciesName\t$taxon\n";
}
print "Completed!";
