#!/usr/bin/perl

use my_bio;

(@ARGV == 1) or die "usage: $0 fasta\n";

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	if ($seq !~ /[Nn]/) {
		printf(">%s\n", $name);
		print_seq($seq, 80);
	}
}
close $in;
