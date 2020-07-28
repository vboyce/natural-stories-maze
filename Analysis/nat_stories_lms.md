Natural Stories LM analysis
================

    ## `summarise()` ungrouping output (override with `.groups` argument)

# Overview

100 participants read naturalistic stories from the natural stories
corpus. Each participant read 1 story.

We exclude

  - participants who do not report English as a native language (95
    remaining)
  - participants who do not get 80% of the words correct (63 remaining)
  - practice items (64714 words remaining)
  - words that were wrong or were within two after a mistake (58388
    words remaining)
  - the first word of every sentence (didn’t have a real distractor, RT
    is measured slightly differently) (55458 words remaining)
  - words with RTs \<100 or \>5000 (\<100 we think is likely a recording
    error, or at least not reading the words at all, \>5000 is likely
    getting distracted) (55384 words remaining)

Within the filtered data, each story was read between 3 and 8 times, for
an average of 6.3.

We also do the analyses on only the words before mistakes (per sentence)
(40809 words)

From the modelling side: (After attempts without doing this filtering)
we only include words which are single token and known words in each of
the models vocabularies. We also only include words with frequencies.
This is roughly equivalent to excluding words with punctuation.

We use as predictors:

  - length in characters of stripped word
  - unigram frequency of word. Frequencies for words are calculated
    using word\_tokenize on the gulordava train data and counting up
    instances. (This tends to tokenize off punctuation, but is
    capitalization sensitive). Frequencies are represented as log2 of
    the expected occurances in 1 billion words.

Surprisals are measured in bits.

  - ngram (5-gram KN smoothed)
  - GRNN
  - Transformer-XL

We center the predictors for the brms models, but don’t rescale them.

The model formula we use is rt ~ surp\* length + freq \* length +
past\_surp \* past\_length + past\_freq \* past\_length.

    ## Parsed with column specification:
    ## cols(
    ##   Story_Num = col_double(),
    ##   Sentence_Num = col_double(),
    ##   Sentence = col_character()
    ## )

    ## Joining, by = c("Story_Num", "Sentence_Num")

    ## # A tibble: 20 x 2
    ##    name                 value
    ##    <chr>                <dbl>
    ##  1 freq_max         25.5     
    ##  2 freq_mean        19.5     
    ##  3 freq_min          8.84    
    ##  4 freq_stdev        4.07    
    ##  5 grnn_surp_max    35.6     
    ##  6 grnn_surp_mean    6.76    
    ##  7 grnn_surp_min     0.00127 
    ##  8 grnn_surp_stdev   4.49    
    ##  9 length_max       15       
    ## 10 length_mean       4.08    
    ## 11 length_min        1       
    ## 12 length_stdev      2.05    
    ## 13 ngram_surp_max   23.5     
    ## 14 ngram_surp_mean   9.26    
    ## 15 ngram_surp_min    0.0159  
    ## 16 ngram_surp_stdev  4.85    
    ## 17 txl_surp_max     28.1     
    ## 18 txl_surp_mean     7.26    
    ## 19 txl_surp_min      0.000385
    ## 20 txl_surp_stdev    4.69

## BRM models

We include a by-subject effect for everything, and a by\_word random
intercept (full mixed effects).

Priors:

  - normal(1000,1000) for intercept – we think RTs are about 1 second
    usually
  - normal(0,500) for beta and sd – we don’t really know what effects
    are
  - lkj(1) for correlations – we don’t have reason to think correlations
    might go any particular
    way

