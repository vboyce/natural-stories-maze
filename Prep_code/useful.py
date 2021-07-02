import json
import math
from nltk.tokenize import word_tokenize
from mosestokenizer import MosesTokenizer
import csv


def strip_punct(word):
    '''take a word, return word with start and end punctuation removed'''
    for i in range(len(word)):
        if word[i].isalnum():
            break
    for j in range(len(word) - 1, -1, -1):
        if word[j].isalnum():
            break
    word = word[i:j + 1]
    return word

def get_freq(infile, outfile):
    """Writes the frequencies (in log2 occurances/billion) of the words
    word is stripped of front and back punctuation first
    sensitive to capitalization
    returns 0 for unknown words
    input format: pre-maze
    length is calculated on stripped word, in characters
    output format: label, word_no, word, freq, length"""
    with open('freqs.txt') as freqfile:
        freqs = json.load(freqfile)
    with open(infile, 'r', newline="") as f:
        reader = csv.reader(f, delimiter=";")
        with open(outfile, 'w') as out:
            outwriter = csv.writer(out, delimiter="\t")
            for row in reader:
                words = row[2].split()
                for i in range(len(words)):
                    stripped = strip_punct(words[i])
                    freq = freqs.get(stripped, 0)
                    length = len(stripped)
                    outwriter.writerow([row[0], i, words[i], freq, length])


def to_ibex(infile, outfile):
    """Infile is as written by maze with delim formatting
    outputs as a set of json lists for using in maze script with pull"""
    with open(infile, 'r', newline="") as f:
        reader = csv.reader(f, delimiter=";")
        with open(outfile, 'w') as out:
            for row in reader:
                item, sent = row[0].split("_")
                out.write("[" + item + ",")
                out.write(sent + ', "')
                out.write(row[2] + '", "')
                out.write(row[3] + '"],\n')


def tokenize(word):
    """splits off each character of start and end punctuation, and uses word_tokenize on the middle part"""
    tokens = []
    end_tokens = []
    for i in range(len(word)):
        if word[i].isalnum():
            break
        else:
            tokens.append(word[i])
    for j in range(len(word) - 1, -1, -1):
        if word[j].isalnum():
            break
        else:
            end_tokens.append(word[j])
    end_tokens.reverse()
    word = word[i:j + 1]
    word_tokens = word_tokenize(word)
    tokens.extend(word_tokens)
    tokens.extend(end_tokens)
    return tokens


def moses_tokenize(word):
    """Uses Moses tokenizer"""
    moses = MosesTokenizer('en')
    return moses(word)


def tokenize_file(infile, outfile, translate_file, lower=False, eos=True, moses=False):
    """Assumes infile has semi-colon delimited with relevant sentence as col 3"""
    with open(infile, 'r', newline="") as f:
        reader = csv.reader(f, delimiter=";")
        with open(outfile, 'w') as out:
            with open(translate_file, 'w') as t:
                twriter = csv.writer(t, delimiter="\t")
                for row in reader:
                    tokens = []
                    words = row[2].split()
                    for i in range(len(words)):
                        if lower:
                            new_word = words[i].lower()
                        else:
                            new_word = words[i]
                        if moses:
                            word_tokens = moses_tokenize(new_word)
                        else:
                            word_tokens = tokenize(new_word)
                        for token in word_tokens:
                            twriter.writerow([row[0], i, words[i], token])
                        tokens.extend(word_tokens)
                    sent = " ".join(tokens)
                    if eos:
                        out.write(sent + " <eos>\n")
                    else:
                        out.write(sent + "\n")

def wrangle_gpt(surpfile,wordfile,outfile):
    words=[]
    story_num=[]
    sentence_num=[]
    word_in_sentence_num=[]
    word_in_story_num=[]
    with open(wordfile, 'r') as f:
        reader = csv.reader(f, delimiter="\t")
        next(reader,None)
        for row in reader:
            story_num.append(row[0])
            sentence_num.append(row[1])
            word_in_sentence_num.append(row[2])
            words.append(row[3])
            word_in_story_num.append(row[4])
    with open(surpfile, 'r', newline="") as f:
        reader = csv.reader(f, delimiter="\t")
        with open(outfile, 'w') as out:
                writer = csv.writer(out, delimiter="\t")
                i=0
                word=words[i]
                token_str=""
                next(reader,None)
                for row in reader:
                    if(token_str==word):
                        i+=1
                        word=words[i]
                        token_str=""
                    if(len(token_str)>len(word)):
                        print(token_str)
                        print(word)
                        raise AssertionError
                    token=row[2].replace("Ġ","")
                    token_str+=token
                    writer.writerow([story_num[i],sentence_num[i],word_in_sentence_num[i],word_in_story_num[i],word, token,row[3]])


wrangle_gpt("predictors/gpt_surp.txt","words.txt","predictors/gpt_surp_trans.txt")
tokenize_file("ns_pre_maze.txt", "predictors/ns_lower_tokens.txt", "ns_lower_trans.txt", lower=True, eos=False)
tokenize_file("ns_pre_maze.txt", "predictors/ns_tokens.txt", "ns_tokens_trans.txt")
tokenize_file("ns_pre_maze.txt", "predictors/ns_tokens_moses.txt","predictors/ns_tokens_moses_trans.txt", moses=True)
get_freq("ns_pre_maze.txt","predictors/ns_freq.txt")
