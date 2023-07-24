#!/usr/bin/perl

use my_bio;

open $fh, shift;
while (($name, $seq) = fasta_get($fh)) {
	print ">$name\n";
	print_seq(uc($seq), 80);
}
