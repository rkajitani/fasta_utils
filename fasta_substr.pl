#!/usr/bin/perl

use Getopt::Long;

%opt = ();
GetOptions(\%opt, qw/l x/);

if (@ARGV != 4 or exists $opt{help}) {
	print_usage();
	exit;
}

$target_name = $ARGV[1];
$start = $ARGV[2];
if ($start < 0) {
	$start = 0;
}

if (exists $opt{l}) {
	$length = $ARGV[3];
}
else {
	$length = $ARGV[3] - $start;
}
	
open($in, $ARGV[0]) or die "Error: cannot open $ARGV[0]";
if (exists $opt{x}) {
	while (($name, $seq) = fasta_nonwhite_get($in)) {
		if ($name eq $target_name) {
			if ($start + $length > length($seq)) {
				$length = length($seq) - $start;
			}
			printf(">%s-%d-%d\n", $name, $start, $start + $length);
			print_seq(substr($seq, $start, $length), 80);
			last;
		}
	}
}
else {
	while (($name, $seq) = fasta_nonwhite_get($in)) {
		if ($name =~ /$target_name/) {
			if ($start + $length > length($seq)) {
				$length = length($seq) - $start;
			}
			printf(">%s-%d-%d\n", $name, $start, $start + $length);
			print_seq(substr($seq, $start, $length), 80);
			last;
		}
	}
}
close $in;


sub print_usage
{
	print
<<'USAGE';
Usage: faste_substr.pl [OPTION]... FASTA SEQ_NAME START END

Options:
  -x   exact match (SEQ_NAME)
  -l   END is used as SEQ_LENGTH 

USAGE
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
