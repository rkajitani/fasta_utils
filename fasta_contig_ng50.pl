#! /usr/bin/perl

if (@ARGV != 3) {
	die "usage: $0 file.fa genome_size min_N_len\n";
}

$file = $ARGV[0];
$total = $ARGV[1];
$N_len = $ARGV[2];

$min = inf;

open(IN, $file) or die "cannot open $file\n";
$l = <IN>;
while (chomp($l = <IN>)) {
	if ($l =~ /^>/) {
		for $con (split(/[Nn]{$N_len,}+/, $seq)) {
			$len = length $con;
			push(@len_list, $len);
			if ($len > $max) {
				$max = $len;
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
for $con (split(/[Nn]{$N_len,}/, $seq)) {
	$len = length $seq;
	push(@len_list, $len);
	if ($len > $max) {
		$max = $len;
	}
	if ($len < $min) {
		$min = $len;
	}
}
close IN;

$n50 = 0;
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

#print("$file\nLEN_CUTOFF = $cut\nNUM_CONTIG = $n_contig\nTOTAL = $total\nAVE = $ave\nNG50 = $n50\nNG50_NUM = $n50_num\nMAX = $max\nMIN = $min\n");
#print("NG50_LEN = $n50\nNG50_NUM = $n50_num\n");
print("$n50\t$n50_num\n");
