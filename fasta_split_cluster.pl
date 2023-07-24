#!/usr/bin/perl

use my_bio;

open($in, $ARGV[0]);
while (($name, $seq) = fasta_get($in)) {
	if ($name =~ /cluster(\d+)/) {
		push(@{$names[$1]}, $name);
		push(@{$seqs[$1]}, $seq);
	}
	else {
		push(@{$names[0]}, $name);
		push(@{$seqs[$0]}, $seq);
	}
}
close $in;

mkdir 'clusters';
for $i (0..$#names) {
	if ($i == 0) {
		open($out, ">clusters/unclassified.fa");
	}
	else {
		open($out, ">clusters/cluster$i.fa");
	}
	
	for $j (0..(@{$names[$i]} - 1)) {
		printf($out ">%s\n", $names[$i][$j]);
		print_scf($out, $seqs[$i][$j], 80);
	}

	close $out;
}

sub print_scf
{
	my $out = shift;
	my $seq = shift;
	my $line_len = shift;
	my $seq_len = length $seq;

	unless ($line_len) {
		$line_len = 80;
	}

	for (my $i = 0; $i < $seq_len; $i += $line_len) {
		print($out substr($seq, $i, $line_len) . "\n");
	}
}
