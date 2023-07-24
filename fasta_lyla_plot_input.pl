#!/usr/bin/perl

use my_bio;

(@ARGV != 1) and die "usage: $0 in.fa\n";

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	print(join("\t", ($name, 0, length($seq), '+', $name)), "\n");
}
close $in;
