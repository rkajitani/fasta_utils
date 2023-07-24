#!/usr/bin/perl

use my_bio;

(@ARGV != 2 and @ARGV != 3) and die "usage: $0 fasta min_cov [max_cov]\n";

$min_cov = $ARGV[1];
if ($ARGV[2]) {
	$max_cov = $ARGV[2];
}
else {
	$max_cov = inf;
}
	

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	if ($name =~ /cov(\d+)/) {
		if ($1 >= $min_cov and $1 <= $max_cov) {
			print ">$name\n";
			print_seq($seq, 80);
		}
	}
}
close $in;
