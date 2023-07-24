#! /usr/bin/perl

(@ARGV != 2) and die "usage: $0 file.fa genome_size\n";

$total = $ARGV[1];
$file = $ARGV[0];

open(IN, $file) or die "cannot open $file\n";
$l = <IN>;
while (chomp($l = <IN>)) {
	if ($l =~ /^>/) {
		$len = length $seq;
		push(@len_list, $len);
		$seq = '';
	}
	else {
		$seq .= $l;
	}
}
$len = length $seq;
push(@len_list, $len);

close IN;

$ng50 = 0;
for $len (sort{$b <=> $a} @len_list) {
	$cum += $len;
	++$ng50_num;
	if ($cum >= $total/2) {
		$ng50 = $len;
		last;
	}
}

#print("NG50_LEN = $ng50\nNG50_NUM = $ng50_num\n");
print(join("\t", ($ng50, $ng50_num)), "\n");
