#!/usr/bin/env perl

# runtest [options] FILENAME
#
# Read the file FILENAME. Each line contains a test. 
# Convert template to test and crosstest. 
# If possilble generate orphaned testversions, too.
# Use make to compile the test
#
# Options:
# -norphan			do not generate orphaned test versions
# -maxthread=COUNT		run tests with a threadnumber from 2 up to COUNT
# -norun			only compile, no run
# -nocompile			do not compile, only run
# -lang=LANGUAGE		specify explicit the language (c or fortran)
# -d=DIR			specify the directory containing the templates explicitly
# -results=FILE			specify the name of the file containing the results
# -logfile=FILE			specify the name of the file for global log messages
# --help			print help
#

$results 	= "results.txt";
$logfilename 	= "ompts.log";
$dir 		= "";

# Using Getopt::long to extract the programm options
use Getopt::Long;

# Getting given options
GetOptions("--help" => \$help, 
      "-norphan" => \$norphan,
      "-minthreads=i" => \$minthreads, 
      "-maxthreads=i" => \$maxthreads, 
      "-norun" => \$norun, 
      "-nocompile" => \$nocompile, 
      "-lang=s" => \$language,
      "-d=s" => \$dir, 
      "-results=s" => \$results, 
      "-logfile=s" => \$logfilename, 
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
 -minthreads=COUNT   run tests with a minimum of COUNT>2 threads 
 -maxthreads=COUNT   run tests with a threadnumber from 2 up to COUNT
 -norun              only compile, no run
 -nocompile          do not compile, only run
 -lang=LANGUAGE      specify explicit the language (c or fortran)
 -d=DIR              specify the directory containing the templates
            	     default is templates
 -results=FILE       specify the name of the file containing the results
 -logfile=FILE	     specify the name of the file for global log messages
 --help              print help 
";
    print $helptext;
    exit 0;
}

# Set minthreads if it was not specified with the program arguments
if(!($minthreads) || $minthreads < 2){ $minthreads = 2; }
# Set maxthread if it was not specified with the program arguments
if(!($maxthreads) || $maxthreads < $minthreads ){ $maxthreads = $minthreads; }
# Checking if given testfile exists
if(!(-e $testfile)) { die "The specified testlist does not exist."; }
# Checking if language was specified
if($language eq "c") { $extension = "c"; }
elsif($language eq "fortran" or $language eq "f") { $language = "f"; $extension = "f"; }
else { die "You must specify an valid language!\n"; }

# printing some Information
$message = "Running tests with mimimal $minthreads threads.
Running tests with maximal $maxthreads threads.
Using testlist $testfile for input.
Using dir $dir to search for testtemplates.
Compiling tests for language $language.\n";

print $message;

# printing information in logfile
open(GLOBALLOG,">$logfilename") or die "Error: Could not create  $logfilename\n";
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime time;
$year += 1900;
print GLOBALLOG "Test started on $mday.$mon.$year at $hour:$min:$sec\n\n";
print GLOBALLOG $message;
close(GLOBALLOG);
$cmd = "make print_compile_options >> $logfilename";
system($cmd);
open(GLOBALLOG,">>$logfilename") or die "Error: Could not create  $logfilename\n";
print GLOBALLOG "\n\nStarting tests:\n\n";

# generating an up to date header file using the ompts_makeHeader.pl script if compiling for c
if ($language == "") {
  print "Generating headerfile ...\n";
  $cmd = "./ompts_makeHeader.pl -f=ompts-$extension.conf -t=$dir";
  system($cmd);
}

print "Reading testlist ...\n";
# opening testlist
open(TEST,$testfile) or die "Error: Could not open  $testfile\n";
$results = $language.$results;
# opening the results file in write mode and add the first line (tableheader)
open(RESULTS,">$results") or die "Error: Could not create  $results\n";


print RESULTS "\\ Number of Threads\t";
for($j=$minthreads; $j <= $maxthreads; $j++){
    print RESULTS "$j\t\t\t\t";
}
print RESULTS "\nTested Directive ";
for($j=16; $j < 40; $j++){
    print RESULTS " ";
}
for($j=$minthreads; $j <= $maxthreads; $j++){
    print RESULTS " t\tct\tot\toct";
}
print RESULTS "\n";

# Keep track of information about the tests
$totalnum = 0;
$ctestnum = 0;
$testsuccess = 0;
$testfail = 0;
$testnocompile = 0;

