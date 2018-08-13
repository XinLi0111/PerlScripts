#!/usr/bin/perl
use 5.010;
use warnings;
use Bio::Perl;
use Bio::SeqIO;

print "
    ##########################################################################
    # Version 0.6.0                                                          #
    # Date 2018-06-20                                                        #
	# Author Eric Lee                                                        #
    # default filename: sequence.gb                                          #
    # if has postion error exception, try use this regular expression        #
    # '\\s(complement\\()?(join)?\\([0-9.]+,[0-9.]+\\)'                          #
    # to locate wrong postion in genbank file                                #
    ##########################################################################
\n";



=History:
2017-11-09: create this script to extract gene features and seqs in genbank file
2018-05-05: fix the scientific name, now it is avaliable in  all blank table
2018-05-05: add extract country in this script
2018-05-06: add ectract taxon info
2018-05-08: formating the gene name and reduce non-sence information
2018-06-20: add keyword for select seqs in NCBI RefSeq database
=cut

###############################################################################
# set inputfile and parameters
my $inputFile = $ARGV[0];
if (defined($inputFile)){
	if ($inputFile eq '-d') {
		$inputFile = 'sequence.gb';
	}
	print "Processing $inputFile, please wait...\n"; 
}else{ 
	print "\tPlease input arguemnt of genbank file name!\n\te.g.  extract_genbank2info.pl sequence.gb\n";
}


###############################################################################
# set output filename 'extract-genbank-info-results-<date>-<time>.tsv'

$time = `echo %date%-%time%`; # tested on windows 10, strawberryperl 5.26
$nwtime = $time =~ s#[:/]#-#gr;
chomp $nwtime;
#my $outputFile = 'extract-genbank-info-results.tsv'; 
my $outputFile = 'extract-genbank-info-results-'.$nwtime.'.tsv'; 
open OUT, '>', $outputFile or die "Cannot open file $outputFile: $!";
print OUT "Accession\tScientificName\tFeature\tGeneName\tStart\tEnd\tSeqLength\tSequence\tY/Ncircular\ttaxon\tKeywords\tLocation\n"; # input table headers

###############################################################################
# extract taxon info and KEYWORDS (RefSeq)

$/ = "//"; #change line operator from "\n" to "//"

my %taxon_hash = ();
my %keywords = ();
open GB, '<', $inputFile;

for $seqInfo (@seqInfo = <GB>){ 
	    $accession = $seqInfo =~ s/.+ACCESSION\s+([A-Z]{2}_?[0-9]+).+/$1/sr;
	    $taxonInfo = $seqInfo =~ s/.+ORGANISM\s+([A-Z].+?)REFERENCE.+/$1/rs;
	    $taxon = $taxonInfo =~ s/.+\n//r;
	    $taxon =~ s/\n//g;
		$taxon =~ s/\s+|\.//g;
		@all_taxon = split(/;/,$taxon);
		splice @all_taxon, 0, 9;
		$new_taxon = join "->", @all_taxon;
	    $taxon_hash{$accession} = $new_taxon;


        # for keyword RefSeq pasre
		$keyword = $seqInfo =~ s/.+KEYWORDS\s+(.+?)SOURCE.+/$1/sr; # wether ReqSeq or not
		if ($keyword =~ /RefSeq./) {
			$keyword = "RefSeq";
		}else{
			$keyword = 'NA';
			}

		$keywords{$accession} = $keyword;
	    # print %taxon_hash; # only for test
}
close GB;

$/ = "\n";


