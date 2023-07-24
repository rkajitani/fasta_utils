#!/usr/bin/perl

use my_bio;

(@ARGV != 2) and die "usage: $0 fasta bin_size\n";
$bin_size = $ARGV[1];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	if ($name =~ /cov(\d+)/) {
		$histo[int($1 / $bin_size)] += length $seq;
	}
}

for $i (0..$#histo) {
	printf("%f\t%d\n", $i * $bin_size, $histo[$i]);
}