### On pre-error data only

    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## % latex table generated in R 4.0.2 by xtable 1.8-4 package
    ## % Tue Jul 28 14:25:11 2020
    ## \begin{table}[ht]
    ## \centering
    ## \begin{tabular}{lrlrrlrrlr}
    ##   \hline
    ## Term & E\_5-gram & CI\_5-gram & P\_5-gram & E\_GRNN & CI\_GRNN & P\_GRNN & E\_TXL & CI\_TXL & P\_TXL \\ 
    ##   \hline
    ## freq\_center & -2.9 & [-6.3, 0.5] & 0.10 & 2.9 & [-0.2, 6] & 0.06 & 0.4 & [-2.7, 3.5] & 0.79 \\ 
    ##   Intercept & 865.3 & [829.9, 902.9] & 0.00 & 871.1 & [837.9, 905.3] & 0.00 & 870.8 & [832.5, 907.8] & 0.00 \\ 
    ##   length\_center & 20.5 & [15.4, 25.6] & 0.00 & 18.5 & [13.3, 23.7] & 0.00 & 21.4 & [16.2, 26.6] & 0.00 \\ 
    ##   length\_center:freq\_center & -1.0 & [-2.5, 0.4] & 0.16 & -0.1 & [-1.2, 1] & 0.82 & 0.2 & [-0.9, 1.2] & 0.76 \\ 
    ##   past\_c\_freq & 2.6 & [-0.1, 5.4] & 0.06 & 1.9 & [-0.2, 4.2] & 0.08 & 1.2 & [-1.1, 3.6] & 0.30 \\ 
    ##   past\_c\_length & -4.8 & [-9, -0.1] & 0.04 & -6.6 & [-10.9, -2.1] & 0.00 & -5.2 & [-9.3, -0.7] & 0.03 \\ 
    ##   past\_c\_length:past\_c\_freq & -1.0 & [-2.3, 0.3] & 0.15 & -1.8 & [-2.9, -0.8] & 0.00 & -1.5 & [-2.6, -0.5] & 0.01 \\ 
    ##   past\_c\_surp & 1.6 & [-0.5, 3.6] & 0.14 & 2.7 & [0.8, 4.5] & 0.00 & 0.8 & [-0.9, 2.5] & 0.40 \\ 
    ##   past\_c\_surp:past\_c\_length & -0.2 & [-1.2, 0.8] & 0.72 & -0.9 & [-1.7, -0.2] & 0.01 & -0.6 & [-1.3, 0.2] & 0.13 \\ 
    ##   surp\_center & 11.7 & [9.3, 14.1] & 0.00 & 23.7 & [21, 26.5] & 0.00 & 18.5 & [16.1, 21.1] & 0.00 \\ 
    ##   surp\_center:length\_center & -2.0 & [-3, -1] & 0.00 & -1.8 & [-2.7, -0.9] & 0.00 & -1.4 & [-2.2, -0.6] & 0.00 \\ 
    ##    \hline
    ## \end{tabular}
    ## \end{table}

### On post-error as well

### Summaries

## Log likelihoods

I get 9.087e-32 for Ngram, 3.602e-32 for GRNN, and 2.24e-33 for TXL. I’m
not sure this is the order we expect, and not sure how to interpret it.
(Also not sure I did things
    right.)

# Frequentist LMs

    ## `summarise()` regrouping output by 'word', 'txl_center', 'ngram_center', 'grnn_center', 'freq_center', 'length_center', 'past_c_txl', 'past_c_ngram', 'past_c_grnn', 'past_c_freq', 'past_c_length' (override with `.groups` argument)

## Models

We want to be able to do nested model comparision, so we want models
with - only length, frequency fx - each 1 surprisal model as predictor -
all the surprisals

