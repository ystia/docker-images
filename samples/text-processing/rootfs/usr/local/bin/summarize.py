#!/usr/bin/env python3

from summarizer import summarize
import sys

f=open(sys.argv[1], "r")
s=summarize("VH", f.read(), count=20)

for l in s:

  print(l)
