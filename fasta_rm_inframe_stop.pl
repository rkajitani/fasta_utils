#!/usr/bin/perl

use my_bio;

open $fh, shift;
while (($name, $seq) = fasta_get($fh)) {
	if (length(seq) > 2 and substr($seq, 1, length($seq) - 2) !~ /[.*]/) {
		printf(">%s\n", $name);
		print_seq($seq, 80);
	}
}
