# provo-maze

This is misnamed, since we're switching away from Provo to natural stories. 

All the Provo stuff is isolated in Provo (and probably has broken locations since things were moved)

Otherwise, Prep_code contains things used to calcuate surprisals, and do all the prep work. Materials has the materials that were used, Ibex has a copy of ibex-maze. 

## Contents

Analysis
- read_results.R takes the raw Ibex output and produces cleaned.rds
- nat_stories.Rmd has non-modelling analysis looking at accuracy, comprehension, participant feedback
- models.Rmd has the modelling stuff

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
