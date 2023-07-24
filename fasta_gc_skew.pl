#!/usr/bin/perl

use my_bio;

(@ARGV != 1 and @ARGV != 2) and die "usage: $0 fasta [window_size]\n";

if ($ARGV[1]) {
	$wsize = $ARGV[1];
}
else {
	$wsize = 1000;
}


open($in, $ARGV[0]);
$s = '';
while (($name, $seq) = fasta_get($in)) {
	$s .= $seq;
}
close $in;

for ($i = 0; $i < length($s); $i += $wsize) {
	$g = (substr($s, $i, $wsize) =~ tr/Gg/Gg/);
	$c = (substr($s, $i, $wsize) =~ tr/Cc/Cc/);
	if ($g + $c != 0) {
		printf("%d\t%f\n", $i + $wsize/2, ($g - $c) / ($g + $c));
	}
}
