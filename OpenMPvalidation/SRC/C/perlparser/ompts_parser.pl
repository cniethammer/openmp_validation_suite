#!/usr/bin/perl -w

# ompts_parser [option] SOURCEFILE
# 
# Creats the tests and the crosstests for the OpenMP-Testsuite out of an templatefiles which are given to the programm.
# 
# options:
# -test: 		make test
# -crosstest: 	make crosstest
# -main			generates source for standalone tests (not implemented yet)
# -o=FILENAME	outputfile (only when one templatefile is specified)(not implemented yet)
# 

$mainprocsrc = "ompts_standaloneProc.c";
use Getopt::Long;
GetOptions("-test" => \$test,"-crosstest" => \$crosstest, "-o=s" => \$outputfile, "-main" => \$makeMain, "-f!");
@sourcefiles = @ARGV; 

#checking if options are valid:
if(@ARGV == 0){die "No files to parse are specified!";}
if($outputfile && (@ARGV != 1 || ($test && $crosstest) ) ){die "There were multiple files for one outputfiles specified!";} 

if($makeMain){
############################################################
# creating the test and the crosstest source as a standalone programm
	open(MAINPROC,$mainprocsrc) or die "Could not open the sourcefile for the main program $mainprocsrc";
	while(<MAINPROC>){
		$mainproc .= $_;
	}
	close(MAINPROC);

	foreach $srcfile (@sourcefiles){
		
		# reading sourcefile:
		open(TESTCODE,$srcfile) or die "Could not open the sourcefile";
		while(<TESTCODE>){
			$sourcecode .= $_;
		}
		close(TESTCODE);
		$sourcecode =~ /\<ompts\:directive\>(.*)\<\/ompts\:directive\>/;
		$directive = $1;
		# extracting the sourcecode:
		$sourcecode =~ /\<ompts\:testcode\>(.*?)\<\/ompts\:testcode\>/gs;
		$sourcecode = $1;
		$sourcecode =~ /\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>/;
		$functionname = $1;
		if($crosstest){
			open(OUTFILE,">crosstest_".$functionname."\.c") or die "Could not create the outputfile for the crosstest.";
			$_ = $sourcecode;
			s#\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>#crosscheck\_$1#;
			s#\<ompts\:crosscheck\>(.*?)\<\/ompts\:crosscheck\>#$1#gs;
			s#\<ompts\:check\>(.*?)\<\/ompts:check\>##gs;
			$mainproc =~ s#\<testfunctionname\>#crosscheck\_$functionname#gs;
			$mainproc =~ s#\<directive\>#$directive (crosscheck)#gs;
			$_.=$mainproc;
			print OUTFILE $_;
			close(OUTFILE);
		}
		
		# creating the test main:
		if($test){
			open(OUTFILE,">test_".$functionname."\.c") or die "Could not create the outputfile for the test.";
			$_ = $sourcecode;
			s#\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>#check_$1#;
			s#\<ompts\:check\>(.*?)\<\/ompts\:check\>#$1#gs;
			s#\<ompts\:crosscheck\>(.*?)\<\/ompts\:crosscheck\>##gs;
			$mainproc =~ s#\<testfunctionname\>#check\_$functionname#gs;
			$mainproc =~ s#\<directive\>#$directive#gs;
			$_.=$mainproc;
			print OUTFILE $_;
			close(OUTFILE);
		}
	}
}
else{
############################################################
# creating the test and crosstest source as a function:
	foreach $srcfile (@sourcefiles){
		
		# reading sourcefile:
		open(TESTCODE,$srcfile) or die "Could not open the sourcefile";
		while(<TESTCODE>){
			$sourcecode .= $_;
		}
		close(TESTCODE);

		# extracting the sourcecode:
		$sourcecode =~ /\<ompts\:testcode\>(.*?)\<\/ompts\:testcode\>/gs;
		$sourcecode = $1;
		$sourcecode =~ /\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>/;
		$functionname = $1;

		# creating the crosstest function:
		if($crosstest){
			open(OUTFILE,">crosstest_".$functionname."\.c") or die "Could not create the outputfile for the crosstest.";
			$_ = $sourcecode;
			s#\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>#crosscheck\_$1#;
			s#\<ompts\:crosscheck\>(.*?)\<\/ompts\:crosscheck\>#$1#gs;
			s#\<ompts\:check\>(.*?)\<\/ompts:check\>##gs;
			print OUTFILE $_;
			close(OUTFILE);
		}
		
		# creating the test function:
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
}
