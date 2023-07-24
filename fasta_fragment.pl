#!/usr/bin/perl

use my_bio;

(@ARGV != 2) and die "usage: $0 in.fa frag_len\n"; 

$frag_len = $ARGV[1];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	for ($i = 0; $i <= length($seq) - $frag_len; $i += $frag_len) {
		if (substr($seq, $i, $frag_len) !~ /[nN]/) {
#			printf(">%s_%d\n%s\n", $name, $i, substr($seq, $i, $frag_len));
			printf(">%s_%d\n%s\n", $name, $i, uc(substr($seq, $i, $frag_len)));
		}
	}
}
close $in;
