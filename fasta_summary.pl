#! /usr/bin/perl

if (@ARGV == 2) {
	$cut = $ARGV[1];
}
elsif (@ARGV != 1) {
	die "usage: $0 file.fa min_len\n";
}

$file = $ARGV[0];

$min = inf;

open(IN, $file) or die "cannot open\n";
$l = <IN>;
while (chomp($l = <IN>)) {
	if ($l =~ /^>/) {
		$len = length $seq;
		if ($len >= $cut) {
			push(@len_list, $len);
			$total += $len;
			$n += ($seq =~ tr/Nn/Nn/);
			if ($len > $max) {
				$max = $len;
			}
		}
		if ($len < $min) {
			$min = $len;
		}
		$seq = '';
	}
	else {
		$seq .= $l;
	}
}
$len = length $seq;
if ($len >= $cut) {
	push(@len_list, $len);
	$total += $len;
	$n += ($seq =~ tr/Nn/Nn/);
	if ($len > $max) {
		$max = $len;
	}
}
if ($len < $min) {
	$min = $len;
}

close IN;

for $len (sort{$b <=> $a} @len_list) {
	$cum += $len;
	++$n50_num;
	if ($cum >= $total/2) {
		$n50 = $len;
		last;
	}
}

$n_contig = @len_list;
$ave = (@len_list > 0) ? int($total / @len_list * 100) / 100 : 0;

#print "$file\n";
#print "LEN_CUT = $cut\n";
#print "NUM_SEQ = $n_contig\n";
#print "TOTAL   = $total\n";
#print "AVE_LEN = $ave\n";
#print "N50_LEN = $n50\n";
#print "N50_NUM = $n50_num\n";
#print "MAX     = $max\n";
#print "MIN     = $min\n";

#print(join("\t", ($n_contig, $total, $n50, $n / $total * 100, )), "\n");
#
#print(join("\t", ($total, $n_contig, $n50, $n50_num, $max, $n / $total * 100, )), "\n");
#print(join("\t", ($total, $n50, $n50_num, $n / $total * 100, )), "\n");
print(join("\t", ($total, $n50, $max, $n / $total * 100, )), "\n");
