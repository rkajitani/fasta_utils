#!/usr/bin/perl

use my_bio;

(@ARGV < 1) and die "usage: $0 seq1.fa seq2.fa [seq3.fa ...]\n";

for $file (@ARGV) {
	open($in, $file);
	while (($name, $seq) = fasta_nonwhite_get($in)) {
		push(@cat_names, $name);
		$cat_seq .= $seq;
	}
	close $in;
}

$cat_name = join(';', @cat_names);

printf(">$cat_name\n");
print_seq($cat_seq, 80);