# Now run all the tests and write the results of the tests in the resultsfile.
# For each directive there is used a seperate line beginning with the name of 
# the tested directive. It follows the result of the test, crosstest, orphaned
# test and orphaned crosstest.
TEST: while(<TEST>){
# filter comment and blank lines
	 if (/^\s*#/) {next TEST;}
	 if (/^\s*$/) {next TEST;}
	 $testname = $_;
	 chomp($testname);
	 $template = $dir."/".$testname.".".$extension;

         $totalnum = $totalnum + 1;
	 print RESULTS "$testname"." ";
         for($j = length($testname); $j < 40; $j++){
             print RESULTS ".";
         }
         print RESULTS " ";
	 print "\nTesting for $testname\n";
	 print GLOBALLOG "Testing for $testname\n";

	 $cmd = "grep ompts:orphan ".$template." > /dev/null";
	 $_ = system($cmd);
	 $orphanedtest = 0;
	 if ($_ == 0) { 
	    print "+ Test is orphanable\n"; 
	    if (!($noorphan)) { $orphanedtest = 1; }
	    else 	      { $orphanedtest = 0; }
	 }

         # start compiling and running the test for the specified number of threads
	 for($numthreads = $minthreads; $numthreads <= $maxthreads; $numthreads++){
	    print GLOBALLOG "Testing with $numthreads threads:\n";
	    for($i=0; $i<2; $i++){

	       $success = "-";
	       $crossresult = "-";

               # Create templates:
	       if( ($i == 1) && $orphanedtest ){
		  $orphanflag=" -orphan";
		  $orphanname="orphaned";
	          print GLOBALLOG " (orphanmode) ";
	       } else {
		  $orphanflag="";
		  $orphanname="";
	          print GLOBALLOG " (normalmode) ";
	       }	    

	       if( ($i==0) || $orphanedtest ){
		  if(!$nocompile){
                     # prepare sourcecode:
		     print "Creating source out of templates ....";
		     $cmd="./ompts_parser.pl $template -test $orphanflag -lang=$language";
		     system($cmd);
		     print "....";
		     $cmd="./ompts_parser.pl $template -crosstest $orphanflag -lang=$language";
		     system($cmd);
		     print " successful\n";
                     # Compile:
		     print "Compiling sources .......";
		     $cmd="make ".$language.$orphanname."test_".$testname." >> compile.log";
		     $compile1 = system($cmd);
		     print ".......";
		     $cmd="make ".$language.$orphanname."ctest_".$testname." >> compile.log";
		     $compile2 = system($cmd);
		     if (!$compile1 && !$compile2) {
			print "......... successful\n";
		     }
		     else {
			print "......... failed\n";
			printf GLOBALLOG "Error: Compilation failed\n";
                        $testnocompile = $testnocompile + 1;
		     }
		  }

                  # Run the tests:
		  if(!$norun){
		     $exec_name = $language.$orphanname."test_".$testname;
                     # First check, if executable exists
		     if (-e "$exec_name") { 
			if ($orphanname eq "orphaned") {
			   print "Running orphaned test using $numthreads threads ... ";
			}
			else {
			   print "Running test using $numthreads threads ............ ";
			}

			$cmd = "OMP_NUM_THREADS=$numthreads; export OMP_NUM_THREADS; ./$exec_name > $exec_name.out";
			$exit_status = system($cmd);
			$failed = $exit_status >> 8;
			$success = 100 - $failed;

			if ($failed > 0){
# print $testname.$orphanname." failed $failed\% of the tests.!" ;
			   print "failed $failed\% of the tests!" ;
			   print GLOBALLOG "Error: $failed\% of the tests failed!\n";
                           $testfail = $testfail + 1;
			} else {
# print $testname.$orphanname." succeeded!";
			   print "succeeded";
                           $testsuccess = $testsuccess + 1;
			}

			if($failed > 0){
			   print "\n";
			} else {
# Run the crosstest if available
			   $crossexec_name = $language.$orphanname."ctest_".$testname;
			   if (-e "$crossexec_name") { 
			      $cmd = "OMP_NUM_THREADS=$numthreads; export OMP_NUM_THREADS; ./$crossexec_name > $crossexec_name.out";
			      $exit_status = system($cmd);
			      if ($exit_status){
                                 $ctestnum = $ctestnum + 1;
				 $crossresult = $exit_status >> 8;
				 print " and was verified with a certainty of $crossresult\%\n";
				 printf GLOBALLOG "Succeeded  and was verified with a certainty of $crossresult\%\n";
			      } else {
				 $crossresult=0;
				 print " but might just have been lucky (all crosstests failed)\n";
				 printf GLOBALLOG "Succeeded but might just have been lucky (all crosstests failed)\n";
			      }
			   }
			   else {
			      $crossresult = 0;
			   }
			}
		     }
		     else {
			$success = 0;
		     }
# clean up
# $cmd = "rm $exec_name $crossexec_name";
# system($cmd);
		  }
	       }
	       print RESULTS "$success\t$crossresult\t";
	    }
	 }
	 print RESULTS "\n";
      } # end of outer loop
    print "\nTested $totalnum directive(s). $testfail tests failed, and $testsuccess successful with $ctestnum cross checked\n";
    if ($testnocompile > 0) {
        print "$testnocompile test(s) failed to compile\n";
    }
    print "For more detailed information see files $results, ompts.log, and compile.log\n";
    close(RESULTS);
    close(TEST);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime time;
    $year += 1900;
    print GLOBALLOG "\nTest ended on $mday.$mon.$year at $hour:$min:$sec\n\n";
    close(GLOBALLOG);
