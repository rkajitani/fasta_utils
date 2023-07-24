#!/usr/bin/perl

use my_bio;

(@ARGV != 3) and die "usage: $0 in.fa gap_size result_seq_name\n";

$gap_size = $ARGV[1];
$res_seq_name = $ARGV[2];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	if (length($res_seq) > 0) {
		$res_seq .= ($gap_size x 'N');
	}
	$res_seq .= $seq;
}
close $in;

printf(">%s\n", $res_seq_name);
print_seq($res_seq, 80);
