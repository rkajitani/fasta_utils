#!/usr/bin/perl

use my_bio;

if (@ARGV != 2) {
	print_usage();
	exit;
}

open($in, $ARGV[0]) or print "cannont\n";
while (chomp($l = <$in>) or $l) {
	($name, $start, $end) = split(/\t/, $l);
	push(@pos, [$name, $start, $end]);
	$target_flag{$name} = 1;
}
close $in;

open($in, $ARGV[1]);
while (($name, $seq) = fasta_nonwhite_get($in)) {
	if ($target_flag{$name}) {
		$name2seq{$name} = $seq;
	}
}
close $in;

for $pos (@pos) {
	($name, $start, $end) = @{$pos};
	$length = $end - $start;
	printf(">%s-%d-%d\n", $name, $start, $start + $length);
	print_seq(substr($name2seq{$name}, $start, $length), 80);
}
	

sub print_usage
{
	print
<<'USAGE';
Usage: faste_substr_list.pl [OPTION]... FASTA TSV(SEQ_NAME START END)

USAGE
}
