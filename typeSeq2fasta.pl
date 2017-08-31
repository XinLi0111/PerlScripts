#!/usr/bin/perl
use Cwd;
$fastaLJ = cwd;
($fastaNM = $fastaLJ) =~ s/^.+\///;
@allFiles = glob "*.seq";
@allFilesSorted = sort @allFiles;
for $file (@allFilesSorted){
	($seqNM = $file) =~ s/\.seq//;
	open FILE, $file;
	$seq = <FILE>;
	open OUT, '>>', "$fastaNM.fasta";
	print OUT '>', $seqNM."\n";
	print  OUT $seq."\n";
close FILE;
close OUT;
}
