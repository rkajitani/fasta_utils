#! /usr/bin/perl

use my_bio;

(@ARGV == 2) or die "usage: $0 in.fa prefix\n";

$prefix = $ARGV[1];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	$name = ($name . '_' . $prefix);
	printf(">%s\n", $name);
	print_seq($seq, 80);
}
close $in;
