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
			for $con (split(/[Nn]+/, $seq)) {
				$len = length $con;
				push(@len_list, $len);
				$total += $len;
				if ($len > $max) {
					$max = $len;
				}
			}
			if ($len < $min) {
				$min = $len;
			}
		}
		$seq = '';
	}
	else {
		$seq .= $l;
	}
}
$len = length $seq;
if ($len >= $cut) {
	for $con (split(/[Nn]+/, $seq)) {
		$len = length $con;
		push(@len_list, $len);
		$total += $len;
		if ($len > $max) {
			$max = $len;
		}
		if ($len < $min) {
			$min = $len;
		}
	}
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

print("$file\nLEN_CUTOFF = $cut\nNUM_CONTIG = $n_contig\nTOTAL = $total\nAVE = $ave\nN50 = $n50\nN50_NUM = $n50_num\nMAX = $max\nMIN = $min\n");
#print("\n$title\nNUM = $n_contig\nTOTAL = $total\nAVE = $ave\nN50 = $n50\nLONGEST = $max\n");