###############################################################################
# define hash for formating gene name like COI COXI co1 to COX1 and so on
%gene = (
'12s ribosomal rna' => 's-rRNA',
'12s ribsosmal rna' => 's-rRNA',
'16s ribosomal rna' => 'l-rRNA',
'atp6' => 'ATP6',
'atp8' => 'ATP8',
'atpase 6' => 'ATP6',
'atpase 8' => 'ATP8',
'coi' => 'COX1',
'coii' => 'COX2',
'coiii' => 'COX3',
'cox1' => 'COX1',
'cox2' => 'COX2',
'cox3' => 'COX3',
'coxi' => 'COX1',
'coxii' => 'COX2',
'coxiii' => 'COX3',
'cytb' => 'CYTB',
'large subunit ribosomal rna' => 'l-rRNA',
'l-rrna' => 'l-rRNA',
'nad1' => 'ND1',
'nad2' => 'ND2',
'nad3' => 'ND3',
'nad4' => 'ND4',
'nad4l' => 'ND4L',
'nad5' => 'ND5',
'nad6' => 'ND6',
'nadh1' => 'ND1',
'nadh2' => 'ND2',
'nadh3' => 'ND3',
'nadh4' => 'ND4',
'nadh4l' => 'ND4L',
'nadh5' => 'ND5',
'nadh6' => 'ND6',
'nd1' => 'ND1',
'nd2' => 'ND2',
'nd3' => 'ND3',
'nd4' => 'ND4',
'nd4l' => 'ND4L',
'nd5' => 'ND5',
'nd6' => 'ND6',
'small subunit ribosomal rna' => 's-rRNA',
's-rrna' => 's-rRNA',
'trna-ala' => 'tRNA-Ala',
'trna-arg' => 'tRNA-Arg',
'trna-asn' => 'tRNA-Asn',
'trna-asp' => 'tRNA-Asp',
'trna-cys' => 'tRNA-Cys',
'trna-gln' => 'tRNA-Gln',
'trna-glu' => 'tRNA-Glu',
'trna-gly' => 'tRNA-Gly',
'trna-his' => 'tRNA-His',
'trna-ile' => 'tRNA-Ile',
'trna-leu' => 'tRNA-Leu',
'trna-lys' => 'tRNA-Lys',
'trna-met' => 'tRNA-Met',
'trna-phe' => 'tRNA-Phe',
'trna-pro' => 'tRNA-Pro',
'trna-ser' => 'tRNA-Ser',
'trna-thr' => 'tRNA-Thr',
'trna-trp' => 'tRNA-Trp',
'trna-tyr' => 'tRNA-Tyr',
'trna-val' => 'tRNA-Val',
'nadh dehydrogenase subunit 1' => 'ND1',
'nadh dehydrogenase subunit 2' => 'ND2',
'nadh dehydrogenase subunit 3' => 'ND3',
'nadh dehydrogenase subunit 4' => 'ND4',
'nadh dehydrogenase subunit 4l' => 'ND4L',
'nadh dehydrogenase subunit 5' => 'ND5',
'nadh dehydrogenase subunit 6' => 'ND6',
'cytochrome b' => 'CYTB',
'nadh subunit 1' => 'ND1',
'nadh subunit 2' => 'ND2',
'nadh subunit 3' => 'ND3',
'nadh subunit 4' => 'ND4',
'nadh subunit 5' => 'ND5',
'nadh subunit 6' => 'ND6',
'nadh subunit 4l' => 'ND4L',
'cytochrome c oxidase subunit i' => 'COX1',
'cytochrome-c oxidase subunit i' => 'COX1',
'cytochrome c oxidase subunit iii' => 'COX3',
'cytochrome c oxidase subunit ii' => 'COX2',
'atp synthase f0 subunit 8' => 'ATP8',
'atp synthase f0 subunit 6' => 'ATP6',
'cytochrome oxidase subunit i' => 'COX1',
'cytochrome oxidase subunit ii' => 'COX2',
'atpase subunit 8' => 'ATP8',
'atpase subunit 6' => 'ATP6',
'cytochrome oxidase subunit iii' => 'COX3',
'cocii' => 'COX2',
'cob' => 'CYTB',
'cytochrome oxidase subunit 1' => 'COX1',
'cytochrome oxidase subunit 2' => 'COX2',
'cytochrome oxidase subunit 3' => 'COX3',
'cytochrome c oxidase subunit 1' => 'COX1',
'cytochrome c oxidase subunit 2' => 'COX2',
'cytochrome c oxidase subunit 3' => 'COX3'
);

