# natural-stories-maze

This contains the materials, data, code, and write-ups associated with the Natural Stories Maze paper. 


## Contents

Analysis
- read_results.R takes the in Data/raw_data and produces Data/cleaned.rds
- nat_stories.Rmd has non-modelling analysis looking at accuracy, comprehension, participant feedback; takes in Data/cleaned.rds and produces Analysis/models/comp.rds
- models.Rmd has the modelling stuff
- models/ has saved summaries of models and other pre-processed data objects for inclusion in the paper (paper should build without needing to run any of the models oneself)


Data
- raw_data
- cleaned.rds (generated by ???)
- SPR (contains raw data from Futrell et al)

Materials

Ibex
 
Prep_code
 - nat_stories_prep.Rmd - takes raw Natural Stories materials and processes it for labels, Maze and model surprisals; also takes in tokenizations and surprisal and makes a nice table of them
 - useful.py manages formatting for before and after running surprisals (Note: ngram, txl and grnn were run on a cluster with a precursor to lm-zoo. GPT was run with lm-zoo. For replicating/altering, I recommend using lm-zoo. New things to translate between tokenizations. TXL is not currently on lm-zoo)
 - other files are inputs/outputs of these
 

Papers [ TBD, giant mess ] 
