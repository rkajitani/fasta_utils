#!/usr/bin/perl

use my_bio;

(@ARGV != 3) and die "usage: $0 target.fa query.fa blat_filtered.psl\n";

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	$target{$name} = $seq;
	push(@target_name_order, $name);
}
close $in;

open($in, $ARGV[1]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	$query{$name} = $seq;
}
close $in;

open($in, $ARGV[2]);
while (chomp($l = <$in>)) {
	($strand, $q_name, $q_st, $q_end, $t_name, $t_st, $t_ed) = (split(/\t/, $l))[8, 9, 11, 12, 13, 15, 16];
	push(@{$aln{$t_name}}, {
		strand => $strand,
		q_name => $q_name,
		q_st => $q_st,
		q_ed => $q_end,
		t_st => $t_st,
		t_ed => $t_ed,
	});
}
close $in;

for $t_name (keys %aln) {
	for $aln (sort{$b->{t_st} <=> $a->{t_st}} @{$aln{$t_name}}) {
		$new_seq = substr($query{$aln->{q_name}}, $aln->{q_st}, $aln->{q_ed} - $aln->{q_st});
		if ($aln->{strand} eq '-') {
			$new_seq = rev_comp($new_seq);
		}
		substr($target{$t_name}, $aln->{t_st}, $aln->{t_ed} - $aln->{t_st}, $new_seq);
	}
}

for $t_name (@target_name_order) {
	printf(">%s\n", $t_name);
	print_seq($target{$t_name}, 80);
}
