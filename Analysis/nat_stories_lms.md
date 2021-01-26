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

The model formula we use is rt \~ surp\* length + freq \* length +
past\_surp \* past\_length + past\_freq \* past\_length.

    ## 
    ## ── Column specification ────────────────────────────────────────────────────────
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
    might go any particular way

### On pre-error data only

    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## % latex table generated in R 4.0.3 by xtable 1.8-4 package
    ## % Mon Jan 25 17:22:33 2021
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
(Also not sure I did things right.)

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

## What if we don’t exclude participants

One potentially useful comparison with past SPR/eye-tracking is if we
are more inclusive of participants, do we get data that looks more like
theirs. (Perhaps our exclusion criteria are more robust?)

This is all data from participants who speak English that wasn’t a
mistake. (So, includes bad participants and post-mistake data.)

    ## `summarise()` regrouping output by 'word', 'txl_center', 'ngram_center', 'grnn_center', 'freq_center', 'length_center', 'past_c_txl', 'past_c_ngram', 'past_c_grnn', 'past_c_freq', 'past_c_length' (override with `.groups` argument)

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: mean_rt ~ freq_center * length_center + past_c_freq * past_c_length +  
    ##     (1 | word)
    ##    Data: d_lm2
    ## 
    ## REML criterion at convergence: 95543.9
    ## 
    ## Scaled residuals: 
    ##    Min     1Q Median     3Q    Max 
    ## -4.724 -0.361 -0.101  0.205 36.912 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance Std.Dev.
    ##  word     (Intercept)  24375   156.1   
    ##  Residual             148436   385.3   
    ## Number of obs: 6447, groups:  word, 1504
    ## 
    ## Fixed effects:
    ##                           Estimate Std. Error t value
    ## (Intercept)               808.2314    13.1394  61.512
    ## freq_center                -8.4516     3.2726  -2.583
    ## length_center              19.1359     6.9522   2.752
    ## past_c_freq                 0.2333     1.8529   0.126
    ## past_c_length               3.7415     4.0893   0.915
    ## freq_center:length_center  -1.2451     1.3791  -0.903
    ## past_c_freq:past_c_length  -0.1941     0.7859  -0.247
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) frq_cn lngth_ pst_c_f pst_c_l frq_:_
    ## freq_center  0.558                                     
    ## length_cntr  0.043  0.174                              
    ## past_c_freq  0.090  0.053 -0.036                       
    ## pst_c_lngth  0.209 -0.033 -0.006  0.644                
    ## frq_cntr:l_  0.098 -0.148  0.789 -0.027   0.026        
    ## pst_c_fr:__  0.343 -0.024  0.017  0.247   0.592   0.021

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: mean_rt ~ ngram_center + past_c_ngram + freq_center * length_center +  
    ##     past_c_freq * past_c_length + (1 | word)
    ##    Data: d_lm2
    ## 
    ## REML criterion at convergence: 95516
    ## 
    ## Scaled residuals: 
    ##    Min     1Q Median     3Q    Max 
    ## -4.712 -0.362 -0.100  0.206 36.994 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance Std.Dev.
    ##  word     (Intercept)  24898   157.8   
    ##  Residual             147763   384.4   
    ## Number of obs: 6447, groups:  word, 1504
    ## 
    ## Fixed effects:
    ##                           Estimate Std. Error t value
    ## (Intercept)               811.2400    13.2271  61.332
    ## ngram_center                9.0390     2.0105   4.496
    ## past_c_ngram               -3.1281     1.8806  -1.663
    ## freq_center                 1.2372     3.9270   0.315
    ## length_center              18.1440     6.9800   2.599
    ## past_c_freq                -2.3108     2.5746  -0.898
    ## past_c_length               2.9544     4.0911   0.722
    ## freq_center:length_center  -1.1836     1.3840  -0.855
    ## past_c_freq:past_c_length  -0.3780     0.7874  -0.480
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) ngrm_c pst_c_n frq_cn lngth_ pst_c_f pst_c_l frq_:_
    ## ngram_centr  0.055                                                    
    ## past_c_ngrm  0.025 -0.104                                             
    ## freq_center  0.499  0.548 -0.055                                      
    ## length_cntr  0.037 -0.030  0.001   0.125                              
    ## past_c_freq  0.083 -0.034  0.694   0.014 -0.026                       
    ## pst_c_lngth  0.203 -0.052 -0.031  -0.056 -0.004  0.438                
    ## frq_cntr:l_  0.094  0.011 -0.006  -0.121  0.789 -0.023   0.026        
    ## pst_c_fr:__  0.340 -0.032  0.079  -0.038  0.017  0.230   0.588   0.020

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: mean_rt ~ grnn_center + past_c_grnn + freq_center * length_center +  
    ##     past_c_freq * past_c_length + (1 | word)
    ##    Data: d_lm2
    ## 
    ## REML criterion at convergence: 95385.7
    ## 
    ## Scaled residuals: 
    ##    Min     1Q Median     3Q    Max 
    ## -4.405 -0.347 -0.088  0.203 37.264 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance Std.Dev.
    ##  word     (Intercept)  23509   153.3   
    ##  Residual             145119   380.9   
    ## Number of obs: 6447, groups:  word, 1504
    ## 
    ## Fixed effects:
    ##                           Estimate Std. Error t value
    ## (Intercept)               813.0127    12.9519  62.772
    ## grnn_center                20.9255     1.7004  12.307
    ## past_c_grnn                 1.5410     1.5458   0.997
    ## freq_center                 8.0673     3.4911   2.311
    ## length_center              17.4122     6.8551   2.540
    ## past_c_freq                 1.4769     2.1684   0.681
    ## past_c_length               1.8414     4.0470   0.455
    ## freq_center:length_center  -1.3210     1.3595  -0.972
    ## past_c_freq:past_c_length  -0.6083     0.7782  -0.782
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) grnn_c pst_c_g frq_cn lngth_ pst_c_f pst_c_l frq_:_
    ## grnn_center  0.028                                                    
    ## past_c_grnn  0.016 -0.057                                             
    ## freq_center  0.525  0.382 -0.004                                      
    ## length_cntr  0.044 -0.022  0.011   0.154                              
    ## past_c_freq  0.085 -0.027  0.535   0.040 -0.025                       
    ## pst_c_lngth  0.208 -0.033 -0.035  -0.044 -0.006  0.524                
    ## frq_cntr:l_  0.101 -0.004 -0.005  -0.137  0.788 -0.025   0.027        
    ## pst_c_fr:__  0.343 -0.048  0.039  -0.040  0.018  0.229   0.591   0.021

    ## Linear mixed model fit by REML ['lmerMod']
    ## Formula: mean_rt ~ txl_center + past_c_txl + freq_center * length_center +  
    ##     past_c_freq * past_c_length + (1 | word)
    ##    Data: d_lm2
    ## 
    ## REML criterion at convergence: 95457.7
    ## 
    ## Scaled residuals: 
    ##    Min     1Q Median     3Q    Max 
    ## -4.532 -0.352 -0.096  0.206 37.107 
    ## 
    ## Random effects:
    ##  Groups   Name        Variance Std.Dev.
    ##  word     (Intercept)  24252   155.7   
    ##  Residual             146568   382.8   
    ## Number of obs: 6447, groups:  word, 1504
    ## 
    ## Fixed effects:
    ##                           Estimate Std. Error t value
    ## (Intercept)               813.2034    13.0949  62.101
    ## txl_center                 14.4969     1.6106   9.001
    ## past_c_txl                 -0.9453     1.4935  -0.633
    ## freq_center                 3.6153     3.5221   1.026
    ## length_center              19.2011     6.9203   2.775
    ## past_c_freq                -0.0759     2.2153  -0.034
    ## past_c_length               2.6276     4.0662   0.646
    ## freq_center:length_center  -1.1226     1.3728  -0.818
    ## past_c_freq:past_c_length  -0.5132     0.7824  -0.656
    ## 
    ## Correlation of Fixed Effects:
    ##             (Intr) txl_cn pst_c_t frq_cn lngth_ pst_c_f pst_c_l frq_:_
    ## txl_center   0.041                                                    
    ## past_c_txl   0.006 -0.119                                             
    ## freq_center  0.533  0.379 -0.020                                      
    ## length_cntr  0.041  0.001  0.006   0.160                              
    ## past_c_freq  0.079 -0.042  0.555   0.038 -0.026                       
    ## pst_c_lngth  0.207 -0.030  0.001  -0.042 -0.006  0.535                
    ## frq_cntr:l_  0.097  0.011 -0.010  -0.134  0.789 -0.027   0.026        
    ## pst_c_fr:__  0.340 -0.047  0.037  -0.040  0.017  0.224   0.592   0.020

