#!/usr/bin/perl

use my_bio;

(@ARGV != 4) and die "usage: $0 query.fa ref.fa min_idt min_aln_len\n";

$min_idt = $ARGV[2];
$min_aln_len = $ARGV[3];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	$scf{$name} = $seq;
}
close $in;

system "ln -s $ARGV[1] $$.ref";
system "makeblastdb -in $$.ref -out $$ -dbtype nucl >/dev/null 2>&1";
open($in, "blastn -query $ARGV[0] -db $$ -outfmt 6 -evalue 1e-5 |");
while (chomp($l = <$in>)) {
	($name, $idt, $aln_len,  $st, $ed, $score) = (split(/\t/, $l))[0, 2, 3, 8, 9, 11];

	next if ($idt < $min_idt or $aln_len < $min_aln_len);

	if ($max_score{$name} < $score) {
		$max_score{$name} = $score;
		if ($st < $ed) {
			$max_score_strand{$name} = 1;
			$max_score_pos{$name} = $st;
		}
		else {
			$max_score_strand{$name} = -1;
			$max_score_pos{$name} = $ed;
		}
	}
}
close $in;

for (keys %max_score) {
	push(@a, [$max_score_pos{$_}, $max_score_strand{$_}, $_]);
}
@b = sort {$a->[0] <=> $b->[0]} @a;

for (@b) {
	print(">", $_->[2], "\n");
	if ($_->[1] < 0) {
		$scf{$_->[2]} = reverse $scf{$_->[2]};
		$scf{$_->[2]} =~ tr/ATGC/TACG/;
	}
	print_seq($scf{$_->[2]}, 80);
}

system "rm $$*";
