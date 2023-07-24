#!/usr/bin/perl

use IO::File;

(@ARGV != 2) and die "usage: $0 fasta num_file\n";

$in_file = $ARGV[0];
$n_file = $ARGV[1];

for (0..($n_file - 1)) {
	$i = $_ + 1;
	$out[$_] = IO::File->new(">$in_file.$i");
}

open($in, $in_file);
$i = 0;
while (($name, $seq) = fasta_get($in)) {
	 $out[$i]->print(">$name\n$seq\n");
	$i = ($i + 1) % $n_file;
}

for (0..($n_file - 1)) {
	$out[$_]->close;
}



sub fasta_get
{
	my $in = shift;
	my($l, $name, $seq);

	while ($l = <$in>) {
		if (substr($l, 0, 1) eq '>') {
			chomp $l;
			last;
		}
	}
	if ($l eq '') {
		return ();
	}

	$name = substr($l, 1);

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
