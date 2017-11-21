#!/usr/bin/perl
use 5.010;
use Bio::Perl;
use Bio::SeqIO;
use LWP::Simple;

print "
######################################################################################################
#  This Perl script is used for get biological DNA sequences identification results from BOLD system #
#  Contact: xinli_0111\@foxmail.com                                                                   #
#  Date: 2017-11-18  Update:2017-11-21                                                               #
#  Version: 0.0.2                                                                                    #
######################################################################################################
\n";

my $database = "COX1_SPECIES";
=Options option
Options:
?db=COX1 Every COI barcode record on BOLD with a minimum sequence length of 500bp (warning: unvalidated library and includes records without species level identification). This includes many species represented by only one or two specimens as well as all species with interim taxonomy. This search only returns a list of the nearest matches and does not provide a probability of placement to a taxon. 
?db=COX1_SPECIES Every COI barcode record with a species level identification and a minimum sequence length of 500bp. This includes many species represented by only one or two specimens as well as all species with interim taxonomy. 
?db=COX1_SPECIES_PUBLIC All published COI records from BOLD and GenBank with a minimum sequence length of 500bp. This library is a collection of records from the published projects section of BOLD.
?db=COX1_L640bp Subset of the Species library with a minimum sequence length of 640bp and containing both public and private records. This library is intended for short sequence identification as it provides maximum overlap with short reads from the barcode region of COI.
=cut

my $inputFile = $ARGV[0]; #获取待鉴定fas文件
if (defined($inputFile)){
	if ($inputFile eq '-d') {
		$inputFile = 'identifying.fasta';
	}
	print "Processing $inputFile, database is $database, please wait...\n"; 
}else{ 
	print "\tPlease input arguemnt of fasta file name!\n\te.g. BOLDidentify.pl identifying.fasta\n";
}

#get fasta objects
my $seqio = Bio::SeqIO->new(-file =>$inputFile, -format=>'fasta');

#set output directory
if (-e "IdentifiedResults") {
  chdir "IdentifiedResults";
}else {
  mkdir "IdentifiedResults";
  chdir "IdentifiedResults";
}


while (my $seq_obj = $seqio->next_seq()){

#get fasta informations
my $display_name = $seq_obj->display_name;
my $seq = $seq_obj->seq;
my $len = $seq_obj->length;

if (-e "$display_name-$len"."bp.xml"){
  next;
}else {
  open OUT, '>', "$display_name-$len"."bp.xml";

#begin identification
my $identifiedResults = get("http://v4.boldsystems.org/index.php/Ids_xml?db=$database&sequence=".$seq);

#print to xml file
print OUT "$identifiedResults";
}
}
print "Completed!";
