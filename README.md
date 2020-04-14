# provo-maze

This is misnamed, since we're switching away from Provo to natural stories. 

All the Provo stuff is isolated in Provo (and probably has broken locations since things were moved)

Otherwise, Prep_code contains things used to calcuate surprisals, and do all the prep work. Materials has the materials that were used, Ibex has a copy of ibex-maze. 

## Contents

Analysis
 - read_results.R reads in results
 - nat_stories.Rmd does qualitative looks at the data
 - To be added linear models, etc
 
Data
 - raw_data
 - cleaned.rds
 
Materials
 - practice_post_maze.txt - practice items + distractors
 - practice.txt - practice items + questions
 - natural_stories_sentences.tsv - sentence formatting of natural stories
 - ibex_questions.txt - natural stories questions ready for ibex
 - for_ibex.txt - natural stories with distractors
 - for_ns.js - experiment file as run
 
Prep_code
 - make_unigrams.py - calculates unigram frequencies from gulordava corpus
 - useful.py - python functions for getting frequencies, tokenizing, and interfacing with surprisal formatting
 - nat_stories_prep.Rmd - R for shepherding the assorted data sources and getting pre-maze stuff ready
 - nat_stories_surprisals.rds - data file with surprisal, freqs, etc. (end result of this prep process)
 - grnn_out_all.txt, ngram_out_all.txt, txl_out_all.txt - outputs of language models 
 - ns_freq.txt - frequency,length output

 
