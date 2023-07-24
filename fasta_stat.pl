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
while (chomp($l = <IN>) or $l) {
	if ($l =~ /^>/) {
		$len = length $seq;
		if ($len >= $cut) {
			push(@len_list, $len);
			$total += $len;
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
	if ($len > $max) {
		$max = $len;
	}
}
if ($len < $min) {
	$min = $len;
}

close IN;

$num = $cum = 0;
for $len (sort{$b <=> $a} @len_list) {
	++$num;
	$cum += $len;

	if ($cum >= $total * 0.5 and not defined $n50) {
		$n50 = $len;
		$n50_num = $num;
	}

	if ($cum >= $total * 0.9 and not defined $n90) {
		$n90 = $len;
		$n90_num = $num;
		last;
	}
}


$n_contig = @len_list;
$ave = (@len_list > 0) ? int($total / @len_list * 100) / 100 : 0;

print "$file\n";
print "LEN_CUT = $cut\n";
print "NUM_SEQ = $n_contig\n";
print "TOTAL   = $total\n";
print "AVE_LEN = $ave\n";
print "MAX     = $max\n";
print "MIN     = $min\n";
print "\n";
print "N50_LEN = $n50\n";
print "N50_NUM = $n50_num\n";
print "\n";
print "N90_LEN = $n90\n";
print "N90_NUM = $n90_num\n";

print "\n";
print(join(" ", ($total, $n50, $n50_num)), "\n");