For now, no interactions between surprisal and others, and if we include
a predictor, include both current and lagged of it.

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## txl_only: mean_rt ~ txl_center + past_c_txl + freq_center * length_center + 
    ## txl_only:     past_c_freq * past_c_length + (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##          npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## txl_only   11 87870 87945 -43924    87848                         
    ## all_surp   15 87661 87762 -43815    87631 217.72  4  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## grnn_only: mean_rt ~ grnn_center + past_c_grnn + freq_center * length_center + 
    ## grnn_only:     past_c_freq * past_c_length + (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##           npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)   
    ## grnn_only   11 87669 87743 -43823    87647                        
    ## all_surp    15 87661 87762 -43815    87631 16.202  4    0.00276 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## ngram_only: mean_rt ~ ngram_center + past_c_ngram + freq_center * length_center + 
    ## ngram_only:     past_c_freq * past_c_length + (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##            npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## ngram_only   11 88171 88245 -44074    88149                         
    ## all_surp     15 87661 87762 -43815    87631 518.31  4  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## no_surp: mean_rt ~ freq_center * length_center + past_c_freq * past_c_length + 
    ## no_surp:     (1 | word)
    ## txl_only: mean_rt ~ txl_center + past_c_txl + freq_center * length_center + 
    ## txl_only:     past_c_freq * past_c_length + (1 | word)
    ##          npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## no_surp     9 88294 88355 -44138    88276                         
    ## txl_only   11 87870 87945 -43924    87848 427.92  2  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## no_surp: mean_rt ~ freq_center * length_center + past_c_freq * past_c_length + 
    ## no_surp:     (1 | word)
    ## grnn_only: mean_rt ~ grnn_center + past_c_grnn + freq_center * length_center + 
    ## grnn_only:     past_c_freq * past_c_length + (1 | word)
    ##           npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## no_surp      9 88294 88355 -44138    88276                         
    ## grnn_only   11 87669 87743 -43823    87647 629.44  2  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## no_surp: mean_rt ~ freq_center * length_center + past_c_freq * past_c_length + 
    ## no_surp:     (1 | word)
    ## ngram_only: mean_rt ~ ngram_center + past_c_ngram + freq_center * length_center + 
    ## ngram_only:     past_c_freq * past_c_length + (1 | word)
    ##            npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## no_surp       9 88294 88355 -44138    88276                         
    ## ngram_only   11 88171 88245 -44074    88149 127.33  2  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## ngram_grnn: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## ngram_grnn:     freq_center * length_center + past_c_freq * past_c_length + 
    ## ngram_grnn:     (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##            npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## ngram_grnn   13 87673 87761 -43823    87647                         
    ## all_surp     15 87661 87762 -43815    87631 16.059  2  0.0003257 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## ngram_txl: mean_rt ~ ngram_center + past_c_ngram + txl_center + past_c_txl + 
    ## ngram_txl:     freq_center * length_center + past_c_freq * past_c_length + 
    ## ngram_txl:     (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##           npar   AIC   BIC logLik deviance Chisq Df Pr(>Chisq)    
    ## ngram_txl   13 87853 87941 -43913    87827                        
    ## all_surp    15 87661 87762 -43815    87631 196.3  2  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## grnn_txl: mean_rt ~ grnn_center + past_c_grnn + txl_center + past_c_txl + 
    ## grnn_txl:     freq_center * length_center + past_c_freq * past_c_length + 
    ## grnn_txl:     (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##          npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)
    ## grnn_txl   13 87657 87745 -43815    87631                     
    ## all_surp   15 87661 87762 -43815    87631 0.0401  2     0.9802

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## ngram_only: mean_rt ~ ngram_center + past_c_ngram + freq_center * length_center + 
    ## ngram_only:     past_c_freq * past_c_length + (1 | word)
    ## ngram_grnn: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## ngram_grnn:     freq_center * length_center + past_c_freq * past_c_length + 
    ## ngram_grnn:     (1 | word)
    ##            npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## ngram_only   11 88171 88245 -44074    88149                         
    ## ngram_grnn   13 87673 87761 -43823    87647 502.25  2  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## grnn_only: mean_rt ~ grnn_center + past_c_grnn + freq_center * length_center + 
    ## grnn_only:     past_c_freq * past_c_length + (1 | word)
    ## ngram_grnn: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## ngram_grnn:     freq_center * length_center + past_c_freq * past_c_length + 
    ## ngram_grnn:     (1 | word)
    ##            npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)
    ## grnn_only    11 87669 87743 -43823    87647                     
    ## ngram_grnn   13 87673 87761 -43823    87647 0.1432  2     0.9309

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## ngram_only: mean_rt ~ ngram_center + past_c_ngram + freq_center * length_center + 
    ## ngram_only:     past_c_freq * past_c_length + (1 | word)
    ## ngram_txl: mean_rt ~ ngram_center + past_c_ngram + txl_center + past_c_txl + 
    ## ngram_txl:     freq_center * length_center + past_c_freq * past_c_length + 
    ## ngram_txl:     (1 | word)
    ##            npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## ngram_only   11 88171 88245 -44074    88149                         
    ## ngram_txl    13 87853 87941 -43913    87827 322.01  2  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## txl_only: mean_rt ~ txl_center + past_c_txl + freq_center * length_center + 
    ## txl_only:     past_c_freq * past_c_length + (1 | word)
    ## ngram_txl: mean_rt ~ ngram_center + past_c_ngram + txl_center + past_c_txl + 
    ## ngram_txl:     freq_center * length_center + past_c_freq * past_c_length + 
    ## ngram_txl:     (1 | word)
    ##           npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## txl_only    11 87870 87945 -43924    87848                         
    ## ngram_txl   13 87853 87941 -43913    87827 21.418  2  2.235e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## grnn_only: mean_rt ~ grnn_center + past_c_grnn + freq_center * length_center + 
    ## grnn_only:     past_c_freq * past_c_length + (1 | word)
    ## grnn_txl: mean_rt ~ grnn_center + past_c_grnn + txl_center + past_c_txl + 
    ## grnn_txl:     freq_center * length_center + past_c_freq * past_c_length + 
    ## grnn_txl:     (1 | word)
    ##           npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## grnn_only   11 87669 87743 -43823    87647                         
    ## grnn_txl    13 87657 87745 -43815    87631 16.162  2  0.0003094 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## txl_only: mean_rt ~ txl_center + past_c_txl + freq_center * length_center + 
    ## txl_only:     past_c_freq * past_c_length + (1 | word)
    ## grnn_txl: mean_rt ~ grnn_center + past_c_grnn + txl_center + past_c_txl + 
    ## grnn_txl:     freq_center * length_center + past_c_freq * past_c_length + 
    ## grnn_txl:     (1 | word)
    ##          npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)    
    ## txl_only   11 87870 87945 -43924    87848                         
    ## grnn_txl   13 87657 87745 -43815    87631 217.68  2  < 2.2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## no_lag: mean_rt ~ ngram_center + grnn_center + txl_center + freq_center * 
    ## no_lag:     length_center + (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##          npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)   
    ## no_lag      9 87671 87732 -43826    87653                        
    ## all_surp   15 87661 87762 -43815    87631 22.015  6   0.001203 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## no_surp_lag: mean_rt ~ ngram_center + grnn_center + txl_center + freq_center * 
    ## no_surp_lag:     length_center + past_c_freq * past_c_length + (1 | word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##             npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)
    ## no_surp_lag   12 87661 87742 -43818    87637                     
    ## all_surp      15 87661 87762 -43815    87631 6.0788  3     0.1078

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## no_lag: mean_rt ~ ngram_center + grnn_center + txl_center + freq_center * 
    ## no_lag:     length_center + (1 | word)
    ## no_surp_lag: mean_rt ~ ngram_center + grnn_center + txl_center + freq_center * 
    ## no_surp_lag:     length_center + past_c_freq * past_c_length + (1 | word)
    ##             npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)   
    ## no_lag         9 87671 87732 -43826    87653                        
    ## no_surp_lag   12 87661 87742 -43818    87637 15.937  3   0.001168 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## only_surp_lag: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## only_surp_lag:     txl_center + past_c_txl + freq_center * length_center + (1 | 
    ## only_surp_lag:     word)
    ## all_surp: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## all_surp:     txl_center + past_c_txl + freq_center * length_center + past_c_freq * 
    ## all_surp:     past_c_length + (1 | word)
    ##               npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)   
    ## only_surp_lag   12 87671 87752 -43823    87647                        
    ## all_surp        15 87661 87762 -43815    87631 16.125  3   0.001069 **
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    ## refitting model(s) with ML (instead of REML)

    ## Data: d_lm
    ## Models:
    ## no_lag: mean_rt ~ ngram_center + grnn_center + txl_center + freq_center * 
    ## no_lag:     length_center + (1 | word)
    ## only_surp_lag: mean_rt ~ ngram_center + past_c_ngram + grnn_center + past_c_grnn + 
    ## only_surp_lag:     txl_center + past_c_txl + freq_center * length_center + (1 | 
    ## only_surp_lag:     word)
    ##               npar   AIC   BIC logLik deviance  Chisq Df Pr(>Chisq)
    ## no_lag           9 87671 87732 -43826    87653                     
    ## only_surp_lag   12 87671 87752 -43823    87647 5.8901  3     0.1171

In general, adding to the model makes it better.

The model with all 3 surprisal predictors is better than any model with
only one. Any one surprisal predictor is better than no surprisals
predictors.

However, adding ngram predictors to a model that already has txl & grnn
does not help. In other cases, adding the 3rd surprisal source to the
other two does help.

Ngram+Grnn is not better than Grnn only. Otherwise, pairs are better
than singletons. This suggests that Ngram’s info is a subset of GRNN,
but not a subset of TXL.

Past surprisal predictors don’t help (with or without past freq,length
effects in the models), but past freq,length do (with or without past
surprisal predictors).
