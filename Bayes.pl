#!/usr/bin/perl

use strict;
use Cwd;
use File::Copy::Recursive qw(dircopy);

	##########################################################################
	# version 0.1 2017-07-29                                                 #
	# contact with Email: xinli_0111@foxmail.com                             #
	##########################################################################

my $systemEdtion;
if ($ARGV[0] eq '-d'){
  $systemEdtion = '64';
}else{
  print "系统位数（86或64）：\n";
  $systemEdtion = <STDIN>;
}
my $curr_dir = getcwd;
my $Bayes_dir = 'E:\BioApp\MrBayes-3.2.6_WIN32_x64\MrBayes\forCopy';

dircopy ($Bayes_dir, $curr_dir) or die $!;

system ("call mrbayes_x$systemEdtion.exe");
unlink <*.dll>,<*.exe>;
