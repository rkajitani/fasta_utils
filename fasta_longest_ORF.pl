#!/usr/bin/perl

%DNA_code = (
'GCT' => 'A', 'GCC' => 'A', 'GCA' => 'A', 'GCG' => 'A', 'TTA' => 'L',
'TTG' => 'L', 'CTT' => 'L', 'CTC' => 'L', 'CTA' => 'L', 'CTG' => 'L',
'CGT' => 'R', 'CGC' => 'R', 'CGA' => 'R', 'CGG' => 'R', 'AGA' => 'R',
'AGG' => 'R', 'AAA' => 'K', 'AAG' => 'K', 'AAT' => 'N', 'AAC' => 'N',
'ATG' => 'M', 'GAT' => 'D', 'GAC' => 'D', 'TTT' => 'F', 'TTC' => 'F',
'TGT' => 'C', 'TGC' => 'C', 'CCT' => 'P', 'CCC' => 'P', 'CCA' => 'P',
'CCG' => 'P', 'CAA' => 'Q', 'CAG' => 'Q', 'TCT' => 'S', 'TCC' => 'S',
'TCA' => 'S', 'TCG' => 'S', 'AGT' => 'S', 'AGC' => 'S', 'GAA' => 'E',
'GAG' => 'E', 'ACT' => 'T', 'ACC' => 'T', 'ACA' => 'T', 'ACG' => 'T',
'GGT' => 'G', 'GGC' => 'G', 'GGA' => 'G', 'GGG' => 'G', 'TGG' => 'W',
'CAT' => 'H', 'CAC' => 'H', 'TAT' => 'Y', 'TAC' => 'Y', 'ATT' => 'I',
'ATC' => 'I', 'ATA' => 'I', 'GTT' => 'V', 'GTC' => 'V', 'GTA' => 'V',
'GTG' => 'V', 'TAA' => '*', 'TAG' => '*', 'TGA' => '*');

open $in, $ARGV[0];
while (($name, $seq) = fasta_nonwhite_get($in)) {
	$longest = 0;
	for $frame (0, 1, 2) {
		$aa_seq = '';
		for ($pos = $frame; $pos + 2 < length($seq); $pos += 3) {
			if (defined $DNA_code{substr($seq, $pos, 3)}) {
				$aa = $DNA_code{substr($seq, $pos, 3)};
			}
			else {
				$aa = 'x';
			}
			$aa_seq .= $aa;
		}
#		print(">$name+" . ($frame + 1) . "\n");
#		print_seq($aa_seq, 80);

		while ($aa_seq =~ /([^*]+\**)/g) {
			if ($longest < length $1) {
				$longest = length $1;
				$longest_aa_seq = $1;
				$longest_pos = $frame + 3*length($`);
			}
		}
	}

	$seq = reverse $seq;
	$seq =~ tr/ATGC/TACG/;
	for $frame (0, 1, 2) {
		$aa_seq = '';
		for ($pos = $frame; $pos + 2 < length($seq); $pos += 3) {
			if (defined $DNA_code{substr($seq, $pos, 3)}) {
				$aa = $DNA_code{substr($seq, $pos, 3)};
			}
			else {
				$aa = 'x';
			}
			$aa_seq .= $aa;
		}
#		print(">$name\-" . ($frame + 1) . "\n");
#		print_seq($aa_seq, 80);

		while ($aa_seq =~ /([^*]+)/g) {
			if ($longest < length $1) {
				$longest = length $1;
				$longest_aa_seq = $1;
				$longest_pos = -(3*(length($`) + length($1)) - $frame - 1);
			}
		}
	}

	printf(">%s;pos=%d;len=%d\n", $name, $longest_pos, $longest);
	print_seq($longest_aa_seq, 80);
}

sub fasta_nonwhite_get
{
	my $in = shift;
	my($l, $name, $seq);

	while ($l = <$in>) {
		if ($l =~ /^>(\S*)/) {
			$name = $1;
			last;
		}
	}
	if ($l eq '') {
		return ();
	}

	while ($l = <$in>) {
		if (substr($l, 0, 1) eq '>') {
			seek($in, -length($l), 1);
			return ($name, $seq);
		}
		chomp $l;
		$seq .= $l 
	}
	return ($name, $seq);
}

sub print_seq
{
	my $seq = shift;
	my $line_len = shift;
	my $seq_len = length $seq;

	unless ($line_len) {
		$line_len = 80;
	}

	for (my $i = 0; $i < $seq_len; $i += $line_len) {
		print(substr($seq, $i, $line_len) . "\n");
	}
}
