#!/usr/bin/perl

use my_bio;

(@ARGV != 2) and die "usage: $0 seq.fa around_length\n";

$around_len = $ARGV[1];

open($in, $ARGV[0]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	while ($seq =~ /N+/g) {
		$gap_st = length($`);
		$gap_len = length($&);

		printf(">%s_st%d_ed%d\n", $name, $gap_st - $around_len, $gap_st + $gap_len + $around_len);
		print substr($seq, $gap_st - $around_len, $gap_len + 2 * $around_len);
		print "\n";
		++$i;
	}
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
