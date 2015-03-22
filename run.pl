#!/usr/bin/perl

use File::Basename;
use Sys::Hostname;

#This is the default tex file path. It is advised to change this every week.
#$texfile = "\.\.\/latex\/week3_spring\.tex";
$texfile = "week5\_spring\.tex";
#Default set is doing some bullshit. Don't care about it.
$cmd = "pwd\n";

#help text for unexpected situations
$stderr=<< "EOF";

    This indicates an common error that you are experiencing. Please check your
    commands and re-enter them again.

EOF

$help_text = << "EOF";

 ____  _____ ____  _       ____  ____  _____     _______ _   _   _        _  _____ _______  __
|  _ \| ____|  _ \| |     |  _ \|  _ \|_ _\ \   / / ____| \ | | | |      / \|_   _| ____\ \/ /
| |_) |  _| | |_) | |     | | | | |_) || | \ \ / /|  _| |  \| | | |     / _ \ | | |  _|  \  / 
|  __/| |___|  _ <| |___  | |_| |  _ < | |  \ V / | |___| |\  | | |___ / ___ \| | | |___ /  \ 
|_|   |_____|_| \_\_____| |____/|_| \_\___|  \_/  |_____|_| \_| |_____/_/   \_\_| |_____/_/\_\


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
    [-l] List all the tex files.
    [-n] Create a new file from the existing template.
    [-w] Open the current tex file and edit it. (The default editor is vim)

EOF

#time info
$currentTime    = localtime() ;
$userName       = getpwuid( $< ) ;
$hostName       = hostname ;


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
        print << "EOF";

        ==================================================================
        $userName \@ $hostName on $currentTime 
        ==================================================================

EOF
        next;
    }

    if ($ARGV[0] eq "-c"){
        print "Taking the tex file \.\.\.\n";
        #get the file dir if the file is not in default path

        $ARGV[1] = $texfile ;

        if (/$texfile$/ eq "" ) {
            $cmd = "\t" . "pdflatex " . "current\.tex" ;
            system ( $cmd ) ;
        } else {
            $cmd = "\t" . "pdflatex " . "\.\.\/latex/" . $texfile ;
            system ( $cmd ) ;
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
        if (/$texfile$/ eq "\.tex" and /$textfile$/ ne "current\.tex" ){
            print $stderr . "\tThe file format is not tex.\n";
        } else {
            print "Tex file has been read\. And executing\:\n";
            $cmd = "ln -svf \.\.\/latex\/$texfile current\.tex &&
                    pdflatex current.tex \> last\_run\.log &&
                    cat last\_run\.log" ;
            print << "EOF";

            ==================================================================
            $userName \@ $hostName on $currentTime 
            ==================================================================

EOF
            print $cmd . "\n";
            system ($cmd);
            print "\tCompiling log is in last\_run\.log\n";


            #Show the pdf file in pdf
            my ($filename,$dir,$ext) = fileparse($texfile,qr/\.[^.]*/);
            #change the target pdf file into current.pdf
            $filename = "current" ;
            $cmd = "evince " . $filename . "\.pdf" . "\&";
            print "Now you have the pdf file here as " . $filename . "\.pdf\n";
            system ($cmd);
        } 
        next;
    }

    if ($ARGV[0] eq "-l"){
        print "All the tex files are listed below...\n";
        $cmd = "cd ../latex/ && ls -al -color *.tex && cd -";
        system ($cmd);
        next;
    }

    if ($ARGV[0] eq "-n"){
        print "Initializing a new file...\n";
        if ($ARGV[1] eq ""){
            print "Please specify the filename..\n";
        } else { 
            $fileName = $ARGV[1] ;
            $cmd = "cd ../latex/ && cp template.tex $fileName && cd - && 
            ln -svf ../latex/$fileName current.tex";
            system ($cmd);
        }
        next;
    }

    if ($ARGV[0] eq "-w"){
        print "Opening the tex file...\n";
        $cmd = "vim current.tex";
        system ($cmd);
        next;
    }

} continue {
    shift (@ARGV);
}

#pdflatex ../latex/week2_fall.tex
#evince week2_fall.pdf &
