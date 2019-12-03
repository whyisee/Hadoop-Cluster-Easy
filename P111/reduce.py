#!/bin/env python

import sys

cur_word = None
sum = 0
for line in sys.stdin:
    word,cnt=line.strip().split("\t")
    if cur_word == None:
        cur_word = word
    if cur_word != word:
        print("\t".join([cur_word,str(sum)]))
        cur_word = word
        sum = 0
    sum=sum+int(cnt)
    
print('\t'.join([cur_word,str(sum)]))