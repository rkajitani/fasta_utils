#!/usr/bin/perl

use my_bio;

open $fh, shift;
while (($name, $seq) = fasta_get($fh)) {
	$seq =~ s/^N+//;
	$seq =~ s/N+$//;
	printf(">%s\n", $name);
	print_seq($seq, 80);
}
