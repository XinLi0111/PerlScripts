#!/usr/bin/perl
use strict;
use Cwd;
use File::Copy;

	##########################################################################
	# version 0.1 2017-07-29                                                 #
	# contact with Email: xinli_0111@foxmail.com                             #
	# default model: GTRGAMMAI                                               #
	##########################################################################

my $currentDir = getcwd;
opendir PHY, $currentDir or die "Can't open directory: $!";
my @dir = readdir PHY;
closedir PHY;
for my $fileName (@dir){
	if ($fileName =~ m/.+\.phy/i){
	  my $phyName = $fileName;
		chomp ($phyName);

	copy ("E:/BioApp/RAxML/RAxML-7.0.3-WIN.exe", "$currentDir") or die "Copy failed: $!";#If original directory of RAxML changed, please change to the new directory!
	
	################################参数提示及设置
	HELP:print "[1]input_addtional_name\t[2]outgroups_(split_with,)\t[3]number_of_runs\n";
   my $arguments = <STDIN>;
   chomp ($arguments);
   my @arguments = split /\s+/, $arguments;
    if (@arguments < 3) {
  goto HELP;
   }else {
     my $outName = $arguments[0];
     my $outGroups = $arguments[1];
     my $numberOfRuns = $arguments[2];
    
     ###################写入批处理
     open BAT, '>', 'run_RAxML.bat'; 
     print BAT "RAxML-7.0.3-WIN.exe -f a -s $phyName -n $outName -o $outGroups -q genenames -m GTRGAMMAI -x 12345 -# $numberOfRuns";
     close BAT;  
     system ("run_RAxML.bat");
     
     unlink "RAxML-7.0.3-WIN.exe";
     unlink "run_RAxML.bat";
    }
	}
}
