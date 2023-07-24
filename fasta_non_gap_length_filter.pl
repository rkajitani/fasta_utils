#! /usr/bin/perl

(@ARGV == 2) or die "usage: $0 fasta length\n";

open(FASTA, $ARGV[0]) or die "cannot open\n";
$len = $ARGV[1];

while (chomp($l = <FASTA>)) {
	if ($l =~ /^>/) {
		$gap_size = ($seq =~ tr/NnXx*/NnXx*/);
		if ((length($seq) - $gap_size) >= $len) {
			print "$name\n";
			for ($i = 0; $i < length $seq; $i += 80) {
				print(substr($seq, $i, 80) . "\n");
			}
		}
		$seq = '';
		$name = $l;
	}
	else {
		$seq .= $l;
	}
}
if (length($seq) >= $len) {
	print "$name\n";
	for ($i = 0; $i < length $seq; $i += 80) {
		print(substr($seq, $i, 80) . "\n");
	}
}
