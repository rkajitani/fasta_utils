#!/usr/bin/env python

import sys
import my_bio

if len(sys.argv) != 3:
    print("usage:", sys.argv[0], "in.fasta prefix", file=sys.stderr)
    sys.exit(1)

prefix = sys.argv[2]
with open(sys.argv[1], "r") as fin:
    n = 1
    for name, seq in my_bio.read_fasta(fin):
        print(f">{prefix}{n}\n{seq}")
        n += 1
        

