#!/usr/bin/perl

if (@ARGV==undef) {
	print "Please input genbank file!\n";
}elsif ($ARGV[0]=="-d") {
	$gbFile = "sequence.gb";
	print "Processing, please wait...\n";
}else {
	$gbFile = $ARGV[0];
	print "Processing, please wait...\n";
}


$/ = "//";

open GB, "$gbFile";
open TI, '>', "ExtractedTaxonInformation.txt";
print TI "Accession\tSpeciesName\tTaxon\n";

for $seqInfo (@seqInfo=<GB>){ 
	    $accession = $seqInfo =~ s/.+VERSION\s+([A-Z]{2}_?[0-9.]+).+/$1/sr;
	    $taxonInfo = $seqInfo =~ s/.+ORGANISM(.+?)REFERENCE.+/$1/rs;
	    $taxonInfo =~ s/\n/>/g;
      $taxonInfo =~ s/\s+/_/g;
	    $taxonInfo =~ s/\>\>/;/g;
	    $taxonInfo =~ s/;(_|>)/>/g;
	    $taxonInfo =~ s/_([A-Z][a-z])/$1/g;
	    
	    print TI "$accession\t$taxonInfo\n";
}
