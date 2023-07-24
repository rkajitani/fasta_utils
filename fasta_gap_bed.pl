#!/usr/bin/perl

use my_bio;

(@ARGV != 1) and die "usage: $0 fasta\n";

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	while ($seq =~ /[nN]+/g) {
		printf("%s\t%d\t%d\n", $name, length($`), length($`) + length($&));
	}
}
close $in;
