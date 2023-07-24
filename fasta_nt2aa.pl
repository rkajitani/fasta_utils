#!/usr/bin/perl

use my_bio;

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	$seq = nt2aa($seq);
	print ">$name\n";
	print_seq($seq, 80);
}
close $in;
