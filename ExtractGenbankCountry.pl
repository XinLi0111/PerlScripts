#!/usr/bin/perl
use strict;
use warnings;
use Bio::Perl;
use Bio::SeqIO;

print "
        ##########################################################################
	# version 0.1.3 2017-11-09                                               #
	# contact with Email: xinli_0111\@foxmail.com                             #
	# default filename: sequence.gb                                          #
	##########################################################################
\n";


my $inputFile = $ARGV[0];
if (defined($inputFile)){
	if ($inputFile eq '-d') {
		$inputFile = 'sequence.gb';
	}
	print "Processing $inputFile, please wait...\n";       
}else{ 
	print "\tPlease input arguemnt of genbank file name!\n\te.g. genbank2featureSeq.pl sequence.gb\n";
}

open OUT, '>', 'ExtractCountryInformation.txt';
print OUT "Accession\tCountry\n";
my $seqio = Bio::SeqIO->new(-file =>$inputFile, -format=>'genbank');
while (my $seq = $seqio->next_seq()){

my @feat = $seq->get_SeqFeatures;
for my $feat (@feat){

	if ($feat->has_tag("country")){
		my $acc = $seq->accession;
		my $ver = $seq->seq_version;
		my $accession = $acc."\.".$ver;
		print OUT $accession."\t";
		print OUT $feat->get_tag_values("country"),"\n";
	}
}
}
print "Completed!";
