#! /usr/bin/perl

(@ARGV != 3) and die "usage: $0 in.fasta genome_size(bp) min_len(bp)\n";

$file = $ARGV[0];
$genome_size = $ARGV[1];
$cut = $ARGV[2];


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

			for $con (split(/[Nn]+/, $seq)) {
				$con_len = length $con;
				push(@con_len_list, $con_len);
				$con_total += $con_len;
				if ($con_len > $con_max) {
					$con_max = $con_len;
				}
				if ($con_len < $con_min) {
					$con_min = $con_len;
				}
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

	for $con (split(/[Nn]+/, $seq)) {
		$con_len = length $con;
		push(@con_len_list, $con_len);
		$con_total += $con_len;
		if ($con_len > $con_max) {
			$con_max = $con_len;
		}
		if ($con_len < $con_min) {
			$con_min = $con_len;
		}
	}
}
if ($len < $min) {
	$min = $len;
}

close IN;

for $len (sort{$b <=> $a} @len_list) {
	$cum += $len;
	++$n50_num;
	if ($cum >= $genome_size/2) {
		$n50 = $len;
		last;
	}
}
$n_seq = @len_list;
$ave = (@len_list > 0) ? int($total / @len_list * 100) / 100 : 0;

$cum = 0;
for $len (sort{$b <=> $a} @con_len_list) {
	$cum += $len;
	++$con_n50_num;
	if ($cum >= $genome_size/2) {
		$con_n50 = $len;
		last;
	}
}
$n_con = @con_len_list;
$con_ave = (@con_len_list > 0) ? int($con_total / @con_len_list * 100) / 100 : 0;

#print "$file\n";
#print "LEN_CUT = $cut\n";
#print "NUM_SEQ = $n_seq\n";
#print "TOTAL   = $total\n";
#print "AVE_LEN = $ave\n";
#print "N50_LEN = $n50\n";
#print "N50_NUM = $n50_num\n";
#print "MAX     = $max\n";
#print "MIN     = $min\n";

#print(join("\t", ($n_seq, $total, $n50, $n / $total * 100, )), "\n");
#print(join("\t", ($total, $n_seq, $n50, $n50_num, $max, $n / $total * 100, )), "\n");

print(join("\t", ($total + 0, $n50 + 0, $n50_num + 0, $con_n50 + 0, $con_n50_num + 0, $n / $total * 100, )), "\n");
