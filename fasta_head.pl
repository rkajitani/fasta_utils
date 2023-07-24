#!/usr/bin/perl

use my_bio;

(@ARGV != 2) and die "usage: $0 seq.fa num_seq\n";

$n_seq = $ARGV[1];

$i = 0;
open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	print ">$name\n";
	$seq =~ s/\/\/$/\n\/\//;
	print_seq($seq, 80);
	++$i;
	if ($i >= $n_seq) {
		exit;
	}
}
close $in;
