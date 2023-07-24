#!/usr/bin/perl

use my_bio;

(@ARGV != 2) and die "usage: $0 ref.fa substr_pos.tsv\n";

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	$ref{$name} = $seq;
}
close $in;

open($in, $ARGV[1]);
while (chomp($l = <$in>)) {
	($name, $st, $ed, $strand) = split(/\t/, $l);
	push(@final_names, join('-', ($name, $st, $ed, $strand)));
	if ($strand eq '+') {
		$final_seq .= substr($ref{$name}, $st, $ed - $st);
	}
	else {
		$final_seq .= rev_comp(substr($ref{$name}, $st, $ed - $st));
	}
}
close $in;

print('>', join(';', @final_names), "\n");
print_seq($final_seq, 80);
