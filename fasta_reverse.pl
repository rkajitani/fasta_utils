#!/usr/bin/perl

use my_bio;

open $fh, shift;
while (($name, $seq) = fasta_get($fh)) {
	$seq = reverse $seq;
	$seq =~ tr/ATGCatgc/TACGtacg/;
	print ">$name\n";
	print_seq($seq, 80);
}
