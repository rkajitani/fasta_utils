#!/usr/bin/perl

use my_bio;

(@ARGV == 0) and die "usage: $0 in1.fa [in2.fa ...]\n";

for $file (@ARGV) {
	open($in, $file);
	while (($name, $seq) = fasta_get($in)) {
		if ($name =~ /cov(\d+)/) {
			$sum += $1 * length($seq);
			$num += length($seq);
		}
	}
	close $in;
}

print($sum / $num, "\n");