BRM models from this same very permissive data.

    ##  Family: gaussian 
    ##   Links: mu = identity; sigma = identity 
    ## Formula: rt ~ grnn_center * length_center + freq_center * length_center + past_c_grnn * past_c_length + past_c_freq * past_c_length + (grnn_center * length_center + freq_center * length_center + past_c_grnn * past_c_length + past_c_freq * past_c_length | subject) + (1 | Word_ID) 
    ##    Data: labelled_anything_goes (Number of observations: 50614) 
    ## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
    ##          total post-warmup samples = 4000
    ## 
    ## Group-Level Effects: 
    ## ~subject (Number of levels: 95) 
    ##                                                          Estimate Est.Error
    ## sd(Intercept)                                              340.74     26.71
    ## sd(grnn_center)                                             15.99      2.26
    ## sd(length_center)                                           19.53      4.88
    ## sd(freq_center)                                             13.60      2.62
    ## sd(past_c_grnn)                                             15.67      2.15
    ## sd(past_c_length)                                            5.11      3.64
    ## sd(past_c_freq)                                             15.87      2.35
    ## sd(grnn_center:length_center)                               12.20      1.12
    ## sd(length_center:freq_center)                                4.14      1.08
    ## sd(past_c_grnn:past_c_length)                                2.63      0.78
    ## sd(past_c_length:past_c_freq)                                1.42      0.97
    ## cor(Intercept,grnn_center)                                   0.49      0.11
    ## cor(Intercept,length_center)                                -0.02      0.19
    ## cor(grnn_center,length_center)                               0.25      0.20
    ## cor(Intercept,freq_center)                                  -0.35      0.15
    ## cor(grnn_center,freq_center)                                 0.10      0.18
    ## cor(length_center,freq_center)                               0.03      0.22
    ## cor(Intercept,past_c_grnn)                                   0.07      0.13
    ## cor(grnn_center,past_c_grnn)                                 0.49      0.14
    ## cor(length_center,past_c_grnn)                              -0.15      0.20
    ## cor(freq_center,past_c_grnn)                                 0.52      0.15
    ## cor(Intercept,past_c_length)                                -0.05      0.28
    ## cor(grnn_center,past_c_length)                              -0.06      0.28
    ## cor(length_center,past_c_length)                             0.15      0.28
    ## cor(freq_center,past_c_length)                              -0.16      0.28
    ## cor(past_c_grnn,past_c_length)                              -0.20      0.28
    ## cor(Intercept,past_c_freq)                                   0.10      0.14
    ## cor(grnn_center,past_c_freq)                                 0.08      0.17
    ## cor(length_center,past_c_freq)                              -0.43      0.18
    ## cor(freq_center,past_c_freq)                                 0.54      0.15
    ## cor(past_c_grnn,past_c_freq)                                 0.77      0.08
    ## cor(past_c_length,past_c_freq)                              -0.16      0.28
    ## cor(Intercept,grnn_center:length_center)                    -0.22      0.10
    ## cor(grnn_center,grnn_center:length_center)                   0.13      0.15
    ## cor(length_center,grnn_center:length_center)                 0.63      0.15
    ## cor(freq_center,grnn_center:length_center)                  -0.35      0.16
    ## cor(past_c_grnn,grnn_center:length_center)                  -0.40      0.13
    ## cor(past_c_length,grnn_center:length_center)                 0.24      0.29
    ## cor(past_c_freq,grnn_center:length_center)                  -0.74      0.09
    ## cor(Intercept,length_center:freq_center)                    -0.07      0.20
    ## cor(grnn_center,length_center:freq_center)                  -0.34      0.21
    ## cor(length_center,length_center:freq_center)                 0.16      0.24
    ## cor(freq_center,length_center:freq_center)                  -0.44      0.19
    ## cor(past_c_grnn,length_center:freq_center)                  -0.61      0.16
    ## cor(past_c_length,length_center:freq_center)                 0.14      0.28
    ## cor(past_c_freq,length_center:freq_center)                  -0.55      0.17
    ## cor(grnn_center:length_center,length_center:freq_center)     0.35      0.20
    ## cor(Intercept,past_c_grnn:past_c_length)                     0.31      0.19
    ## cor(grnn_center,past_c_grnn:past_c_length)                  -0.35      0.20
    ## cor(length_center,past_c_grnn:past_c_length)                -0.40      0.21
    ## cor(freq_center,past_c_grnn:past_c_length)                  -0.27      0.21
    ## cor(past_c_grnn,past_c_grnn:past_c_length)                  -0.30      0.20
    ## cor(past_c_length,past_c_grnn:past_c_length)                -0.07      0.28
    ## cor(past_c_freq,past_c_grnn:past_c_length)                   0.09      0.21
    ## cor(grnn_center:length_center,past_c_grnn:past_c_length)    -0.41      0.18
    ## cor(length_center:freq_center,past_c_grnn:past_c_length)     0.18      0.23
    ## cor(Intercept,past_c_length:past_c_freq)                     0.10      0.28
    ## cor(grnn_center,past_c_length:past_c_freq)                  -0.18      0.28
    ## cor(length_center,past_c_length:past_c_freq)                -0.11      0.28
    ## cor(freq_center,past_c_length:past_c_freq)                  -0.20      0.28
    ## cor(past_c_grnn,past_c_length:past_c_freq)                  -0.21      0.28
    ## cor(past_c_length,past_c_length:past_c_freq)                 0.09      0.29
    ## cor(past_c_freq,past_c_length:past_c_freq)                  -0.10      0.27
    ## cor(grnn_center:length_center,past_c_length:past_c_freq)    -0.04      0.27
    ## cor(length_center:freq_center,past_c_length:past_c_freq)     0.13      0.27
    ## cor(past_c_grnn:past_c_length,past_c_length:past_c_freq)     0.37      0.31
    ##                                                          l-95% CI u-95% CI Rhat
    ## sd(Intercept)                                              293.84   397.82 1.01
    ## sd(grnn_center)                                             11.72    20.61 1.00
    ## sd(length_center)                                            9.95    29.07 1.00
    ## sd(freq_center)                                              8.69    18.63 1.01
    ## sd(past_c_grnn)                                             11.68    20.07 1.00
    ## sd(past_c_length)                                            0.28    13.51 1.00
    ## sd(past_c_freq)                                             11.25    20.55 1.00
    ## sd(grnn_center:length_center)                               10.13    14.54 1.00
    ## sd(length_center:freq_center)                                2.01     6.25 1.00
    ## sd(past_c_grnn:past_c_length)                                1.20     4.23 1.00
    ## sd(past_c_length:past_c_freq)                                0.06     3.58 1.00
    ## cor(Intercept,grnn_center)                                   0.25     0.70 1.00
    ## cor(Intercept,length_center)                                -0.39     0.37 1.00
    ## cor(grnn_center,length_center)                              -0.15     0.62 1.00
    ## cor(Intercept,freq_center)                                  -0.63    -0.02 1.00
    ## cor(grnn_center,freq_center)                                -0.27     0.45 1.00
    ## cor(length_center,freq_center)                              -0.42     0.44 1.00
    ## cor(Intercept,past_c_grnn)                                  -0.18     0.32 1.00
    ## cor(grnn_center,past_c_grnn)                                 0.18     0.73 1.01
    ## cor(length_center,past_c_grnn)                              -0.52     0.26 1.00
    ## cor(freq_center,past_c_grnn)                                 0.20     0.78 1.00
    ## cor(Intercept,past_c_length)                                -0.56     0.51 1.00
    ## cor(grnn_center,past_c_length)                              -0.57     0.51 1.00
    ## cor(length_center,past_c_length)                            -0.44     0.64 1.00
    ## cor(freq_center,past_c_length)                              -0.66     0.42 1.00
    ## cor(past_c_grnn,past_c_length)                              -0.69     0.41 1.00
    ## cor(Intercept,past_c_freq)                                  -0.16     0.36 1.00
    ## cor(grnn_center,past_c_freq)                                -0.26     0.41 1.01
    ## cor(length_center,past_c_freq)                              -0.74    -0.03 1.00
    ## cor(freq_center,past_c_freq)                                 0.19     0.79 1.00
    ## cor(past_c_grnn,past_c_freq)                                 0.57     0.90 1.00
    ## cor(past_c_length,past_c_freq)                              -0.65     0.42 1.00
    ## cor(Intercept,grnn_center:length_center)                    -0.42    -0.01 1.00
    ## cor(grnn_center,grnn_center:length_center)                  -0.16     0.42 1.01
    ## cor(length_center,grnn_center:length_center)                 0.31     0.86 1.00
    ## cor(freq_center,grnn_center:length_center)                  -0.64    -0.01 1.00
    ## cor(past_c_grnn,grnn_center:length_center)                  -0.64    -0.13 1.00
    ## cor(past_c_length,grnn_center:length_center)                -0.38     0.73 1.00
    ## cor(past_c_freq,grnn_center:length_center)                  -0.89    -0.54 1.00
    ## cor(Intercept,length_center:freq_center)                    -0.45     0.33 1.00
    ## cor(grnn_center,length_center:freq_center)                  -0.70     0.08 1.00
    ## cor(length_center,length_center:freq_center)                -0.33     0.59 1.00
    ## cor(freq_center,length_center:freq_center)                  -0.76    -0.03 1.00
    ## cor(past_c_grnn,length_center:freq_center)                  -0.86    -0.24 1.00
    ## cor(past_c_length,length_center:freq_center)                -0.45     0.65 1.00
    ## cor(past_c_freq,length_center:freq_center)                  -0.83    -0.17 1.00
    ## cor(grnn_center:length_center,length_center:freq_center)    -0.07     0.68 1.00
    ## cor(Intercept,past_c_grnn:past_c_length)                    -0.07     0.65 1.00
    ## cor(grnn_center,past_c_grnn:past_c_length)                  -0.71     0.08 1.00
    ## cor(length_center,past_c_grnn:past_c_length)                -0.75     0.06 1.00
    ## cor(freq_center,past_c_grnn:past_c_length)                  -0.65     0.17 1.00
    ## cor(past_c_grnn,past_c_grnn:past_c_length)                  -0.63     0.12 1.00
    ## cor(past_c_length,past_c_grnn:past_c_length)                -0.59     0.49 1.00
    ## cor(past_c_freq,past_c_grnn:past_c_length)                  -0.30     0.49 1.00
    ## cor(grnn_center:length_center,past_c_grnn:past_c_length)    -0.72    -0.02 1.00
    ## cor(length_center:freq_center,past_c_grnn:past_c_length)    -0.28     0.59 1.00
    ## cor(Intercept,past_c_length:past_c_freq)                    -0.47     0.60 1.00
    ## cor(grnn_center,past_c_length:past_c_freq)                  -0.68     0.41 1.00
    ## cor(length_center,past_c_length:past_c_freq)                -0.62     0.48 1.00
    ## cor(freq_center,past_c_length:past_c_freq)                  -0.68     0.37 1.00
    ## cor(past_c_grnn,past_c_length:past_c_freq)                  -0.70     0.38 1.00
    ## cor(past_c_length,past_c_length:past_c_freq)                -0.49     0.63 1.00
    ## cor(past_c_freq,past_c_length:past_c_freq)                  -0.58     0.45 1.00
    ## cor(grnn_center:length_center,past_c_length:past_c_freq)    -0.55     0.50 1.00
    ## cor(length_center:freq_center,past_c_length:past_c_freq)    -0.42     0.62 1.00
    ## cor(past_c_grnn:past_c_length,past_c_length:past_c_freq)    -0.32     0.84 1.00
    ##                                                          Bulk_ESS Tail_ESS
    ## sd(Intercept)                                                 429      981
    ## sd(grnn_center)                                              1496     2350
    ## sd(length_center)                                            1641     1447
    ## sd(freq_center)                                               817     1839
    ## sd(past_c_grnn)                                              1715     2257
    ## sd(past_c_length)                                            1536     1807
    ## sd(past_c_freq)                                              1868     2443
    ## sd(grnn_center:length_center)                                2013     2574
    ## sd(length_center:freq_center)                                1230     1595
    ## sd(past_c_grnn:past_c_length)                                1451     1712
    ## sd(past_c_length:past_c_freq)                                1049     1699
    ## cor(Intercept,grnn_center)                                   2244     2816
    ## cor(Intercept,length_center)                                 3498     2784
    ## cor(grnn_center,length_center)                               1704     2314
    ## cor(Intercept,freq_center)                                   2233     2859
    ## cor(grnn_center,freq_center)                                 1681     2232
    ## cor(length_center,freq_center)                                810     1757
    ## cor(Intercept,past_c_grnn)                                   2228     2668
    ## cor(grnn_center,past_c_grnn)                                 1085     2381
    ## cor(length_center,past_c_grnn)                                884     1515
    ## cor(freq_center,past_c_grnn)                                 1450     2455
    ## cor(Intercept,past_c_length)                                 4815     2822
    ## cor(grnn_center,past_c_length)                               4670     2967
    ## cor(length_center,past_c_length)                             3918     2861
    ## cor(freq_center,past_c_length)                               3978     2682
    ## cor(past_c_grnn,past_c_length)                               3267     3154
    ## cor(Intercept,past_c_freq)                                   2330     2835
    ## cor(grnn_center,past_c_freq)                                 1014     1759
    ## cor(length_center,past_c_freq)                                569     1231
    ## cor(freq_center,past_c_freq)                                 1591     2520
    ## cor(past_c_grnn,past_c_freq)                                 2470     2838
    ## cor(past_c_length,past_c_freq)                               3555     3035
    ## cor(Intercept,grnn_center:length_center)                     1799     2546
    ## cor(grnn_center,grnn_center:length_center)                    749     1516
    ## cor(length_center,grnn_center:length_center)                  480     1213
    ## cor(freq_center,grnn_center:length_center)                   1815     2553
    ## cor(past_c_grnn,grnn_center:length_center)                   2760     3098
    ## cor(past_c_length,grnn_center:length_center)                 1605     2671
    ## cor(past_c_freq,grnn_center:length_center)                   2501     3321
    ## cor(Intercept,length_center:freq_center)                     4302     3012
    ## cor(grnn_center,length_center:freq_center)                   2135     3072
    ## cor(length_center,length_center:freq_center)                 1232     2193
    ## cor(freq_center,length_center:freq_center)                   2384     3507
    ## cor(past_c_grnn,length_center:freq_center)                   2434     2954
    ## cor(past_c_length,length_center:freq_center)                 2645     2882
    ## cor(past_c_freq,length_center:freq_center)                   2102     2985
    ## cor(grnn_center:length_center,length_center:freq_center)     2202     2984
    ## cor(Intercept,past_c_grnn:past_c_length)                     3987     2946
    ## cor(grnn_center,past_c_grnn:past_c_length)                   2874     2597
    ## cor(length_center,past_c_grnn:past_c_length)                 3453     2786
    ## cor(freq_center,past_c_grnn:past_c_length)                   3121     2647
    ## cor(past_c_grnn,past_c_grnn:past_c_length)                   3346     2905
    ## cor(past_c_length,past_c_grnn:past_c_length)                 3599     3295
    ## cor(past_c_freq,past_c_grnn:past_c_length)                   4227     3426
    ## cor(grnn_center:length_center,past_c_grnn:past_c_length)     3742     3246
    ## cor(length_center:freq_center,past_c_grnn:past_c_length)     3461     3555
    ## cor(Intercept,past_c_length:past_c_freq)                     4849     2931
    ## cor(grnn_center,past_c_length:past_c_freq)                   3268     3382
    ## cor(length_center,past_c_length:past_c_freq)                 3389     2768
    ## cor(freq_center,past_c_length:past_c_freq)                   2968     3326
    ## cor(past_c_grnn,past_c_length:past_c_freq)                   2765     2752
    ## cor(past_c_length,past_c_length:past_c_freq)                 2712     3000
    ## cor(past_c_freq,past_c_length:past_c_freq)                   4553     3121
    ## cor(grnn_center:length_center,past_c_length:past_c_freq)     5173     3157
    ## cor(length_center:freq_center,past_c_length:past_c_freq)     3375     3393
    ## cor(past_c_grnn:past_c_length,past_c_length:past_c_freq)     1239     2254
    ## 
    ## ~Word_ID (Number of levels: 6447) 
    ##               Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sd(Intercept)    91.02     14.88    58.95   117.28 1.00      604      794
    ## 
    ## Population-Level Effects: 
    ##                           Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS
    ## Intercept                   734.18     36.31   665.19   803.90 1.03      174
    ## grnn_center                  18.97      2.35    14.52    23.73 1.01      888
    ## length_center                14.47      4.61     5.22    23.34 1.00     2534
    ## freq_center                   0.17      2.54    -4.73     5.15 1.00     2057
    ## past_c_grnn                   0.62      2.26    -3.83     5.12 1.00     1958
    ## past_c_length                -0.95      3.98    -8.49     7.09 1.00     3679
    ## past_c_freq                  -0.76      2.66    -6.05     4.34 1.00     1822
    ## grnn_center:length_center    -0.47      1.49    -3.40     2.43 1.00     1572
    ## length_center:freq_center    -0.37      1.05    -2.47     1.68 1.00     2930
    ## past_c_grnn:past_c_length    -0.68      0.75    -2.18     0.81 1.00     2652
    ## past_c_length:past_c_freq    -0.30      0.97    -2.14     1.61 1.00     3002
    ##                           Tail_ESS
    ## Intercept                      409
    ## grnn_center                   2186
    ## length_center                 2844
    ## freq_center                   2820
    ## past_c_grnn                   2669
    ## past_c_length                 2971
    ## past_c_freq                   2236
    ## grnn_center:length_center     2414
    ## length_center:freq_center     2713
    ## past_c_grnn:past_c_length     2834
    ## past_c_length:past_c_freq     2608
    ## 
    ## Family Specific Parameters: 
    ##       Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sigma  1038.03      3.58  1031.01  1044.97 1.00     3437     2556
    ## 
    ## Samples were drawn using sampling(NUTS). For each parameter, Bulk_ESS
    ## and Tail_ESS are effective sample size measures, and Rhat is the potential
    ## scale reduction factor on split chains (at convergence, Rhat = 1).

    ##  Family: gaussian 
    ##   Links: mu = identity; sigma = identity 
    ## Formula: rt ~ txl_center * length_center + freq_center * length_center + past_c_txl * past_c_length + past_c_freq * past_c_length + (txl_center * length_center + freq_center * length_center + past_c_txl * past_c_length + past_c_freq * past_c_length | subject) + (1 | Word_ID) 
    ##    Data: labelled_anything_goes (Number of observations: 50614) 
    ## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
    ##          total post-warmup samples = 4000
    ## 
    ## Group-Level Effects: 
    ## ~subject (Number of levels: 95) 
    ##                                                          Estimate Est.Error
    ## sd(Intercept)                                              339.08     26.53
    ## sd(txl_center)                                              11.18      2.06
    ## sd(length_center)                                           18.33      5.58
    ## sd(freq_center)                                             18.51      2.61
    ## sd(past_c_txl)                                              18.87      2.25
    ## sd(past_c_length)                                            5.46      3.71
    ## sd(past_c_freq)                                             19.75      2.63
    ## sd(txl_center:length_center)                                 3.12      0.93
    ## sd(length_center:freq_center)                                7.56      1.32
    ## sd(past_c_txl:past_c_length)                                 1.66      0.78
    ## sd(past_c_length:past_c_freq)                                0.73      0.54
    ## cor(Intercept,txl_center)                                    0.29      0.15
    ## cor(Intercept,length_center)                                 0.05      0.20
    ## cor(txl_center,length_center)                                0.45      0.19
    ## cor(Intercept,freq_center)                                  -0.43      0.12
    ## cor(txl_center,freq_center)                                  0.34      0.18
    ## cor(length_center,freq_center)                               0.06      0.22
    ## cor(Intercept,past_c_txl)                                   -0.01      0.12
    ## cor(txl_center,past_c_txl)                                   0.23      0.17
    ## cor(length_center,past_c_txl)                               -0.15      0.19
    ## cor(freq_center,past_c_txl)                                  0.52      0.13
    ## cor(Intercept,past_c_length)                                 0.02      0.27
    ## cor(txl_center,past_c_length)                               -0.10      0.27
    ## cor(length_center,past_c_length)                             0.07      0.28
    ## cor(freq_center,past_c_length)                              -0.23      0.28
    ## cor(past_c_txl,past_c_length)                               -0.27      0.29
    ## cor(Intercept,past_c_freq)                                   0.03      0.13
    ## cor(txl_center,past_c_freq)                                  0.13      0.17
    ## cor(length_center,past_c_freq)                              -0.30      0.19
    ## cor(freq_center,past_c_freq)                                 0.56      0.13
    ## cor(past_c_txl,past_c_freq)                                  0.92      0.04
    ## cor(past_c_length,past_c_freq)                              -0.21      0.28
    ## cor(Intercept,txl_center:length_center)                     -0.31      0.19
    ## cor(txl_center,txl_center:length_center)                    -0.09      0.22
    ## cor(length_center,txl_center:length_center)                  0.27      0.23
    ## cor(freq_center,txl_center:length_center)                   -0.16      0.20
    ## cor(past_c_txl,txl_center:length_center)                    -0.56      0.17
    ## cor(past_c_length,txl_center:length_center)                  0.15      0.29
    ## cor(past_c_freq,txl_center:length_center)                   -0.58      0.16
    ## cor(Intercept,length_center:freq_center)                     0.09      0.15
    ## cor(txl_center,length_center:freq_center)                   -0.32      0.18
    ## cor(length_center,length_center:freq_center)                -0.44      0.19
    ## cor(freq_center,length_center:freq_center)                   0.13      0.17
    ## cor(past_c_txl,length_center:freq_center)                   -0.08      0.16
    ## cor(past_c_length,length_center:freq_center)                -0.05      0.28
    ## cor(past_c_freq,length_center:freq_center)                   0.14      0.16
    ## cor(txl_center:length_center,length_center:freq_center)     -0.03      0.23
    ## cor(Intercept,past_c_txl:past_c_length)                      0.14      0.23
    ## cor(txl_center,past_c_txl:past_c_length)                    -0.02      0.24
    ## cor(length_center,past_c_txl:past_c_length)                 -0.29      0.25
    ## cor(freq_center,past_c_txl:past_c_length)                    0.28      0.24
    ## cor(past_c_txl,past_c_txl:past_c_length)                     0.32      0.23
    ## cor(past_c_length,past_c_txl:past_c_length)                 -0.20      0.30
    ## cor(past_c_freq,past_c_txl:past_c_length)                    0.45      0.23
    ## cor(txl_center:length_center,past_c_txl:past_c_length)      -0.35      0.25
    ## cor(length_center:freq_center,past_c_txl:past_c_length)      0.32      0.24
    ## cor(Intercept,past_c_length:past_c_freq)                    -0.01      0.28
    ## cor(txl_center,past_c_length:past_c_freq)                   -0.05      0.28
    ## cor(length_center,past_c_length:past_c_freq)                -0.01      0.29
    ## cor(freq_center,past_c_length:past_c_freq)                  -0.01      0.28
    ## cor(past_c_txl,past_c_length:past_c_freq)                   -0.00      0.29
    ## cor(past_c_length,past_c_length:past_c_freq)                 0.05      0.29
    ## cor(past_c_freq,past_c_length:past_c_freq)                  -0.01      0.29
    ## cor(txl_center:length_center,past_c_length:past_c_freq)      0.00      0.29
    ## cor(length_center:freq_center,past_c_length:past_c_freq)    -0.02      0.29
    ## cor(past_c_txl:past_c_length,past_c_length:past_c_freq)      0.10      0.30
    ##                                                          l-95% CI u-95% CI Rhat
    ## sd(Intercept)                                              291.71   396.20 1.01
    ## sd(txl_center)                                               7.30    15.36 1.00
    ## sd(length_center)                                            6.99    29.04 1.00
    ## sd(freq_center)                                             13.73    23.89 1.00
    ## sd(past_c_txl)                                              14.70    23.56 1.00
    ## sd(past_c_length)                                            0.22    13.86 1.00
    ## sd(past_c_freq)                                             14.60    25.08 1.00
    ## sd(txl_center:length_center)                                 1.31     4.94 1.00
    ## sd(length_center:freq_center)                                5.08    10.17 1.00
    ## sd(past_c_txl:past_c_length)                                 0.19     3.22 1.00
    ## sd(past_c_length:past_c_freq)                                0.03     2.00 1.00
    ## cor(Intercept,txl_center)                                   -0.02     0.56 1.00
    ## cor(Intercept,length_center)                                -0.34     0.43 1.00
    ## cor(txl_center,length_center)                                0.02     0.77 1.00
    ## cor(Intercept,freq_center)                                  -0.65    -0.18 1.00
    ## cor(txl_center,freq_center)                                 -0.05     0.64 1.00
    ## cor(length_center,freq_center)                              -0.39     0.45 1.00
    ## cor(Intercept,past_c_txl)                                   -0.24     0.22 1.00
    ## cor(txl_center,past_c_txl)                                  -0.11     0.56 1.01
    ## cor(length_center,past_c_txl)                               -0.51     0.25 1.00
    ## cor(freq_center,past_c_txl)                                  0.24     0.76 1.01
    ## cor(Intercept,past_c_length)                                -0.52     0.54 1.00
    ## cor(txl_center,past_c_length)                               -0.59     0.45 1.00
    ## cor(length_center,past_c_length)                            -0.48     0.60 1.00
    ## cor(freq_center,past_c_length)                              -0.72     0.37 1.00
    ## cor(past_c_txl,past_c_length)                               -0.74     0.37 1.00
    ## cor(Intercept,past_c_freq)                                  -0.21     0.28 1.00
    ## cor(txl_center,past_c_freq)                                 -0.20     0.47 1.01
    ## cor(length_center,past_c_freq)                              -0.62     0.11 1.01
    ## cor(freq_center,past_c_freq)                                 0.28     0.79 1.01
    ## cor(past_c_txl,past_c_freq)                                  0.82     0.97 1.00
    ## cor(past_c_length,past_c_freq)                              -0.69     0.40 1.00
    ## cor(Intercept,txl_center:length_center)                     -0.64     0.09 1.00
    ## cor(txl_center,txl_center:length_center)                    -0.50     0.34 1.00
    ## cor(length_center,txl_center:length_center)                 -0.21     0.68 1.00
    ## cor(freq_center,txl_center:length_center)                   -0.54     0.26 1.00
    ## cor(past_c_txl,txl_center:length_center)                    -0.83    -0.18 1.00
    ## cor(past_c_length,txl_center:length_center)                 -0.46     0.67 1.00
    ## cor(past_c_freq,txl_center:length_center)                   -0.84    -0.21 1.00
    ## cor(Intercept,length_center:freq_center)                    -0.21     0.38 1.00
    ## cor(txl_center,length_center:freq_center)                   -0.65     0.05 1.00
    ## cor(length_center,length_center:freq_center)                -0.76     0.00 1.01
    ## cor(freq_center,length_center:freq_center)                  -0.23     0.45 1.00
    ## cor(past_c_txl,length_center:freq_center)                   -0.37     0.23 1.00
    ## cor(past_c_length,length_center:freq_center)                -0.57     0.49 1.00
    ## cor(past_c_freq,length_center:freq_center)                  -0.17     0.44 1.00
    ## cor(txl_center:length_center,length_center:freq_center)     -0.49     0.40 1.00
    ## cor(Intercept,past_c_txl:past_c_length)                     -0.34     0.56 1.00
    ## cor(txl_center,past_c_txl:past_c_length)                    -0.49     0.46 1.00
    ## cor(length_center,past_c_txl:past_c_length)                 -0.72     0.27 1.00
    ## cor(freq_center,past_c_txl:past_c_length)                   -0.24     0.69 1.00
    ## cor(past_c_txl,past_c_txl:past_c_length)                    -0.21     0.70 1.00
    ## cor(past_c_length,past_c_txl:past_c_length)                 -0.72     0.42 1.00
    ## cor(past_c_freq,past_c_txl:past_c_length)                   -0.11     0.79 1.00
    ## cor(txl_center:length_center,past_c_txl:past_c_length)      -0.76     0.19 1.00
    ## cor(length_center:freq_center,past_c_txl:past_c_length)     -0.23     0.72 1.00
    ## cor(Intercept,past_c_length:past_c_freq)                    -0.55     0.54 1.00
    ## cor(txl_center,past_c_length:past_c_freq)                   -0.57     0.51 1.00
    ## cor(length_center,past_c_length:past_c_freq)                -0.56     0.52 1.00
    ## cor(freq_center,past_c_length:past_c_freq)                  -0.55     0.54 1.00
    ## cor(past_c_txl,past_c_length:past_c_freq)                   -0.55     0.56 1.00
    ## cor(past_c_length,past_c_length:past_c_freq)                -0.52     0.61 1.00
    ## cor(past_c_freq,past_c_length:past_c_freq)                  -0.56     0.56 1.00
    ## cor(txl_center:length_center,past_c_length:past_c_freq)     -0.58     0.57 1.00
    ## cor(length_center:freq_center,past_c_length:past_c_freq)    -0.57     0.54 1.00
    ## cor(past_c_txl:past_c_length,past_c_length:past_c_freq)     -0.51     0.64 1.00
    ##                                                          Bulk_ESS Tail_ESS
    ## sd(Intercept)                                                 305      968
    ## sd(txl_center)                                               1809     2319
    ## sd(length_center)                                            1220     1023
    ## sd(freq_center)                                              1272     2347
    ## sd(past_c_txl)                                               1727     2409
    ## sd(past_c_length)                                            1686     1895
    ## sd(past_c_freq)                                              1779     2542
    ## sd(txl_center:length_center)                                 2088     1782
    ## sd(length_center:freq_center)                                1155     2119
    ## sd(past_c_txl:past_c_length)                                 1265     1237
    ## sd(past_c_length:past_c_freq)                                2755     1992
    ## cor(Intercept,txl_center)                                    3182     2712
    ## cor(Intercept,length_center)                                 4291     2684
    ## cor(txl_center,length_center)                                2126     3098
    ## cor(Intercept,freq_center)                                   2204     2947
    ## cor(txl_center,freq_center)                                  1203     2127
    ## cor(length_center,freq_center)                               1148     1729
    ## cor(Intercept,past_c_txl)                                    2317     2764
    ## cor(txl_center,past_c_txl)                                    607     1338
    ## cor(length_center,past_c_txl)                                 667     1681
    ## cor(freq_center,past_c_txl)                                  1149     1651
    ## cor(Intercept,past_c_length)                                 6485     2558
    ## cor(txl_center,past_c_length)                                4635     3004
    ## cor(length_center,past_c_length)                             4463     2954
    ## cor(freq_center,past_c_length)                               3212     2924
    ## cor(past_c_txl,past_c_length)                                2539     2713
    ## cor(Intercept,past_c_freq)                                   2328     2643
    ## cor(txl_center,past_c_freq)                                   719     1359
    ## cor(length_center,past_c_freq)                                629     1234
    ## cor(freq_center,past_c_freq)                                 1498     2279
    ## cor(past_c_txl,past_c_freq)                                  2544     3235
    ## cor(past_c_length,past_c_freq)                               3047     3026
    ## cor(Intercept,txl_center:length_center)                      4210     3216
    ## cor(txl_center,txl_center:length_center)                     1742     2687
    ## cor(length_center,txl_center:length_center)                  1345     2622
    ## cor(freq_center,txl_center:length_center)                    2402     2986
    ## cor(past_c_txl,txl_center:length_center)                     3176     2784
    ## cor(past_c_length,txl_center:length_center)                  2964     3122
    ## cor(past_c_freq,txl_center:length_center)                    3030     2952
    ## cor(Intercept,length_center:freq_center)                     3027     2858
    ## cor(txl_center,length_center:freq_center)                    1126     1589
    ## cor(length_center,length_center:freq_center)                  674     1024
    ## cor(freq_center,length_center:freq_center)                   1221     2614
    ## cor(past_c_txl,length_center:freq_center)                    1979     3121
    ## cor(past_c_length,length_center:freq_center)                 1903     2662
    ## cor(past_c_freq,length_center:freq_center)                   1951     3161
    ## cor(txl_center:length_center,length_center:freq_center)      1911     2341
    ## cor(Intercept,past_c_txl:past_c_length)                      5393     3058
    ## cor(txl_center,past_c_txl:past_c_length)                     2968     3134
    ## cor(length_center,past_c_txl:past_c_length)                  2057     2520
    ## cor(freq_center,past_c_txl:past_c_length)                    2926     3162
    ## cor(past_c_txl,past_c_txl:past_c_length)                     3158     2504
    ## cor(past_c_length,past_c_txl:past_c_length)                  2210     2715
    ## cor(past_c_freq,past_c_txl:past_c_length)                    2216     1813
    ## cor(txl_center:length_center,past_c_txl:past_c_length)       2302     2865
    ## cor(length_center:freq_center,past_c_txl:past_c_length)      3064     2929
    ## cor(Intercept,past_c_length:past_c_freq)                     6843     3102
    ## cor(txl_center,past_c_length:past_c_freq)                    5793     2583
    ## cor(length_center,past_c_length:past_c_freq)                 5709     3249
    ## cor(freq_center,past_c_length:past_c_freq)                   5425     2704
    ## cor(past_c_txl,past_c_length:past_c_freq)                    5631     3521
    ## cor(past_c_length,past_c_length:past_c_freq)                 2879     3036
    ## cor(past_c_freq,past_c_length:past_c_freq)                   5483     3478
    ## cor(txl_center:length_center,past_c_length:past_c_freq)      4302     3582
    ## cor(length_center:freq_center,past_c_length:past_c_freq)     5274     3293
    ## cor(past_c_txl:past_c_length,past_c_length:past_c_freq)      3318     3473
    ## 
    ## ~Word_ID (Number of levels: 6447) 
    ##               Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sd(Intercept)    96.43     16.43    61.09   122.84 1.01      326      228
    ## 
    ## Population-Level Effects: 
    ##                           Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS
    ## Intercept                   734.55     37.09   660.86   808.57 1.02      159
    ## txl_center                   13.21      1.98     9.23    16.99 1.00     2116
    ## length_center                15.96      4.56     7.23    25.03 1.00     3385
    ## freq_center                  -3.33      2.81    -8.92     2.16 1.00     1428
    ## past_c_txl                   -1.80      2.49    -6.67     3.08 1.00     1973
    ## past_c_length                 0.56      4.14    -7.63     8.72 1.00     3701
    ## past_c_freq                  -1.79      2.96    -7.56     4.08 1.00     2005
    ## txl_center:length_center     -1.76      0.77    -3.21    -0.26 1.00     2666
    ## length_center:freq_center    -1.52      1.25    -4.01     0.86 1.00     2767
    ## past_c_txl:past_c_length     -0.73      0.71    -2.13     0.68 1.00     3731
    ## past_c_length:past_c_freq    -0.37      0.96    -2.19     1.52 1.00     3555
    ##                           Tail_ESS
    ## Intercept                      361
    ## txl_center                    2571
    ## length_center                 2615
    ## freq_center                   2232
    ## past_c_txl                    2584
    ## past_c_length                 2921
    ## past_c_freq                   2623
    ## txl_center:length_center      3108
    ## length_center:freq_center     3179
    ## past_c_txl:past_c_length      3204
    ## past_c_length:past_c_freq     2939
    ## 
    ## Family Specific Parameters: 
    ##       Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sigma  1040.74      3.54  1033.88  1047.51 1.00     1775     2363
    ## 
    ## Samples were drawn using sampling(NUTS). For each parameter, Bulk_ESS
    ## and Tail_ESS are effective sample size measures, and Rhat is the potential
    ## scale reduction factor on split chains (at convergence, Rhat = 1).

    ##  Family: gaussian 
    ##   Links: mu = identity; sigma = identity 
    ## Formula: rt ~ ngram_center * length_center + freq_center * length_center + past_c_ngram * past_c_length + past_c_freq * past_c_length + (ngram_center * length_center + freq_center * length_center + past_c_ngram * past_c_length + past_c_freq * past_c_length | subject) + (1 | Word_ID) 
    ##    Data: labelled_anything_goes (Number of observations: 50614) 
    ## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
    ##          total post-warmup samples = 4000
    ## 
    ## Group-Level Effects: 
    ## ~subject (Number of levels: 95) 
    ##                                                            Estimate Est.Error
    ## sd(Intercept)                                                342.13     26.63
    ## sd(ngram_center)                                              11.98      2.16
    ## sd(length_center)                                             12.60      5.47
    ## sd(freq_center)                                               16.10      3.14
    ## sd(past_c_ngram)                                              22.20      2.49
    ## sd(past_c_length)                                              8.50      4.93
    ## sd(past_c_freq)                                               26.19      2.96
    ## sd(ngram_center:length_center)                                15.39      1.25
    ## sd(length_center:freq_center)                                 19.43      1.66
    ## sd(past_c_ngram:past_c_length)                                 5.85      0.95
    ## sd(past_c_length:past_c_freq)                                  4.57      1.36
    ## cor(Intercept,ngram_center)                                    0.50      0.14
    ## cor(Intercept,length_center)                                   0.07      0.24
    ## cor(ngram_center,length_center)                               -0.21      0.24
    ## cor(Intercept,freq_center)                                    -0.32      0.15
    ## cor(ngram_center,freq_center)                                  0.33      0.19
    ## cor(length_center,freq_center)                                -0.14      0.26
    ## cor(Intercept,past_c_ngram)                                    0.11      0.12
    ## cor(ngram_center,past_c_ngram)                                 0.55      0.14
    ## cor(length_center,past_c_ngram)                               -0.37      0.22
    ## cor(freq_center,past_c_ngram)                                  0.43      0.16
    ## cor(Intercept,past_c_length)                                   0.00      0.26
    ## cor(ngram_center,past_c_length)                               -0.16      0.27
    ## cor(length_center,past_c_length)                               0.17      0.27
    ## cor(freq_center,past_c_length)                                -0.29      0.27
    ## cor(past_c_ngram,past_c_length)                               -0.35      0.26
    ## cor(Intercept,past_c_freq)                                     0.10      0.12
    ## cor(ngram_center,past_c_freq)                                  0.56      0.14
    ## cor(length_center,past_c_freq)                                -0.39      0.23
    ## cor(freq_center,past_c_freq)                                   0.53      0.14
    ## cor(past_c_ngram,past_c_freq)                                  0.96      0.02
    ## cor(past_c_length,past_c_freq)                                -0.30      0.26
    ## cor(Intercept,ngram_center:length_center)                      0.07      0.10
    ## cor(ngram_center,ngram_center:length_center)                   0.61      0.12
    ## cor(length_center,ngram_center:length_center)                 -0.45      0.22
    ## cor(freq_center,ngram_center:length_center)                    0.42      0.15
    ## cor(past_c_ngram,ngram_center:length_center)                   0.84      0.06
    ## cor(past_c_length,ngram_center:length_center)                 -0.28      0.26
    ## cor(past_c_freq,ngram_center:length_center)                    0.82      0.07
    ## cor(Intercept,length_center:freq_center)                       0.13      0.10
    ## cor(ngram_center,length_center:freq_center)                    0.52      0.13
    ## cor(length_center,length_center:freq_center)                  -0.48      0.22
    ## cor(freq_center,length_center:freq_center)                     0.50      0.14
    ## cor(past_c_ngram,length_center:freq_center)                    0.78      0.07
    ## cor(past_c_length,length_center:freq_center)                  -0.33      0.26
    ## cor(past_c_freq,length_center:freq_center)                     0.81      0.07
    ## cor(ngram_center:length_center,length_center:freq_center)      0.89      0.03
    ## cor(Intercept,past_c_ngram:past_c_length)                      0.15      0.14
    ## cor(ngram_center,past_c_ngram:past_c_length)                   0.52      0.15
    ## cor(length_center,past_c_ngram:past_c_length)                 -0.44      0.23
    ## cor(freq_center,past_c_ngram:past_c_length)                    0.53      0.15
    ## cor(past_c_ngram,past_c_ngram:past_c_length)                   0.74      0.09
    ## cor(past_c_length,past_c_ngram:past_c_length)                 -0.37      0.27
    ## cor(past_c_freq,past_c_ngram:past_c_length)                    0.80      0.08
    ## cor(ngram_center:length_center,past_c_ngram:past_c_length)     0.77      0.09
    ## cor(length_center:freq_center,past_c_ngram:past_c_length)      0.85      0.07
    ## cor(Intercept,past_c_length:past_c_freq)                       0.10      0.20
    ## cor(ngram_center,past_c_length:past_c_freq)                    0.44      0.20
    ## cor(length_center,past_c_length:past_c_freq)                  -0.35      0.24
    ## cor(freq_center,past_c_length:past_c_freq)                     0.33      0.21
    ## cor(past_c_ngram,past_c_length:past_c_freq)                    0.58      0.17
    ## cor(past_c_length,past_c_length:past_c_freq)                  -0.13      0.27
    ## cor(past_c_freq,past_c_length:past_c_freq)                     0.59      0.17
    ## cor(ngram_center:length_center,past_c_length:past_c_freq)      0.68      0.16
    ## cor(length_center:freq_center,past_c_length:past_c_freq)       0.65      0.16
    ## cor(past_c_ngram:past_c_length,past_c_length:past_c_freq)      0.79      0.14
    ##                                                            l-95% CI u-95% CI
    ## sd(Intercept)                                                293.83   398.86
    ## sd(ngram_center)                                               7.94    16.27
    ## sd(length_center)                                              1.36    22.77
    ## sd(freq_center)                                                9.83    22.29
    ## sd(past_c_ngram)                                              17.49    27.18
    ## sd(past_c_length)                                              0.52    18.45
    ## sd(past_c_freq)                                               20.70    32.36
    ## sd(ngram_center:length_center)                                13.05    17.98
    ## sd(length_center:freq_center)                                 16.42    22.98
    ## sd(past_c_ngram:past_c_length)                                 3.96     7.70
    ## sd(past_c_length:past_c_freq)                                  1.71     7.09
    ## cor(Intercept,ngram_center)                                    0.20     0.75
    ## cor(Intercept,length_center)                                  -0.41     0.51
    ## cor(ngram_center,length_center)                               -0.63     0.29
    ## cor(Intercept,freq_center)                                    -0.60    -0.00
    ## cor(ngram_center,freq_center)                                 -0.09     0.63
    ## cor(length_center,freq_center)                                -0.63     0.38
    ## cor(Intercept,past_c_ngram)                                   -0.13     0.35
    ## cor(ngram_center,past_c_ngram)                                 0.25     0.79
    ## cor(length_center,past_c_ngram)                               -0.74     0.10
    ## cor(freq_center,past_c_ngram)                                  0.10     0.71
    ## cor(Intercept,past_c_length)                                  -0.48     0.51
    ## cor(ngram_center,past_c_length)                               -0.63     0.39
    ## cor(length_center,past_c_length)                              -0.39     0.66
    ## cor(freq_center,past_c_length)                                -0.73     0.31
    ## cor(past_c_ngram,past_c_length)                               -0.76     0.27
    ## cor(Intercept,past_c_freq)                                    -0.15     0.34
    ## cor(ngram_center,past_c_freq)                                  0.26     0.80
    ## cor(length_center,past_c_freq)                                -0.76     0.12
    ## cor(freq_center,past_c_freq)                                   0.21     0.78
    ## cor(past_c_ngram,past_c_freq)                                  0.91     0.99
    ## cor(past_c_length,past_c_freq)                                -0.73     0.29
    ## cor(Intercept,ngram_center:length_center)                     -0.13     0.27
    ## cor(ngram_center,ngram_center:length_center)                   0.35     0.82
    ## cor(length_center,ngram_center:length_center)                 -0.79     0.07
    ## cor(freq_center,ngram_center:length_center)                    0.12     0.69
    ## cor(past_c_ngram,ngram_center:length_center)                   0.71     0.94
    ## cor(past_c_length,ngram_center:length_center)                 -0.71     0.28
    ## cor(past_c_freq,ngram_center:length_center)                    0.68     0.93
    ## cor(Intercept,length_center:freq_center)                      -0.08     0.34
    ## cor(ngram_center,length_center:freq_center)                    0.24     0.76
    ## cor(length_center,length_center:freq_center)                  -0.81     0.05
    ## cor(freq_center,length_center:freq_center)                     0.21     0.74
    ## cor(past_c_ngram,length_center:freq_center)                    0.63     0.90
    ## cor(past_c_length,length_center:freq_center)                  -0.76     0.28
    ## cor(past_c_freq,length_center:freq_center)                     0.66     0.92
    ## cor(ngram_center:length_center,length_center:freq_center)      0.83     0.94
    ## cor(Intercept,past_c_ngram:past_c_length)                     -0.12     0.41
    ## cor(ngram_center,past_c_ngram:past_c_length)                   0.20     0.78
    ## cor(length_center,past_c_ngram:past_c_length)                 -0.79     0.10
    ## cor(freq_center,past_c_ngram:past_c_length)                    0.21     0.78
    ## cor(past_c_ngram,past_c_ngram:past_c_length)                   0.53     0.90
    ## cor(past_c_length,past_c_ngram:past_c_length)                 -0.79     0.27
    ## cor(past_c_freq,past_c_ngram:past_c_length)                    0.62     0.93
    ## cor(ngram_center:length_center,past_c_ngram:past_c_length)     0.58     0.91
    ## cor(length_center:freq_center,past_c_ngram:past_c_length)      0.69     0.95
    ## cor(Intercept,past_c_length:past_c_freq)                      -0.30     0.48
    ## cor(ngram_center,past_c_length:past_c_freq)                    0.01     0.78
    ## cor(length_center,past_c_length:past_c_freq)                  -0.75     0.18
    ## cor(freq_center,past_c_length:past_c_freq)                    -0.13     0.70
    ## cor(past_c_ngram,past_c_length:past_c_freq)                    0.17     0.85
    ## cor(past_c_length,past_c_length:past_c_freq)                  -0.62     0.41
    ## cor(past_c_freq,past_c_length:past_c_freq)                     0.19     0.85
    ## cor(ngram_center:length_center,past_c_length:past_c_freq)      0.29     0.90
    ## cor(length_center:freq_center,past_c_length:past_c_freq)       0.27     0.88
    ## cor(past_c_ngram:past_c_length,past_c_length:past_c_freq)      0.40     0.94
    ##                                                            Rhat Bulk_ESS
    ## sd(Intercept)                                              1.00      924
    ## sd(ngram_center)                                           1.00     4355
    ## sd(length_center)                                          1.00      914
    ## sd(freq_center)                                            1.00      712
    ## sd(past_c_ngram)                                           1.00     3852
    ## sd(past_c_length)                                          1.00     2395
    ## sd(past_c_freq)                                            1.00     4069
    ## sd(ngram_center:length_center)                             1.00     3590
    ## sd(length_center:freq_center)                              1.00     2351
    ## sd(past_c_ngram:past_c_length)                             1.00     3275
    ## sd(past_c_length:past_c_freq)                              1.00     2203
    ## cor(Intercept,ngram_center)                                1.00     4866
    ## cor(Intercept,length_center)                               1.00     8260
    ## cor(ngram_center,length_center)                            1.00     3984
    ## cor(Intercept,freq_center)                                 1.00     5345
    ## cor(ngram_center,freq_center)                              1.00     1580
    ## cor(length_center,freq_center)                             1.00      923
    ## cor(Intercept,past_c_ngram)                                1.00     3812
    ## cor(ngram_center,past_c_ngram)                             1.00     1628
    ## cor(length_center,past_c_ngram)                            1.00      838
    ## cor(freq_center,past_c_ngram)                              1.00     1985
    ## cor(Intercept,past_c_length)                               1.00     7962
    ## cor(ngram_center,past_c_length)                            1.00     4732
    ## cor(length_center,past_c_length)                           1.00     2244
    ## cor(freq_center,past_c_length)                             1.00     4415
    ## cor(past_c_ngram,past_c_length)                            1.00     4241
    ## cor(Intercept,past_c_freq)                                 1.00     4208
    ## cor(ngram_center,past_c_freq)                              1.01     1645
    ## cor(length_center,past_c_freq)                             1.00      721
    ## cor(freq_center,past_c_freq)                               1.00     2249
    ## cor(past_c_ngram,past_c_freq)                              1.00     3667
    ## cor(past_c_length,past_c_freq)                             1.00     4378
    ## cor(Intercept,ngram_center:length_center)                  1.00     3919
    ## cor(ngram_center,ngram_center:length_center)               1.00     1775
    ## cor(length_center,ngram_center:length_center)              1.00     1002
    ## cor(freq_center,ngram_center:length_center)                1.00     2204
    ## cor(past_c_ngram,ngram_center:length_center)               1.00     3146
    ## cor(past_c_length,ngram_center:length_center)              1.00     3462
    ## cor(past_c_freq,ngram_center:length_center)                1.00     2879
    ## cor(Intercept,length_center:freq_center)                   1.00     3856
    ## cor(ngram_center,length_center:freq_center)                1.00     1309
    ## cor(length_center,length_center:freq_center)               1.00      565
    ## cor(freq_center,length_center:freq_center)                 1.00     1951
    ## cor(past_c_ngram,length_center:freq_center)                1.00     2541
    ## cor(past_c_length,length_center:freq_center)               1.00     2573
    ## cor(past_c_freq,length_center:freq_center)                 1.00     2278
    ## cor(ngram_center:length_center,length_center:freq_center)  1.00     2772
    ## cor(Intercept,past_c_ngram:past_c_length)                  1.00     4885
    ## cor(ngram_center,past_c_ngram:past_c_length)               1.00     1830
    ## cor(length_center,past_c_ngram:past_c_length)              1.00      699
    ## cor(freq_center,past_c_ngram:past_c_length)                1.00     2667
    ## cor(past_c_ngram,past_c_ngram:past_c_length)               1.00     4000
    ## cor(past_c_length,past_c_ngram:past_c_length)              1.00     2874
    ## cor(past_c_freq,past_c_ngram:past_c_length)                1.00     3949
    ## cor(ngram_center:length_center,past_c_ngram:past_c_length) 1.00     4159
    ## cor(length_center:freq_center,past_c_ngram:past_c_length)  1.00     3951
    ## cor(Intercept,past_c_length:past_c_freq)                   1.00     6638
    ## cor(ngram_center,past_c_length:past_c_freq)                1.00     3691
    ## cor(length_center,past_c_length:past_c_freq)               1.00     1566
    ## cor(freq_center,past_c_length:past_c_freq)                 1.00     4201
    ## cor(past_c_ngram,past_c_length:past_c_freq)                1.00     3542
    ## cor(past_c_length,past_c_length:past_c_freq)               1.00     3307
    ## cor(past_c_freq,past_c_length:past_c_freq)                 1.00     3832
    ## cor(ngram_center:length_center,past_c_length:past_c_freq)  1.00     3116
    ## cor(length_center:freq_center,past_c_length:past_c_freq)   1.00     3423
    ## cor(past_c_ngram:past_c_length,past_c_length:past_c_freq)  1.00     2576
    ##                                                            Tail_ESS
    ## sd(Intercept)                                                  1847
    ## sd(ngram_center)                                               3242
    ## sd(length_center)                                              1249
    ## sd(freq_center)                                                1313
    ## sd(past_c_ngram)                                               3192
    ## sd(past_c_length)                                              2288
    ## sd(past_c_freq)                                                3506
    ## sd(ngram_center:length_center)                                 3109
    ## sd(length_center:freq_center)                                  2934
    ## sd(past_c_ngram:past_c_length)                                 2057
    ## sd(past_c_length:past_c_freq)                                  1501
    ## cor(Intercept,ngram_center)                                    3016
    ## cor(Intercept,length_center)                                   2654
    ## cor(ngram_center,length_center)                                3423
    ## cor(Intercept,freq_center)                                     2741
    ## cor(ngram_center,freq_center)                                  3123
    ## cor(length_center,freq_center)                                 1722
    ## cor(Intercept,past_c_ngram)                                    3030
    ## cor(ngram_center,past_c_ngram)                                 2400
    ## cor(length_center,past_c_ngram)                                1349
    ## cor(freq_center,past_c_ngram)                                  2747
    ## cor(Intercept,past_c_length)                                   3423
    ## cor(ngram_center,past_c_length)                                3087
    ## cor(length_center,past_c_length)                               2916
    ## cor(freq_center,past_c_length)                                 2880
    ## cor(past_c_ngram,past_c_length)                                3224
    ## cor(Intercept,past_c_freq)                                     3254
    ## cor(ngram_center,past_c_freq)                                  2476
    ## cor(length_center,past_c_freq)                                 1142
    ## cor(freq_center,past_c_freq)                                   3082
    ## cor(past_c_ngram,past_c_freq)                                  3696
    ## cor(past_c_length,past_c_freq)                                 3475
    ## cor(Intercept,ngram_center:length_center)                      3185
    ## cor(ngram_center,ngram_center:length_center)                   2438
    ## cor(length_center,ngram_center:length_center)                  1268
    ## cor(freq_center,ngram_center:length_center)                    2759
    ## cor(past_c_ngram,ngram_center:length_center)                   3703
    ## cor(past_c_length,ngram_center:length_center)                  2954
    ## cor(past_c_freq,ngram_center:length_center)                    3410
    ## cor(Intercept,length_center:freq_center)                       3302
    ## cor(ngram_center,length_center:freq_center)                    2099
    ## cor(length_center,length_center:freq_center)                    706
    ## cor(freq_center,length_center:freq_center)                     2493
    ## cor(past_c_ngram,length_center:freq_center)                    3599
    ## cor(past_c_length,length_center:freq_center)                   2682
    ## cor(past_c_freq,length_center:freq_center)                     3115
    ## cor(ngram_center:length_center,length_center:freq_center)      3485
    ## cor(Intercept,past_c_ngram:past_c_length)                      3061
    ## cor(ngram_center,past_c_ngram:past_c_length)                   2763
    ## cor(length_center,past_c_ngram:past_c_length)                   851
    ## cor(freq_center,past_c_ngram:past_c_length)                    3092
    ## cor(past_c_ngram,past_c_ngram:past_c_length)                   3488
    ## cor(past_c_length,past_c_ngram:past_c_length)                  3324
    ## cor(past_c_freq,past_c_ngram:past_c_length)                    3604
    ## cor(ngram_center:length_center,past_c_ngram:past_c_length)     3830
    ## cor(length_center:freq_center,past_c_ngram:past_c_length)      3681
    ## cor(Intercept,past_c_length:past_c_freq)                       3107
    ## cor(ngram_center,past_c_length:past_c_freq)                    2764
    ## cor(length_center,past_c_length:past_c_freq)                   2110
    ## cor(freq_center,past_c_length:past_c_freq)                     3687
    ## cor(past_c_ngram,past_c_length:past_c_freq)                    3208
    ## cor(past_c_length,past_c_length:past_c_freq)                   3713
    ## cor(past_c_freq,past_c_length:past_c_freq)                     3102
    ## cor(ngram_center:length_center,past_c_length:past_c_freq)      2211
    ## cor(length_center:freq_center,past_c_length:past_c_freq)       2854
    ## cor(past_c_ngram:past_c_length,past_c_length:past_c_freq)      2013
    ## 
    ## ~Word_ID (Number of levels: 6447) 
    ##               Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sd(Intercept)   104.88     12.91    76.81   128.50 1.00     1190     1795
    ## 
    ## Population-Level Effects: 
    ##                            Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS
    ## Intercept                    730.54     35.53   661.61   801.52 1.02      430
    ## ngram_center                   7.29      2.21     2.93    11.56 1.00     3427
    ## length_center                 15.02      4.22     7.10    23.59 1.00     7395
    ## freq_center                   -6.31      3.00   -12.09    -0.40 1.00     3586
    ## past_c_ngram                  -3.15      2.97    -8.96     2.80 1.00     3272
    ## past_c_length                  1.54      4.22    -6.85     9.71 1.00     8486
    ## past_c_freq                   -3.13      3.75   -10.40     4.33 1.00     3288
    ## ngram_center:length_center    -3.63      1.83    -7.22     0.02 1.00     3101
    ## length_center:freq_center     -4.20      2.39    -8.78     0.51 1.00     3113
    ## past_c_ngram:past_c_length    -2.04      1.10    -4.18     0.18 1.00     3987
    ## past_c_length:past_c_freq     -1.49      1.34    -4.09     1.15 1.00     5084
    ##                            Tail_ESS
    ## Intercept                       881
    ## ngram_center                   3297
    ## length_center                  3090
    ## freq_center                    3030
    ## past_c_ngram                   2818
    ## past_c_length                  3090
    ## past_c_freq                    3219
    ## ngram_center:length_center     3293
    ## length_center:freq_center      3053
    ## past_c_ngram:past_c_length     3572
    ## past_c_length:past_c_freq      3464
    ## 
    ## Family Specific Parameters: 
    ##       Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sigma  1034.50      3.52  1027.68  1041.49 1.00     3419     2675
    ## 
    ## Samples were drawn using sampling(NUTS). For each parameter, Bulk_ESS
    ## and Tail_ESS are effective sample size measures, and Rhat is the potential
    ## scale reduction factor on split chains (at convergence, Rhat = 1).

    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)
    ## `summarise()` ungrouping output (override with `.groups` argument)

    ## % latex table generated in R 4.0.3 by xtable 1.8-4 package
    ## % Mon Jan 25 17:23:53 2021
    ## \begin{table}[ht]
    ## \centering
    ## \begin{tabular}{lrlrrlrrlr}
    ##   \hline
    ## Term & E\_5-gram & CI\_5-gram & P\_5-gram & E\_GRNN & CI\_GRNN & P\_GRNN & E\_TXL & CI\_TXL & P\_TXL \\ 
    ##   \hline
    ## freq\_center & -6.3 & [-12.1, -0.4] & 0.04 & 0.2 & [-4.7, 5.1] & 0.94 & -3.3 & [-8.9, 2.2] & 0.23 \\ 
    ##   Intercept & 730.5 & [661.6, 801.5] & 0.00 & 734.2 & [665.2, 803.9] & 0.00 & 734.6 & [660.9, 808.6] & 0.00 \\ 
    ##   length\_center & 15.0 & [7.1, 23.6] & 0.00 & 14.5 & [5.2, 23.3] & 0.00 & 16.0 & [7.2, 25] & 0.00 \\ 
    ##   length\_center:freq\_center & -4.2 & [-8.8, 0.5] & 0.09 & -0.4 & [-2.5, 1.7] & 0.73 & -1.5 & [-4, 0.9] & 0.22 \\ 
    ##   past\_c\_freq & -3.1 & [-10.4, 4.3] & 0.40 & -0.8 & [-6, 4.3] & 0.79 & -1.8 & [-7.6, 4.1] & 0.55 \\ 
    ##   past\_c\_length & 1.5 & [-6.9, 9.7] & 0.72 & -1.0 & [-8.5, 7.1] & 0.80 & 0.6 & [-7.6, 8.7] & 0.89 \\ 
    ##   past\_c\_length:past\_c\_freq & -1.5 & [-4.1, 1.2] & 0.26 & -0.3 & [-2.1, 1.6] & 0.77 & -0.4 & [-2.2, 1.5] & 0.70 \\ 
    ##   past\_c\_surp & -3.2 & [-9, 2.8] & 0.28 & 0.6 & [-3.8, 5.1] & 0.79 & -1.8 & [-6.7, 3.1] & 0.47 \\ 
    ##   past\_c\_surp:past\_c\_length & -2.0 & [-4.2, 0.2] & 0.07 & -0.7 & [-2.2, 0.8] & 0.36 & -0.7 & [-2.1, 0.7] & 0.31 \\ 
    ##   surp\_center & 7.3 & [2.9, 11.6] & 0.00 & 19.0 & [14.5, 23.7] & 0.00 & 13.2 & [9.2, 17] & 0.00 \\ 
    ##   surp\_center:length\_center & -3.6 & [-7.2, 0] & 0.05 & -0.5 & [-3.4, 2.4] & 0.74 & -1.8 & [-3.2, -0.3] & 0.02 \\ 
    ##    \hline
    ## \end{tabular}
    ## \end{table}
