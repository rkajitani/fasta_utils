#! /usr/bin/perl

use my_bio;

(@ARGV == 1) or die "usage: $0 fasta\n";

open($in, $ARGV[0]) or die "cannot open\n";
$max = 0;
while (($name, $seq) = fasta_nonwhite_get($in)) {
	if (length($seq) > $max) {
		$max = length($seq);
		@max_seq = ([$name, $seq]);
	}
	elsif (length($seq) == $max) {
		push(@max_seq, [$name, $seq]);
	}
}
close $in;

for (@max_seq) {
	printf(">%s\n", $_->[0]);
	print_seq($_->[1], 80);
}	