###############################################################################
# use Bio::Perl to get other info

my $in_obj = Bio::SeqIO->new(-file=>$inputFile,-format=>'genbank');

while (my $seq_obj = $in_obj->next_seq() ) {

	my $accession = $seq_obj->accession;
    my $organism = '';
	my $country = '';	
  	my @features = $seq_obj->get_SeqFeatures;
    
	#print seq informations
    for my $feature (@features){
		# $primary_tag = $feature->primary_tag;
        if  (  $feature->primary_tag eq "source" 
		    or $feature->primary_tag eq "CDS" 
			or $feature->primary_tag eq "tRNA" 
			or $feature->primary_tag eq "rRNA"){

				
           	print OUT $accession."\t"; # accession
           	   
           	if ($feature->has_tag("organism")){
           	    for my $organism_value ($feature->get_tag_values("organism")){
	    			$organism = $organism_value =~ s/\s/_/gr;
	    			print OUT $organism."\t"; # ScientificName
	    			}
           	}else{
           	   	print OUT $organism."\t";
           	}
               
           	print OUT $feature->primary_tag,"\t"; # Feature
           	   
           	     
           	if ($feature->primary_tag eq 'CDS'){
           	   	if ($feature->has_tag("gene")){
	    				  
	    			for my $cds ($feature->get_tag_values("gene")){
	    				$cds = lc($cds);
						if (exists $gene{$cds}){				
	    				    print OUT $gene{$cds}."\t";
							last; # if have the same tags in one feature then only print the first one
						}else{ print "$cds\n";} # if there is gene name not in gene hash, then print on screen
	    				}
           	   	}else {
           	   	    print OUT "NA\t";
           	   	}
           	}elsif ($feature->primary_tag eq 'rRNA'){
           	   	if ($feature->has_tag("product")){
    
           	   	 	for my $rRNA ($feature->get_tag_values("product")){
	    				$rRNA = lc($rRNA);					
	    				print OUT $gene{$rRNA}."\t";
	    				}		  
           	   	}else {
           	   	    print OUT "NA\t";
           	   	}
           	}elsif ($feature->primary_tag eq 'tRNA'){
           	   	if ($feature->has_tag("product")){
	    				  
           	   	 	for my $tRNA ($feature->get_tag_values("product")){
	    				$tRNA = lc($tRNA);					
	    				print OUT $gene{$tRNA}."\t";
	    				}		  
           	   	}else {
           	   	    print OUT "NA\t";
           	   	}
			}elsif ($feature->primary_tag eq 'source'){

           	   	if ($feature->has_tag("organelle")){					
	    			print OUT $feature->get_tag_values("organelle"),"\t";		  
           	   	}else {
           	   	    print OUT "NA\t";
				}
           	}else{
           	   	print OUT "NA\t";# without GeneName
           	}
           	     
    
           	my $Start = $feature->start; # start location
            my $End = $feature->end;     # end location
           	my $Sequence = $seq_obj->subseq($Start, $End); # gene sequence
           	my $SeqLength = length($Sequence); # gene length  
           	       
            print OUT $Start."\t";
            print OUT $End."\t";
            print OUT $SeqLength."\t";
            print OUT $Sequence."\t";
            
    
            if ($seq_obj->is_circular) {
            	print OUT "circular\t"; # is circular
            }else{
                print OUT "linear\t";
            }

			
			
    
	    	print OUT $taxon_hash{$accession}."\t"; # taxon information
			chomp $keywords{$accession};
	    	print OUT $keywords{$accession}."\t"; # for select wether RefSeq or not   


	    	if ($feature->has_tag("country")){
    
           	    for my $country_value ($feature->get_tag_values("country")){
	    			$country_value =~ s/:\s?/->/g;
	    			$country_value =~ s/,\s/->/g;
	    			$country = $country_value =~ s/\s/_/gr;
	    			print OUT $country."\n"; # country Location
	    		}
	    	}else{
           		print OUT $country."\n";
           	}
        }
	}         
}


close OUT;


print "Completed!\n";
