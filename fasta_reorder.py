#!/usr/bin/env python

import sys
import my_bio

if len(sys.argv) != 3:
    print("usage:", sys.argv[0], "in.fasta order.txt", file=sys.stderr)
    sys.exit(1)

name_list = list()
name_set = set()
with open(sys.argv[2], "r") as fin:
    for ln in fin:
        name = ln.rstrip("\n")
        name_list.append(name)
        name_set.add(name)

seq_dict = dict()
with open(sys.argv[1], "r") as fin:
    for name, seq in my_bio.read_fasta(fin):
        if name in name_set:
            seq_dict[name] = seq

for name in name_list:
    if name in seq_dict:
        print(f">{name}")
        my_bio.print_folded(seq_dict[name], 80)
