import csv

def do_thing(surpfile,wordfile,outfile):
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


do_thing("gpt_surp.txt","words.txt","gpt_surp_trans.txt")

