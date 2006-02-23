#!/usr/bin/env perl

# runtest [options] FILENAME
#
# Read the file FILENAME. Each line contains a test. 
# Convert template to test and crosstest. 
# If possilble generate orphaned testversions, too.
# Use make to compile the test
#
# Options:
# -norphan				do not generate orphaned test versions
# -maxthread=COUNT		run tests with a threadnumber from 2 up to COUNT
# -norun				only compile, no run
# -nocompile			do not compile, only run
# -lang=LANGUAGE		specify explicit the language (c or fortran)
# -d=DIR				specify the directory containing the templates
#						default is templates
# -results=FILE			specify the name of the file containing the results
# --help				print help
#

$results = "results.txt";
$dir = "";

# Using Getopt::long to extract the programm options
use Getopt::Long;

# Getting given options
GetOptions("--help" => \$help, 
			"-norphan" => \$norphan,
			"-maxthread=i" => \$maxthread, 
			"-norun" => \$norun, 
    		"-nocompile" => \$nocompile, 
			"-lang=s" => \$language,
			"-d=s" => \$dir, 
			"-results=s" => \$results, 
			"-f!");
$testfile = $ARGV[0];

if($help){
    $helptext = "runtest [options] FILENAME\n
The runtest script reads the file FILENAME. Each line of this file has to
contain the name of a test. The script converts templates to tests and
crosstests. If possilble it generates orphaned testversions, too. Then it
compiles the source using make and runs finaly all tests.

Options:
 -norphan            do not generate orphaned test versions
 -maxthread=COUNT    run tests with a threadnumber from 2 up to COUNT
 -norun              only compile, no run
 -nocompile          do not compile, only run
 -lang=LANGUAGE      specify explicit the language (c or fortran)
 -d=DIR              specify the directory containing the templates
            	     default is templates
 -results=FILE       specify the name of the file containing the results
 --help              print help 
";
    print $helptext;
    exit 0;
}

# Set maxthread if it was not specified with the program arguments
if(!($maxthread)){ $maxthread = 2; }
# Checking if given testfile exists
die "The specified testlist does not exist." if(!(-e $testfile));
# Checking if language was specified
if($language eq "c") { $extension = "tpl"; }
elsif($language eq "fortran" or $language eq "f") { $language = "f"; $extension = "f"; }
else { die "You must specify an valid language!\n"; }

# printing some Information
print "Running tests with maximal $maxthread threads.\n";
print "Using testlist $testfile for input.\n";
print "Using dir $dir to search testtemplates.\n";
print "Compiling tests for language $language.\n";

# generating an up to date header file using the ompts_makeHeader.pl script
print "Generating headerfile ...\n";
$cmd = "./ompts_makeHeader.pl $dir";
system($cmd);

print "Reading testlist ...\n";
# opening testlist
open(TEST,$testfile) or die "Error: Could not open  $testfile\n";
# opening the results file in write mode and add the first line (tableheader)
open(RESULTS,">$results") or die "Error: Could not create  $results\n";
print RESULTS "\\ Number of Threads\t";
for($j=2; $j <= $maxthread; $j++){
    print RESULTS "$j\t\t\t\t";
}
print RESULTS "\nTested Directive";
for($j=2; $j <= $maxthread; $j++){
    print RESULTS "\tt\tct\tot\toct";
}
print RESULTS "\n";

# Now run all the tests and write the results of the tests in the resultsfile.
# For each directive there is used a seperate line beginning with the name of 
# the tested directive. It follows the result of the test, crosstest, orphaned
# test and orphaned crosstest.
TEST: while(<TEST>){
    next TEST if /^\s*#/;
    $testname = $_;
    chomp($testname);
    print RESULTS "$testname\t";

    for($numthreads = 2; $numthreads <= $maxthread; $numthreads++){
	for($i=0; $i<2; $i++){
	    # Create templates:
	    $template = $dir."/".$testname.".".$extension;

	    $cmd="grep -q ompts:orphan ".$template;
	    $orphanedtest=system($cmd);
	    if( ($i==1) && ($orphanedtest==0) && !($norphan) ){
		$orphanflag=" -orphan";
		$orphanname="orphaned";
	    } else {
		$orphanflag="";
		$orphanname="";
	    }	    
	    $failed = "-";
	    $crossresult = "-";
	    if( ($i==0) || (($orphanedtest==0) && !($norphan)) ){
		$cmd="./ompts_parser.pl ".$template." -test".$orphanflag." -lang=".$language;
		system($cmd);
		$cmd="./ompts_parser.pl ".$template." -crosstest".$orphanflag." -lang=".$language;
		system($cmd);

		# Compile:
		if(!$nocompile){
		    print "Creating source out of templates ... \n";
		    $cmd="make ".$language.$orphanname."test_".$testname." >> compile.log";
		    system($cmd);
		    $cmd="make ".$language.$orphanname."ctest_".$testname." >> compile.log";
		    system($cmd);
		}
	    
		# Run the tests:
		if(!$norun){
		    print "Running test using $numthreads threads ... ";
		    $cmd = "export OMP_NUM_THREADS=".$numthreads."; ./".$language.$orphanname."test_".$testname."> ".$language.$orphanname."test_".$testname.".out";
		    $exit_status = system($cmd);
		    if ($exit_status){
			print $testname.$orphanname." failed !!! " ;
			$failed = $exit_status >> 8;
			$failed=0
		    } else {
			print $testname.$orphanname." succeeded ";
			$failed=1
		    }

		    if(!$failed){
			print "\n";
		    } else {
			# Run the crosstest
			$cmd = "export OMP_NUM_THREADS=".$numthreads."; ./".$language.$orphanname."ctest_".$testname."> ".$language.$orphanname."crosstest_".$testname.".out";
			$exit_status = system($cmd);
			if ($exit_status){
			    $crossresult = $exit_status >> 8;
			    print " and was verified\n";
			    $crossresult=1;
			} else {
			    $crossresult=0;
			    print " but might just have been lucky\n";
			}
		    }
		    # clean up
		    # $cmd = "rm test_".$testname." crosstest_".$testname;
		    # system($cmd);
		}
	    }
	    print RESULTS $failed."\t".$crossresult."\t";
	}
    }
    print RESULTS "\n";
} # end of outer loop
close(RESULTS);
close(TEST);
