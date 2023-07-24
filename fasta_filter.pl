#!/usr/bin/perl

(@ARGV != 2) and die "usage: $0 fasta list\n";

use lib qw(/data/kajitani/lib/perl5);
use my_bio;

open IN, $ARGV[1];
while (<IN>) {
	chomp;
	$is_target{$_} = 1;
}
close IN;

open $in, $ARGV[0];
while (($name, $seq) = fasta_get($in)) {
	$name =~ /^(\S*)/;
	$name = $1;
	if ($is_target{$name}) {
		print ">$name\n";
		print_seq($seq, 80);
	}
}
