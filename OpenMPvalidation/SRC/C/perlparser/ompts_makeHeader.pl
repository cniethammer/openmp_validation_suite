#!/usr/bin/perl -w

# ompts_makeHeader [options] [dir]
#
# Creats the headerfile for the OpenMP-Testsuite out of the templatefiles 
# witch are in the default/explicitely specified dir and the settings in the
# ompts.conf file in the main directory.
#
# dir:
# 	Specifies the dir with the templatefiles. Default is "./templates"
# 
# options:
# -i: Include other Headerfile. The files to be included must be specified
# after setting this option.
# 
# -o=FILENAME: outputfilename (default is "omp_testsuite.h")


$outfile = "omp_testsuite.h";
$templatedir = "./templates";
$configfile = "ompts.conf";
@includefiles;

# generating the includeguard:
$headerfile = "\#ifndef OMP_TESTSUITE_H\n\#define OMP_TESTSUITE_H\n\n";

# inserting general settings out of ompts.conf:
open(OMPTS_CONF,$configfile) or die "Could not open the global config file $configfile.";
while(<OMPTS_CONF>){
	$headerfile .= $_;
}
close(OMPTS_CONF);

# searching the tests:
opendir TEMPLATEDIR, "./templates" or die "Could not open dir.";
@templates = grep /(.*)\.tpl/, readdir TEMPLATEDIR;
closedir TEMPLATEDIR;

# inserting the function declarations:
foreach $template (@templates){
	$source = "";
	open(TEMPLATE,$templatedir."/".$template) or die "Could not open the following sourcefile: ".$templatedir."/".$template;
	while(<TEMPLATE>){
		$source .= $_;
	}
	close(TEMPLATE);
	$source =~ /\<ompts\:testcode\:functionname\>(.*)\<\/ompts\:testcode\:functionname\>/;
	$functionname = $1."(FILE \* logfile);";
	$source =~ /\<ompts\:directive\>(.*)\<\/ompts\:directive\>/;
	$directive = $1;
	$headerfile .= "int check_".$functionname."  /* Test for ".$directive." */\n";
	$headerfile .= "int crosscheck_".$functionname."  /* Crosstest for ".$directive." */\n";
}

# inserting the end of the includeguard:
$headerfile .= "\n#endif";

# craeting the headerfile:
open(OUTFILE,">".$outfile) or die "Could not create the haedaerfile ($outfile)";
print OUTFILE $headerfile;
close(OUTFILE);

