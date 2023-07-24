#!/usr/bin/perl

use my_bio;

(@ARGV != 1 and @ARGV != 2) and die "usage: $0 fasta [min_len]\n";

$min_len = $ARGV[1];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	if (length($seq) >= $min_len) {
		$gc += ($seq =~ tr/gcGC/gcGC/);
		$at += ($seq =~ tr/atAT/atAT/);
	}
}
close $in;

printf("%.2f%% (%d/%d)\n", $gc / ($gc + $at) * 100, $gc, $gc + $at);
