#!/usr/bin/perl


$/ = "//";

open GB, "sequence.gb";
open TI, '>', "ExtractedTaxonInformation.txt";
print TI "Accession\tSpeciesName\tTaxon\n";

for $seqInfo (@seqInfo=<GB>){ 
	    $accession = $seqInfo =~ s/.+VERSION\s+([A-Z]{2}_?[0-9.]+).+/$1/sr;
	    $taxonInfo = $seqInfo =~ s/.+ORGANISM(.+?)REFERENCE.+/$1/rs;
	    $taxonInfo =~ s/\n|\s+/_/g;
	    $taxonInfo =~ s/_+/_/g;
	    $taxonInfo =~ s/;_/>>/g;
	    $taxonInfo =~ s/_([A-Z][a-z])/\t$1/g;
	    
	    print TI "$accession$taxonInfo\n";
}
