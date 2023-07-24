#!/usr/bin/perl

use my_bio;

(@ARGV != 1) and die "usage: $0 seq.fa\n";

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	++$n_all;
	if ($seq =~ /^ATG/ or $seq =~ /^M/) {
		++$n_start;
	}
}
close $in;

printf("NUM_START = %d (%.3f%%)\n", $n_start, $n_start / $n_all * 100);
