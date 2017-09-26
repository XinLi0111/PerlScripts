#!/usr/bin/perl
use strict;
use warnings;
use Bio::Perl;
use Bio::SeqIO;


open OUT, '>', 'TachDataDeal_CountryOut20170820.txt';
print OUT "Accession\tCountry\n";
my $seqio = Bio::SeqIO->new(-file =>'TachDataDeal20170827.gb', -format=>'genbank');
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
