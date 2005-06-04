#!/usr/bin/env perl

$testfile="testlist.txt";
$numthreads=2;


#
# Read the file $testfile. Each line contains a test. 
# Convert template to test and crosstest
# Use make to compile the test
#
$testfile=$ARGV[0];
open(TEST,$testfile) or die "Error: Could not open  $testfile\n";
while(<TEST>){
    $testname = $_;
    chomp($testname);
    
    for($i=0; $i<2; $i++){
	# Create templates:
	$template = "templates/".$testname.".tpl";

	$cmd="grep -q ompts:orphan ".$template;
	$orphanedtest=system($cmd);
	if( ($i==1) && ($orphanedtest==0) ){
	    $orphanflag=" -orphan";
	    $orphanname=" orphaned ";
	} else {
	    $orphanflag="";
	    $orphanname="";
	}	    

	if( ($i==0) || ($orphanedtest==0) ){
	    $cmd="./ompts_parser.pl ".$template." -test".$orphanflag;
	    system($cmd);
	    $cmd="./ompts_parser.pl ".$template." -crosstest".$orphanflag;
	    system($cmd);
	    
	    # Compile:
	    $cmd="make test_".$testname." >> compile.log";
	    system($cmd);
	    $cmd="make crosstest_".$testname." >> compile.log";
	    system($cmd);
	    
	    # Run the tests:
	    $cmd = "OMP_NUM_THREADS=".$numthreads."; ./test_".$testname."> test_".$testname.".out";
	    $exit_status = system($cmd);
	    if ($exit_status){
		print $testname.$orphanname." failed !!! " ;
		$failed = $exit_status >> 8;
	    } else {
		print $testname.$orphanname." succeeded ";
		$failed=0
		}
	    
	    if($failed){
		print "\n";
	    } else {
		# Run the crosstest
		$cmd = "OMP_NUM_THREADS=".$numthreads."; ./crosstest_".$testname."> crosstest_".$testname.".out";
		$exit_status = system($cmd);
		if ($exit_status){
		    $crossresult = $exit_status >> 8;
		    print " and was verified\n";
		} else {
		    $crossresult=0;
		    print " but might just have been lucky\n";
		}
	    }
	    
            # clean up
	    $cmd = "rm test_".$testname." crosstest_".$testname;
	    system($cmd);
	}
    }
}
