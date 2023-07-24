#!/usr/bin/perl

use my_bio;

open $fh, shift;
while (($name, $seq) = fasta_nonwhite_get($fh)) {
	print ">$name\n";
	print_seq($seq, 80);

	$seq = reverse $seq;
	$seq =~ tr/ATGCatgc/TACGtacg/;
	print ">${name}_reverse\n";
	print_seq($seq, 80);
}
