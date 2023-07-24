#!/usr/bin/perl

use my_bio;

(@ARGV != 1 and @ARGV != 2) and die "usage: $0 fasta [min_len]\n";

$min_len = $ARGV[1];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	if (length($seq) >= $min_len) {
		$total += length($seq);
		$n += ($seq =~ tr/Nn/Nn/);
	}
}
close $in;

#printf("%.2f%% (%d/%d)\n", $n / $total * 100, $n, $total);
printf("%f\n", $n / $total * 100);
