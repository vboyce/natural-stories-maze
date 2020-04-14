import nltk
import math
import json
from collections import Counter

with open('gulo_train.txt', 'r') as file:
    data = file.read()

tokens = nltk.word_tokenize(data)
length = len(tokens)
print(length)

c=Counter(tokens)

logprobs={}
for t,count in c.items():
    logprobs[t]=math.log2(count)-math.log2(length)+math.log2(10**9)

with open('freqs.txt','w') as f:
    json.dump(logprobs, f)