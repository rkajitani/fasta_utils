#!/usr/bin/perl

use my_bio;

(@ARGV != 1) and die "usage: $0 in.fa\n";

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	next if ($seq =~ /[a-zA-Z][^a-zA-Z]+[a-zA-Z]/);

	printf(">%s\n", $name);
	print_seq($seq, 80);
}
close $in;
