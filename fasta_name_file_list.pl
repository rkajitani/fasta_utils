#!/usr/bin/perl

use my_bio;

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	print(join("\t", ($name, $ARGV[0])), "\n");
}
close $in;
