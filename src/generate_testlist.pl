#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long;

my $spec     = '0.0';
my $lang      = 'c';
my $help=0;



GetOptions(
    'spec=s'    => \$spec,
    'lang=s'     => \$lang,
    'help!'     => \$help,
) or die "Incorrect usage! Please try ./generate_testlist.pl --help\n";



if( $help ) {
print_help_text ();   exit 0;
} else {
create_testList();    exit 0;
}



















sub create_testList
{
my $dir = './'.$lang;

    opendir(DIR, $dir) or die $!;

    while (my $file = readdir(DIR)) 
	{
     	next if ($file =~ m/^\./);
	my $file_content = getFileContent("$dir/$file");
 		if($file_content =~ m/<ompts:ompversion>$spec<\/ompts:ompversion>/) {
		 my @split_result=split (/\./,$file);
                 print "$split_result[0]\n";  # only file name without extension.
    		}
       }
        
     closedir(DIR);
}


sub print_help_text 
{
print <<EOF;
generate_testlist.pl [options] 

create a  test list of a spacefic language (c,fortran) according to version spec 

Options:
  --help            displays this help message
  --lang=s          select language
  --spec=s          selec version spacification
EOF
}

sub getFileContent
{
my $file_name=shift;
local *FILE;
open  FILE, "<$file_name";
my $file_contents = do { local $/; <FILE> };
close (FILE);
return $file_contents;

}

