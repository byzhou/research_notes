#!/usr/bin/perl

use File::Basename;

#This is the default tex file path. It is advised to change this every week.
$texfile = "\.\.\/latex\/week9_fall\.tex";
#Default set is doing some bullshit. Don't care about it.
$cmd = "pwd\n";

#help text for unexpected situations
$stderr=<< "EOF";

    This indicates an common error that you are experiencing. Please check your
    commands and re-enter them again.

EOF

$help_text = << "EOF";

Usage: It is used for observing the latex notes. Th series of commands will handl the notes into a 
       nice repo. It provides me a great opportunity to learn this language perl.

    [-c] (target.tex) Compile the targe tex file into current folder. If file needs to be putted 
        into a specific folder, more parameters needs to be specified.
        Example:
            ./run.pl -c Using the default file to compile.
            ./run.pl -c ../latex/week1_fall.tex Using the file at that place.
        The pdflatex compilation log will be saved in the last_fun.log file in the same dir.
    [-h] This is the help text.
        or call [--help], or call [-help]
    [-p] Push all the tex file to github.
    [-rm] All the unncessary files will be moved.
    [-v] Similar to -c but -v is the command that shows the pdf file after the compilation.

EOF

while(@ARGV){

    if ($ARGV[0] eq "-h" || $ARGV[0] eq "--help" || $ARGV[0] eq "-help"){
        print "$help_text"."\n";
        next;
    }
    
    if ($ARGV[0] eq "-rm") {
        $cmd = "rm \*\.aux \*\.log  ";
        system ($cmd);
        print "All the unnessary files have been removed\.\n";
        next;
    }
 
    if ($ARGV[0] eq "-p") {
        $cmd = "cd \.\.\/latex\/ \&\& \.\/autocommit \&\& cd \-";
        system ($cmd);
        print "All the files have been push to the repo\.\n";
        next;
    }

    if ($ARGV[0] eq "-c"){
        print "Taking the tex file \.\.\.\n";
        #get the file dir if the file is not in default path
        if ($ARGV[1] ne ""){
            $texfile = $ARGV[1];
            print "\tUsing tex file here at " . $texfile . "\n";
        } else {
            print "\tUsing default tex file at " . $texfile . "\n";
        }

        #read the tex file and compile it in the default dir
        if (/$texfile$/ eq "\.tex"){
            print $stderr . "\tThe file format is not tex.\n";
        } else {
            print "Tex file has been read\. And executing\:\n";
            $cmd = "\t" . "pdflatex " . $texfile . "\> last\_run\.log";
            print $cmd . "\n";
            system ($cmd);
            print "\tCompiling log is in last\_run\.log\n"
        } 
        
        next;
    }
     
    if ($ARGV[0] eq "-v"){
        print "Taking the tex file \.\.\.\n";
        #get the file dir if the file is not in default path
        if ($ARGV[1] ne ""){
            $texfile = $ARGV[1];
            print "\tUsing tex file here at " . $texfile . "\n";
        } else {
            print "\tUsing default tex file at " . $texfile . "\n";
        }

        #read the tex file and compile it in the default dir
        if (/$texfile$/ eq "\.tex"){
            print $stderr . "\tThe file format is not tex.\n";
        } else {
            print "Tex file has been read\. And executing\:\n";
            $cmd = "\t" . "pdflatex " . $texfile . "\> last\_run\.log";
            print $cmd . "\n";
            system ($cmd);
            print "\tCompiling log is in last\_run\.log\n";

            #Show the pdf file in pdf
            my ($filename,$dir,$ext) = fileparse($texfile,qr/\.[^.]*/);
            $cmd = "evince " . $filename . "\.pdf" . "\&";
            print "Now you have the pdf file here as " . $filename . "\.pdf\n";
            system ($cmd);
        } 
        next;
    }
} continue {
    shift (@ARGV);
}

#pdflatex ../latex/week2_fall.tex
#evince week2_fall.pdf &
