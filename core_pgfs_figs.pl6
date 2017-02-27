#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use v5.10;
use List::MoreUtils qw(uniq); 
use Getopt::Std;


#This script prints out a presence or absence matrix with -t option or
#all core PGFs and their respective FIG ids

#Preconditions: input must be tab delimited with patric genome id and  protein global family in the first and second columns
# -t or -c options must be included when using command line input
# -t option prints out a presence, absences and number of appearance matrix
# -c option prints out all core orthologs, single-copy, shared protein families by the amount of given genomes

#Part 3 makes a directory at current directory for each protein family (core ortholog) 
# in each directory each fig id will 

my %opts;
getopts('tc', \%opts); # -t: print +/- matrix; -c: print single-copy core fams
my @uniq_id;
my %seen_gid;
my %seen_pgf;
my %seen_fig;
my %counts;
my $count_pgfs;
my %pgf_fig;
my %gpf;
while (<>) { # line-by-line
    chomp;
    next unless /PGF/; # skip unless the line contains PGF
    my ($gid, $pgf, $fig, @other) = split /\t/, $_;
    $seen_gid{$gid}++;
    $seen_pgf{$pgf}++;
    $counts{$gid}{$pgf}++;
    $seen_fig{$gid}++;
    $pgf_fig{$pgf}{$fig}++;
    $gpf{$pgf}{$gid} = $fig;
}

#print Dumper(\%gpf);
#print Dumper(\%seen_gid);

if ($opts{t}) {
    foreach my $gid (keys %seen_gid) { # for each row
        print $gid, "\t";
	my @cts;
        foreach my $pgf (sort keys %seen_pgf) { # for each column
	    push @cts, $counts{$gid}->{$pgf} || 0;
	}
	print join "\t", @cts;
	print "\n";
    }    
}


my %core_ortho;
if ($opts{c}) {
    foreach my $pgf (sort keys %seen_pgf) { # for each column
	my @cts;
	foreach my $gid (keys %seen_gid) { # for each row
	    push @cts, $counts{$gid}->{$pgf} || 0;
	}
	my $is_core = 1; # default is a core
	foreach my $i (@cts) {
	    $is_core = 0 if $i != 1; # negate if any item is not 1

	}
	if ($is_core) {
	    $core_ortho{$pgf}++;
	    if (exists($core_ortho{$pgf})) {
#		    print $pgf, "\n" if $is_core;
	    }
	}
    }	
}

#Part 3
foreach my $pgf (sort keys %core_ortho) { # for each column
    print "Making directory for protein global family ", $pgf, ".figs ", "\n";
    open OUT, ">" . "core_" . $pgf . ".figs"; 
	print OUT "\n";
#    print $pgf, "\n";
	print "The respective fig sequence IDs are..\n";

    foreach my $gid ( keys %{$gpf{$pgf}}){

	print $gpf{$pgf}->{$gid}, "\n";
	print OUT $pgf, "\t", $gid, "\t";

	print OUT $gpf{$pgf}->{$gid}, "\n";
#	foreach my $fig ( keys %{$gpf{$gid}}){
#	       foreach my $ne (keys %{$gpf{$gid}}	    
#	      print $fig, "\n";
	}
       #}
    close OUT;
}
exit;
=begin
foreach my $g ( keys %gpf{$pgf}){
#    foreach my $f (keys @$gpf{$g}{$gid}) {
	#print $f, "\n" if $is_core;
	my $is_core = 1; # default is a core
	foreach my $i (@cts) {
	    $is_core = 0 if $i != 1; # negate if any item is not 1
	}
	if ($is_core) {
	    $core_ortho{$pgf}++;
	    if (exists($core_ortho{$pgf})) {
		print $g, "\n" if $is_core;
#	    }	
	}
    }
}	




#foreach my $pgf (keys %pgf_fig) {

#    if (exists($core_ortho{$pgf})) {
#	foreach my $g ( keys %gpf{$pgf}){
#	foreach my $g ( $@gpf{$pgf}){
#	    print $g, "\n"; 
#	    if ($is_core) {
#		$core_ortho{$pgf}++;
#		print $g, "\n" if $is_core;	    
		
#	    }
#	    foreach my $gid (keys%counts) {
#		print $gid, "\n"; 
		
#		foreach my $fig (%{ $pgf_fig{$pgf} }) {
#		    if ($fig ne 1) {
#			print $fig, "\t";
#		    }
#		}
#
#	    }
	#}
	
#    }
#}
		print "\n";
#foreach my $pgf (keys %pgf_fig) {
#    print $pgf, "\t";
    #   foreach my $fig (keys %seen_fig) {
#	print join "\t", $fig;
#    }
 #   print  "\n";
#}


exit;

#my $num_gids = length (keys %seen_gids);
#	    next unless $i == 1;
#	    $is_unique ++;
#	if ($is_unique == $num_gids) {
