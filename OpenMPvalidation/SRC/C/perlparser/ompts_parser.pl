#!/usr/bin/perl -w

# ompts_parser [option] SOURCEFILE
# 
# Creats the test and the crosstest for the OpenMP-Testsuite out of an templatefile.
# 
# options:
# -test: 		make test
# -crosstest: 	make crosstest
# -o:			outputfilename (not implemented yet)
# 

use Getopt::Long;
GetOptions("-test" => \$test,"-crosstest" => \$crosstest, "-o=s" => \$outputfile, "-f!");
@sourcefiles = @ARGV; 

#checking if options are valid:
if(@ARGV == 0){die "No files to parse are specified!";}
if($outputfile && (@ARGV != 1 || ($test && $crosstest) ) ){die "There were multiple files for one outputfiles specified!";} 

foreach $srcfile (@sourcefiles){

# reading sourcefile:
	open(TESTCODE,$srcfile) or die "Could not open the sourcefile";
	while(<TESTCODE>){
		$sourcecode .= $_;
	}
	close(TESTCODE);

# extracting the c sourcecode:
	$sourcecode =~ /\<ompts\:testcode\>(.*?)\<\/ompts\:testcode\>/gs;
	$sourcecode = $1;
	$sourcecode =~ /\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>/;
	$functionname = $1;

# creating the crosstest:
	if($crosstest){
		open(OUTFILE,">crosstest_".$functionname."\.c") or die "Could not create the outputfile for the crosstest.";
		$_ = $sourcecode;
		s#\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>#crosscheck\_$1#;
		s#\<ompts\:crosscheck\>(.*?)\<\/ompts\:crosscheck\>#$1#gs;
		s#\<ompts\:check\>(.*?)\<\/ompts:check\>##gs;
		print OUTFILE $_;
		close(OUTFILE);
	}
# creating the test:
	if($test){
		open(OUTFILE,">test_".$functionname."\.c") or die "Could not create the outputfile for the test.";
		$_ = $sourcecode;
		s#\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>#check_$1#;
		s#\<ompts\:check\>(.*?)\<\/ompts\:check\>#$1#gs;
		s#\<ompts\:crosscheck\>(.*?)\<\/ompts\:crosscheck\>##gs;
		print OUTFILE $_;
		close(OUTFILE);
	}
}
