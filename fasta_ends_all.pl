#!/usr/bin/perl

use my_bio;

(@ARGV != 2) and die "usage: $0 in.fa end_length\n";

$end_len = $ARGV[1];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	$out_len = $end_len;
	if (length($seq) < $end_len) {
		$out_len = length($seq)
	}
	$l_end = substr($seq, 0, $end_len);
	$r_end = substr($seq, length($seq) - $end_len, $end_len);
	printf(">%s-L-%d\n", $name, $end_len);
	print_seq($l_end, 80);
	printf(">%s-R-%d\n", $name, $end_len);
	print_seq($r_end, 80);
}
close $in;
