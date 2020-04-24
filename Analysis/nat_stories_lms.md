Natural Stories LM analysis
================

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

Surprisals are measured in bits (TODO: double check with Jenn about
these being in bits, model specs/cites\!)

  - ngram (5-gram KN smoothed)
  - GRNN
  - Transformer-XL

We sometimes center the predictors, but don’t rescale them. (We center
them for the brm models, but don’t center surprisal for the GAM model).

The model formula we use is rt ~ surp + length \* freq + past\_surp +
past\_length \* past\_freq, so we’re allowing frequency and length to
interact and including the same terms for the current and past word.

    ## Parsed with column specification:
    ## cols(
    ##   Story_Num = col_double(),
    ##   Sentence_Num = col_double(),
    ##   Sentence = col_character()
    ## )

    ## Joining, by = c("Story_Num", "Sentence_Num")

## Linear models

These use centered predictors.

Using pre-error data only.

    ## 
    ## Call:
    ## lm(formula = rt ~ ngram_center + freq_center * length_center + 
    ##     past_c_ngram + past_c_freq * past_c_length, data = labelled_pre_error)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -737.5 -207.0  -82.7   97.3 4017.6 
    ## 
    ## Coefficients:
    ##                           Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               859.6743     3.5785 240.231  < 2e-16 ***
    ## ngram_center                9.1981     0.8246  11.154  < 2e-16 ***
    ## freq_center                -4.3105     1.1305  -3.813 0.000138 ***
    ## length_center              24.1662     1.8365  13.159  < 2e-16 ***
    ## past_c_ngram                1.1050     0.8360   1.322 0.186247    
    ## past_c_freq                 2.6647     1.1277   2.363 0.018143 *  
    ## past_c_length              -2.3218     1.8129  -1.281 0.200305    
    ## freq_center:length_center   0.5044     0.3489   1.445 0.148345    
    ## past_c_freq:past_c_length  -1.3997     0.3463  -4.041 5.33e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 361.2 on 26526 degrees of freedom
    ## Multiple R-squared:  0.07361,    Adjusted R-squared:  0.07333 
    ## F-statistic: 263.5 on 8 and 26526 DF,  p-value: < 2.2e-16

    ## 
    ## Call:
    ## lm(formula = rt ~ txl_center + freq_center * length_center + 
    ##     past_c_txl + past_c_freq * past_c_length, data = labelled_pre_error)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -728.0 -206.0  -79.4   99.6 3975.9 
    ## 
    ## Coefficients:
    ##                           Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               860.5475     3.5470 242.613  < 2e-16 ***
    ## txl_center                 16.8482     0.6920  24.346  < 2e-16 ***
    ## freq_center                 0.1089     0.9569   0.114   0.9094    
    ## length_center              24.8840     1.8191  13.679  < 2e-16 ***
    ## past_c_txl                 -0.7926     0.6679  -1.187   0.2354    
    ## past_c_freq                 0.7810     0.9620   0.812   0.4169    
    ## past_c_length              -2.4777     1.7943  -1.381   0.1673    
    ## freq_center:length_center   0.5986     0.3458   1.731   0.0834 .  
    ## past_c_freq:past_c_length  -1.6786     0.3429  -4.896 9.84e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 358.1 on 26526 degrees of freedom
    ## Multiple R-squared:  0.08952,    Adjusted R-squared:  0.08925 
    ## F-statistic:   326 on 8 and 26526 DF,  p-value: < 2.2e-16

    ## 
    ## Call:
    ## lm(formula = rt ~ grnn_center + freq_center * length_center + 
    ##     past_c_grnn + past_c_freq * past_c_length, data = labelled_pre_error)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -748.8 -204.1  -78.0   99.7 3984.7 
    ## 
    ## Coefficients:
    ##                           Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               861.0180     3.5244 244.299  < 2e-16 ***
    ## grnn_center                21.6443     0.7179  30.149  < 2e-16 ***
    ## freq_center                 2.5365     0.9384   2.703  0.00687 ** 
    ## length_center              22.8653     1.8101  12.632  < 2e-16 ***
    ## past_c_grnn                 1.0790     0.6861   1.573  0.11582    
    ## past_c_freq                 1.6615     0.9335   1.780  0.07511 .  
    ## past_c_length              -3.3311     1.7854  -1.866  0.06208 .  
    ## freq_center:length_center   0.4863     0.3436   1.415  0.15699    
    ## past_c_freq:past_c_length  -1.7359     0.3408  -5.093 3.55e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 356 on 26526 degrees of freedom
    ## Multiple R-squared:  0.1002, Adjusted R-squared:  0.09996 
    ## F-statistic: 369.4 on 8 and 26526 DF,  p-value: < 2.2e-16

Including post-error data.

    ## 
    ## Call:
    ## lm(formula = rt ~ ngram_center + freq_center * length_center + 
    ##     past_c_ngram + past_c_freq * past_c_length, data = labelled_post_error)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -934.2 -208.3  -82.5   98.0 4016.5 
    ## 
    ## Coefficients:
    ##                           Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               862.5586     3.0860 279.507  < 2e-16 ***
    ## ngram_center                9.3558     0.7192  13.008  < 2e-16 ***
    ## freq_center                -3.9703     0.9777  -4.061 4.90e-05 ***
    ## length_center              26.3464     1.5804  16.670  < 2e-16 ***
    ## past_c_ngram                0.3765     0.7289   0.517   0.6055    
    ## past_c_freq                 1.9533     0.9771   1.999   0.0456 *  
    ## past_c_length              -1.8910     1.5618  -1.211   0.2260    
    ## freq_center:length_center   0.6708     0.2989   2.244   0.0248 *  
    ## past_c_freq:past_c_length  -1.2044     0.2977  -4.046 5.23e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 365.4 on 36511 degrees of freedom
    ## Multiple R-squared:  0.07601,    Adjusted R-squared:  0.07581 
    ## F-statistic: 375.4 on 8 and 36511 DF,  p-value: < 2.2e-16

    ## 
    ## Call:
    ## lm(formula = rt ~ txl_center + freq_center * length_center + 
    ##     past_c_txl + past_c_freq * past_c_length, data = labelled_post_error)
    ## 
    ## Residuals:
    ##    Min     1Q Median     3Q    Max 
    ## -996.5 -207.1  -78.8   99.3 3999.9 
    ## 
    ## Coefficients:
    ##                           Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               865.9174     3.0612 282.871  < 2e-16 ***
    ## txl_center                 16.9830     0.5961  28.491  < 2e-16 ***
    ## freq_center                 0.2125     0.8187   0.260  0.79523    
    ## length_center              27.1855     1.5652  17.369  < 2e-16 ***
    ## past_c_txl                 -0.5753     0.5785  -0.995  0.31997    
    ## past_c_freq                 0.8754     0.8265   1.059  0.28949    
    ## past_c_length              -2.1102     1.5455  -1.365  0.17214    
    ## freq_center:length_center   0.7667     0.2961   2.590  0.00962 ** 
    ## past_c_freq:past_c_length  -1.4335     0.2947  -4.865 1.15e-06 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 362.2 on 36511 degrees of freedom
    ## Multiple R-squared:  0.09197,    Adjusted R-squared:  0.09177 
    ## F-statistic: 462.2 on 8 and 36511 DF,  p-value: < 2.2e-16

    ## 
    ## Call:
    ## lm(formula = rt ~ grnn_center + freq_center * length_center + 
    ##     past_c_grnn + past_c_freq * past_c_length, data = labelled_post_error)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -1031.1  -205.3   -77.7    99.5  4025.1 
    ## 
    ## Coefficients:
    ##                           Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)               865.0481     3.0415 284.411  < 2e-16 ***
    ## grnn_center                21.7102     0.6208  34.972  < 2e-16 ***
    ## freq_center                 2.6706     0.8062   3.313 0.000925 ***
    ## length_center              25.1371     1.5578  16.136  < 2e-16 ***
    ## past_c_grnn                 1.1226     0.5974   1.879 0.060240 .  
    ## past_c_freq                 1.6965     0.8064   2.104 0.035396 *  
    ## past_c_length              -2.9614     1.5382  -1.925 0.054208 .  
    ## freq_center:length_center   0.6863     0.2943   2.332 0.019708 *  
    ## past_c_freq:past_c_length  -1.5132     0.2931  -5.162 2.45e-07 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 360.2 on 36511 degrees of freedom
    ## Multiple R-squared:  0.1021, Adjusted R-squared:  0.1019 
    ## F-statistic: 518.8 on 8 and 36511 DF,  p-value: < 2.2e-16

## BRM models

We include a by-subject effect for everything. Technically speaking, we
do have repeated measures at the word level, but there are 10K or so
words and at most a handful of copies of each word, so that’s likely to
get us not very much at the cost of making the model rather intractable
(and so I’m not going to deal with it, at least not right now).

Priors:

  - normal(1000,1000) for intercept – we think RTs are about 1 second
    usually
  - normal(0,500) for beta and sd – we don’t really know what effects
    are
  - lkj(1) for correlations – we don’t have reason to think correlations
    might go any particular way

<!-- end list -->

    ##  Family: gaussian 
    ##   Links: mu = identity; sigma = identity 
    ## Formula: rt ~ txl_center + freq_center * length_center + past_c_txl + past_c_freq * past_c_length + (txl_center + freq_center * length_center + past_c_txl + past_c_freq * past_c_length | subject) 
    ##    Data: labelled_pre_error (Number of observations: 26535) 
    ## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
    ##          total post-warmup samples = 4000
    ## 
    ## Group-Level Effects: 
    ## ~subject (Number of levels: 63) 
    ##                                                          Estimate Est.Error
    ## sd(Intercept)                                              136.96     12.86
    ## sd(txl_center)                                               6.80      0.93
    ## sd(freq_center)                                              8.84      1.34
    ## sd(length_center)                                           11.06      2.27
    ## sd(past_c_txl)                                               1.60      0.77
    ## sd(past_c_freq)                                              2.11      1.12
    ## sd(past_c_length)                                            5.69      2.15
    ## sd(freq_center:length_center)                                1.20      0.57
    ## sd(past_c_freq:past_c_length)                                1.32      0.48
    ## cor(Intercept,txl_center)                                    0.51      0.12
    ## cor(Intercept,freq_center)                                  -0.19      0.14
    ## cor(txl_center,freq_center)                                  0.12      0.17
    ## cor(Intercept,length_center)                                 0.11      0.17
    ## cor(txl_center,length_center)                               -0.31      0.18
    ## cor(freq_center,length_center)                              -0.12      0.21
    ## cor(Intercept,past_c_txl)                                    0.31      0.25
    ## cor(txl_center,past_c_txl)                                   0.17      0.26
    ## cor(freq_center,past_c_txl)                                  0.18      0.27
    ## cor(length_center,past_c_txl)                               -0.00      0.27
    ## cor(Intercept,past_c_freq)                                   0.17      0.26
    ## cor(txl_center,past_c_freq)                                  0.02      0.26
    ## cor(freq_center,past_c_freq)                                -0.26      0.27
    ## cor(length_center,past_c_freq)                               0.02      0.28
    ## cor(past_c_txl,past_c_freq)                                  0.04      0.30
    ## cor(Intercept,past_c_length)                                -0.27      0.22
    ## cor(txl_center,past_c_length)                               -0.24      0.24
    ## cor(freq_center,past_c_length)                              -0.13      0.25
    ## cor(length_center,past_c_length)                             0.38      0.24
    ## cor(past_c_txl,past_c_length)                               -0.19      0.28
    ## cor(past_c_freq,past_c_length)                               0.05      0.29
    ## cor(Intercept,freq_center:length_center)                    -0.28      0.23
    ## cor(txl_center,freq_center:length_center)                   -0.24      0.25
    ## cor(freq_center,freq_center:length_center)                  -0.02      0.25
    ## cor(length_center,freq_center:length_center)                 0.05      0.27
    ## cor(past_c_txl,freq_center:length_center)                   -0.13      0.29
    ## cor(past_c_freq,freq_center:length_center)                  -0.15      0.29
    ## cor(past_c_length,freq_center:length_center)                 0.10      0.29
    ## cor(Intercept,past_c_freq:past_c_length)                    -0.33      0.21
    ## cor(txl_center,past_c_freq:past_c_length)                   -0.38      0.22
    ## cor(freq_center,past_c_freq:past_c_length)                  -0.15      0.23
    ## cor(length_center,past_c_freq:past_c_length)                 0.29      0.24
    ## cor(past_c_txl,past_c_freq:past_c_length)                   -0.12      0.29
    ## cor(past_c_freq,past_c_freq:past_c_length)                  -0.14      0.29
    ## cor(past_c_length,past_c_freq:past_c_length)                 0.55      0.26
    ## cor(freq_center:length_center,past_c_freq:past_c_length)     0.30      0.28
    ##                                                          l-95% CI u-95% CI Rhat
    ## sd(Intercept)                                              114.28   164.45 1.00
    ## sd(txl_center)                                               5.10     8.74 1.00
    ## sd(freq_center)                                              6.42    11.62 1.00
    ## sd(length_center)                                            6.80    15.70 1.00
    ## sd(past_c_txl)                                               0.18     3.11 1.00
    ## sd(past_c_freq)                                              0.14     4.28 1.00
    ## sd(past_c_length)                                            1.09     9.75 1.00
    ## sd(freq_center:length_center)                                0.12     2.28 1.01
    ## sd(past_c_freq:past_c_length)                                0.26     2.20 1.00
    ## cor(Intercept,txl_center)                                    0.26     0.72 1.00
    ## cor(Intercept,freq_center)                                  -0.46     0.11 1.00
    ## cor(txl_center,freq_center)                                 -0.25     0.42 1.00
    ## cor(Intercept,length_center)                                -0.24     0.43 1.00
    ## cor(txl_center,length_center)                               -0.64     0.07 1.00
    ## cor(freq_center,length_center)                              -0.53     0.28 1.00
    ## cor(Intercept,past_c_txl)                                   -0.22     0.73 1.00
    ## cor(txl_center,past_c_txl)                                  -0.36     0.65 1.00
    ## cor(freq_center,past_c_txl)                                 -0.39     0.67 1.00
    ## cor(length_center,past_c_txl)                               -0.53     0.53 1.00
    ## cor(Intercept,past_c_freq)                                  -0.38     0.65 1.00
    ## cor(txl_center,past_c_freq)                                 -0.49     0.53 1.00
    ## cor(freq_center,past_c_freq)                                -0.72     0.33 1.00
    ## cor(length_center,past_c_freq)                              -0.52     0.56 1.00
    ## cor(past_c_txl,past_c_freq)                                 -0.56     0.60 1.00
    ## cor(Intercept,past_c_length)                                -0.66     0.19 1.00
    ## cor(txl_center,past_c_length)                               -0.65     0.26 1.00
    ## cor(freq_center,past_c_length)                              -0.59     0.38 1.00
    ## cor(length_center,past_c_length)                            -0.18     0.77 1.00
    ## cor(past_c_txl,past_c_length)                               -0.70     0.41 1.00
    ## cor(past_c_freq,past_c_length)                              -0.52     0.60 1.00
    ## cor(Intercept,freq_center:length_center)                    -0.67     0.21 1.00
    ## cor(txl_center,freq_center:length_center)                   -0.68     0.30 1.00
    ## cor(freq_center,freq_center:length_center)                  -0.51     0.47 1.00
    ## cor(length_center,freq_center:length_center)                -0.51     0.54 1.00
    ## cor(past_c_txl,freq_center:length_center)                   -0.66     0.46 1.00
    ## cor(past_c_freq,freq_center:length_center)                  -0.67     0.45 1.00
    ## cor(past_c_length,freq_center:length_center)                -0.46     0.63 1.00
    ## cor(Intercept,past_c_freq:past_c_length)                    -0.70     0.09 1.00
    ## cor(txl_center,past_c_freq:past_c_length)                   -0.76     0.11 1.00
    ## cor(freq_center,past_c_freq:past_c_length)                  -0.58     0.31 1.00
    ## cor(length_center,past_c_freq:past_c_length)                -0.22     0.70 1.00
    ## cor(past_c_txl,past_c_freq:past_c_length)                   -0.67     0.45 1.00
    ## cor(past_c_freq,past_c_freq:past_c_length)                  -0.66     0.44 1.00
    ## cor(past_c_length,past_c_freq:past_c_length)                -0.12     0.88 1.00
    ## cor(freq_center:length_center,past_c_freq:past_c_length)    -0.32     0.75 1.00
    ##                                                          Bulk_ESS Tail_ESS
    ## sd(Intercept)                                                 614     1249
    ## sd(txl_center)                                               2117     3210
    ## sd(freq_center)                                              1353     1977
    ## sd(length_center)                                            1455     1629
    ## sd(past_c_txl)                                               1408     1671
    ## sd(past_c_freq)                                              1189     1690
    ## sd(past_c_length)                                             794      686
    ## sd(freq_center:length_center)                                 736      916
    ## sd(past_c_freq:past_c_length)                                 752      507
    ## cor(Intercept,txl_center)                                    2338     3133
    ## cor(Intercept,freq_center)                                   2314     2815
    ## cor(txl_center,freq_center)                                  1138     2563
    ## cor(Intercept,length_center)                                 3877     3056
    ## cor(txl_center,length_center)                                2368     2250
    ## cor(freq_center,length_center)                               2356     3117
    ## cor(Intercept,past_c_txl)                                    4780     2939
    ## cor(txl_center,past_c_txl)                                   4483     3279
    ## cor(freq_center,past_c_txl)                                  3590     3279
    ## cor(length_center,past_c_txl)                                4651     2905
    ## cor(Intercept,past_c_freq)                                   3607     2923
    ## cor(txl_center,past_c_freq)                                  3929     2800
    ## cor(freq_center,past_c_freq)                                 3060     2758
    ## cor(length_center,past_c_freq)                               3820     3098
    ## cor(past_c_txl,past_c_freq)                                  2945     3219
    ## cor(Intercept,past_c_length)                                 3695     2549
    ## cor(txl_center,past_c_length)                                2938     2137
    ## cor(freq_center,past_c_length)                               3394     2924
    ## cor(length_center,past_c_length)                             2179     2018
    ## cor(past_c_txl,past_c_length)                                2964     3108
    ## cor(past_c_freq,past_c_length)                               3219     3058
    ## cor(Intercept,freq_center:length_center)                     4660     2849
    ## cor(txl_center,freq_center:length_center)                    2916     2547
    ## cor(freq_center,freq_center:length_center)                   4111     3317
    ## cor(length_center,freq_center:length_center)                 2498     2745
    ## cor(past_c_txl,freq_center:length_center)                    1877     3030
    ## cor(past_c_freq,freq_center:length_center)                   2136     2836
    ## cor(past_c_length,freq_center:length_center)                 2213     3101
    ## cor(Intercept,past_c_freq:past_c_length)                     2961     1999
    ## cor(txl_center,past_c_freq:past_c_length)                    2091     1730
    ## cor(freq_center,past_c_freq:past_c_length)                   3083     2426
    ## cor(length_center,past_c_freq:past_c_length)                 2115     2450
    ## cor(past_c_txl,past_c_freq:past_c_length)                    2227     2772
    ## cor(past_c_freq,past_c_freq:past_c_length)                   2253     2961
    ## cor(past_c_length,past_c_freq:past_c_length)                 1162     1044
    ## cor(freq_center:length_center,past_c_freq:past_c_length)     1360     2368
    ## 
    ## Population-Level Effects: 
    ##                           Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS
    ## Intercept                   866.47     17.73   830.42   900.70 1.01      243
    ## txl_center                   16.97      1.14    14.76    19.21 1.00      925
    ## freq_center                  -0.78      1.47    -3.65     2.19 1.00     2072
    ## length_center                20.81      2.26    16.37    25.29 1.00     3227
    ## past_c_txl                    0.05      0.65    -1.16     1.34 1.00     5094
    ## past_c_freq                   0.89      0.94    -0.95     2.79 1.00     4523
    ## past_c_length                -5.29      1.85    -8.95    -1.71 1.00     3301
    ## freq_center:length_center     1.21      0.37     0.48     1.95 1.00     3692
    ## past_c_freq:past_c_length    -1.24      0.36    -1.94    -0.52 1.00     3128
    ##                           Tail_ESS
    ## Intercept                      553
    ## txl_center                    1789
    ## freq_center                   2289
    ## length_center                 2992
    ## past_c_txl                    3152
    ## past_c_freq                   3242
    ## past_c_length                 3344
    ## freq_center:length_center     2671
    ## past_c_freq:past_c_length     3374
    ## 
    ## Family Specific Parameters: 
    ##       Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sigma   325.93      1.39   323.25   328.65 1.00     8618     2936
    ## 
    ## Samples were drawn using sampling(NUTS). For each parameter, Bulk_ESS
    ## and Tail_ESS are effective sample size measures, and Rhat is the potential
    ## scale reduction factor on split chains (at convergence, Rhat = 1).

    ##  Family: gaussian 
    ##   Links: mu = identity; sigma = identity 
    ## Formula: rt ~ grnn_center + freq_center * length_center + past_c_grnn + past_c_freq * past_c_length + (grnn_center + freq_center * length_center + past_c_grnn + past_c_freq * past_c_length | subject) 
    ##    Data: labelled_pre_error (Number of observations: 26535) 
    ## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
    ##          total post-warmup samples = 4000
    ## 
    ## Group-Level Effects: 
    ## ~subject (Number of levels: 63) 
    ##                                                          Estimate Est.Error
    ## sd(Intercept)                                              137.54     12.81
    ## sd(grnn_center)                                              7.77      1.02
    ## sd(freq_center)                                              9.17      1.38
    ## sd(length_center)                                           11.45      2.21
    ## sd(past_c_grnn)                                              1.96      0.87
    ## sd(past_c_freq)                                              1.41      0.98
    ## sd(past_c_length)                                            5.81      2.02
    ## sd(freq_center:length_center)                                1.29      0.55
    ## sd(past_c_freq:past_c_length)                                1.25      0.45
    ## cor(Intercept,grnn_center)                                   0.53      0.11
    ## cor(Intercept,freq_center)                                  -0.14      0.14
    ## cor(grnn_center,freq_center)                                 0.20      0.16
    ## cor(Intercept,length_center)                                 0.09      0.17
    ## cor(grnn_center,length_center)                              -0.31      0.18
    ## cor(freq_center,length_center)                              -0.13      0.20
    ## cor(Intercept,past_c_grnn)                                   0.22      0.24
    ## cor(grnn_center,past_c_grnn)                                 0.32      0.24
    ## cor(freq_center,past_c_grnn)                                 0.23      0.26
    ## cor(length_center,past_c_grnn)                              -0.12      0.27
    ## cor(Intercept,past_c_freq)                                   0.08      0.28
    ## cor(grnn_center,past_c_freq)                                -0.06      0.29
    ## cor(freq_center,past_c_freq)                                -0.18      0.30
    ## cor(length_center,past_c_freq)                               0.12      0.31
    ## cor(past_c_grnn,past_c_freq)                                -0.04      0.31
    ## cor(Intercept,past_c_length)                                -0.29      0.21
    ## cor(grnn_center,past_c_length)                              -0.27      0.22
    ## cor(freq_center,past_c_length)                              -0.10      0.23
    ## cor(length_center,past_c_length)                             0.42      0.22
    ## cor(past_c_grnn,past_c_length)                              -0.19      0.27
    ## cor(past_c_freq,past_c_length)                               0.16      0.31
    ## cor(Intercept,freq_center:length_center)                    -0.32      0.22
    ## cor(grnn_center,freq_center:length_center)                  -0.19      0.24
    ## cor(freq_center,freq_center:length_center)                   0.03      0.24
    ## cor(length_center,freq_center:length_center)                 0.06      0.26
    ## cor(past_c_grnn,freq_center:length_center)                   0.06      0.28
    ## cor(past_c_freq,freq_center:length_center)                  -0.10      0.31
    ## cor(past_c_length,freq_center:length_center)                 0.07      0.28
    ## cor(Intercept,past_c_freq:past_c_length)                    -0.35      0.21
    ## cor(grnn_center,past_c_freq:past_c_length)                  -0.28      0.22
    ## cor(freq_center,past_c_freq:past_c_length)                  -0.05      0.23
    ## cor(length_center,past_c_freq:past_c_length)                 0.28      0.24
    ## cor(past_c_grnn,past_c_freq:past_c_length)                   0.05      0.28
    ## cor(past_c_freq,past_c_freq:past_c_length)                  -0.01      0.30
    ## cor(past_c_length,past_c_freq:past_c_length)                 0.54      0.24
    ## cor(freq_center:length_center,past_c_freq:past_c_length)     0.30      0.27
    ##                                                          l-95% CI u-95% CI Rhat
    ## sd(Intercept)                                              114.59   165.57 1.01
    ## sd(grnn_center)                                              5.97     9.95 1.00
    ## sd(freq_center)                                              6.65    12.01 1.00
    ## sd(length_center)                                            7.49    15.96 1.00
    ## sd(past_c_grnn)                                              0.24     3.58 1.00
    ## sd(past_c_freq)                                              0.05     3.70 1.00
    ## sd(past_c_length)                                            1.50     9.75 1.01
    ## sd(freq_center:length_center)                                0.15     2.34 1.00
    ## sd(past_c_freq:past_c_length)                                0.34     2.13 1.01
    ## cor(Intercept,grnn_center)                                   0.29     0.73 1.00
    ## cor(Intercept,freq_center)                                  -0.41     0.15 1.00
    ## cor(grnn_center,freq_center)                                -0.13     0.48 1.00
    ## cor(Intercept,length_center)                                -0.25     0.41 1.00
    ## cor(grnn_center,length_center)                              -0.64     0.06 1.00
    ## cor(freq_center,length_center)                              -0.53     0.27 1.00
    ## cor(Intercept,past_c_grnn)                                  -0.28     0.63 1.00
    ## cor(grnn_center,past_c_grnn)                                -0.20     0.72 1.00
    ## cor(freq_center,past_c_grnn)                                -0.31     0.68 1.00
    ## cor(length_center,past_c_grnn)                              -0.60     0.42 1.00
    ## cor(Intercept,past_c_freq)                                  -0.48     0.60 1.00
    ## cor(grnn_center,past_c_freq)                                -0.59     0.54 1.00
    ## cor(freq_center,past_c_freq)                                -0.69     0.48 1.00
    ## cor(length_center,past_c_freq)                              -0.49     0.67 1.00
    ## cor(past_c_grnn,past_c_freq)                                -0.62     0.55 1.00
    ## cor(Intercept,past_c_length)                                -0.67     0.15 1.00
    ## cor(grnn_center,past_c_length)                              -0.67     0.20 1.00
    ## cor(freq_center,past_c_length)                              -0.54     0.38 1.00
    ## cor(length_center,past_c_length)                            -0.06     0.79 1.00
    ## cor(past_c_grnn,past_c_length)                              -0.67     0.38 1.00
    ## cor(past_c_freq,past_c_length)                              -0.49     0.68 1.00
    ## cor(Intercept,freq_center:length_center)                    -0.71     0.14 1.00
    ## cor(grnn_center,freq_center:length_center)                  -0.62     0.32 1.00
    ## cor(freq_center,freq_center:length_center)                  -0.45     0.49 1.00
    ## cor(length_center,freq_center:length_center)                -0.45     0.53 1.00
    ## cor(past_c_grnn,freq_center:length_center)                  -0.52     0.59 1.00
    ## cor(past_c_freq,freq_center:length_center)                  -0.66     0.53 1.00
    ## cor(past_c_length,freq_center:length_center)                -0.50     0.60 1.00
    ## cor(Intercept,past_c_freq:past_c_length)                    -0.73     0.10 1.00
    ## cor(grnn_center,past_c_freq:past_c_length)                  -0.68     0.17 1.00
    ## cor(freq_center,past_c_freq:past_c_length)                  -0.49     0.41 1.00
    ## cor(length_center,past_c_freq:past_c_length)                -0.24     0.70 1.00
    ## cor(past_c_grnn,past_c_freq:past_c_length)                  -0.49     0.58 1.00
    ## cor(past_c_freq,past_c_freq:past_c_length)                  -0.59     0.55 1.00
    ## cor(past_c_length,past_c_freq:past_c_length)                -0.06     0.87 1.00
    ## cor(freq_center:length_center,past_c_freq:past_c_length)    -0.29     0.75 1.00
    ##                                                          Bulk_ESS Tail_ESS
    ## sd(Intercept)                                                 482     1199
    ## sd(grnn_center)                                              2270     2900
    ## sd(freq_center)                                              1491     2517
    ## sd(length_center)                                            1735     2447
    ## sd(past_c_grnn)                                              1174     1006
    ## sd(past_c_freq)                                              1189     1789
    ## sd(past_c_length)                                            1119      808
    ## sd(freq_center:length_center)                                 950     1197
    ## sd(past_c_freq:past_c_length)                                1151     1232
    ## cor(Intercept,grnn_center)                                   2129     2495
    ## cor(Intercept,freq_center)                                   2250     2578
    ## cor(grnn_center,freq_center)                                 1309     2104
    ## cor(Intercept,length_center)                                 3374     2713
    ## cor(grnn_center,length_center)                               2416     2794
    ## cor(freq_center,length_center)                               2087     2522
    ## cor(Intercept,past_c_grnn)                                   4334     2667
    ## cor(grnn_center,past_c_grnn)                                 3706     2454
    ## cor(freq_center,past_c_grnn)                                 3803     2526
    ## cor(length_center,past_c_grnn)                               3462     3092
    ## cor(Intercept,past_c_freq)                                   5869     3126
    ## cor(grnn_center,past_c_freq)                                 5331     2790
    ## cor(freq_center,past_c_freq)                                 4695     3169
    ## cor(length_center,past_c_freq)                               4308     3385
    ## cor(past_c_grnn,past_c_freq)                                 4189     3480
    ## cor(Intercept,past_c_length)                                 3971     2585
    ## cor(grnn_center,past_c_length)                               3846     3107
    ## cor(freq_center,past_c_length)                               3247     3415
    ## cor(length_center,past_c_length)                             2667     2862
    ## cor(past_c_grnn,past_c_length)                               2949     3253
    ## cor(past_c_freq,past_c_length)                               2734     3332
    ## cor(Intercept,freq_center:length_center)                     4153     3031
    ## cor(grnn_center,freq_center:length_center)                   3685     2850
    ## cor(freq_center,freq_center:length_center)                   3695     2711
    ## cor(length_center,freq_center:length_center)                 2657     3190
    ## cor(past_c_grnn,freq_center:length_center)                   1878     2783
    ## cor(past_c_freq,freq_center:length_center)                   1959     2699
    ## cor(past_c_length,freq_center:length_center)                 2458     2759
    ## cor(Intercept,past_c_freq:past_c_length)                     3955     2741
    ## cor(grnn_center,past_c_freq:past_c_length)                   3417     2505
    ## cor(freq_center,past_c_freq:past_c_length)                   3681     3042
    ## cor(length_center,past_c_freq:past_c_length)                 2613     3197
    ## cor(past_c_grnn,past_c_freq:past_c_length)                   2489     3227
    ## cor(past_c_freq,past_c_freq:past_c_length)                   2813     3303
    ## cor(past_c_length,past_c_freq:past_c_length)                 1537     1620
    ## cor(freq_center:length_center,past_c_freq:past_c_length)     2367     2879
    ## 
    ## Population-Level Effects: 
    ##                           Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS
    ## Intercept                   868.46     16.82   835.41   903.01 1.01      278
    ## grnn_center                  22.10      1.19    19.76    24.45 1.00     1228
    ## freq_center                   1.70      1.47    -1.23     4.57 1.00     1901
    ## length_center                18.02      2.26    13.57    22.37 1.00     3417
    ## past_c_grnn                   1.92      0.69     0.58     3.27 1.00     4705
    ## past_c_freq                   1.53      0.90    -0.19     3.34 1.00     4953
    ## past_c_length                -6.92      1.83   -10.48    -3.32 1.00     3146
    ## freq_center:length_center     1.20      0.37     0.44     1.90 1.00     4208
    ## past_c_freq:past_c_length    -1.26      0.35    -1.94    -0.56 1.00     2996
    ##                           Tail_ESS
    ## Intercept                      495
    ## grnn_center                   2363
    ## freq_center                   2508
    ## length_center                 2533
    ## past_c_grnn                   3215
    ## past_c_freq                   2962
    ## past_c_length                 2897
    ## freq_center:length_center     3176
    ## past_c_freq:past_c_length     3096
    ## 
    ## Family Specific Parameters: 
    ##       Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sigma   323.33      1.41   320.55   326.07 1.00     8435     2827
    ## 
    ## Samples were drawn using sampling(NUTS). For each parameter, Bulk_ESS
    ## and Tail_ESS are effective sample size measures, and Rhat is the potential
    ## scale reduction factor on split chains (at convergence, Rhat = 1).

    ##  Family: gaussian 
    ##   Links: mu = identity; sigma = identity 
    ## Formula: rt ~ ngram_center + freq_center * length_center + past_c_ngram + past_c_freq * past_c_length + (ngram_center + freq_center * length_center + past_c_ngram + past_c_freq * past_c_length | subject) 
    ##    Data: labelled_pre_error (Number of observations: 26535) 
    ## Samples: 4 chains, each with iter = 2000; warmup = 1000; thin = 1;
    ##          total post-warmup samples = 4000
    ## 
    ## Group-Level Effects: 
    ## ~subject (Number of levels: 63) 
    ##                                                          Estimate Est.Error
    ## sd(Intercept)                                              137.16     12.96
    ## sd(ngram_center)                                             5.00      1.08
    ## sd(freq_center)                                              9.41      1.51
    ## sd(length_center)                                           11.79      2.25
    ## sd(past_c_ngram)                                             0.82      0.63
    ## sd(past_c_freq)                                              1.94      1.16
    ## sd(past_c_length)                                            5.62      2.14
    ## sd(freq_center:length_center)                                1.34      0.57
    ## sd(past_c_freq:past_c_length)                                1.24      0.47
    ## cor(Intercept,ngram_center)                                  0.56      0.15
    ## cor(Intercept,freq_center)                                  -0.19      0.15
    ## cor(ngram_center,freq_center)                                0.06      0.21
    ## cor(Intercept,length_center)                                 0.04      0.17
    ## cor(ngram_center,length_center)                             -0.00      0.22
    ## cor(freq_center,length_center)                               0.17      0.20
    ## cor(Intercept,past_c_ngram)                                  0.03      0.30
    ## cor(ngram_center,past_c_ngram)                              -0.02      0.31
    ## cor(freq_center,past_c_ngram)                                0.03      0.31
    ## cor(length_center,past_c_ngram)                             -0.06      0.31
    ## cor(Intercept,past_c_freq)                                   0.10      0.26
    ## cor(ngram_center,past_c_freq)                                0.13      0.29
    ## cor(freq_center,past_c_freq)                                -0.22      0.27
    ## cor(length_center,past_c_freq)                              -0.08      0.29
    ## cor(past_c_ngram,past_c_freq)                                0.05      0.32
    ## cor(Intercept,past_c_length)                                -0.23      0.22
    ## cor(ngram_center,past_c_length)                             -0.02      0.25
    ## cor(freq_center,past_c_length)                               0.07      0.24
    ## cor(length_center,past_c_length)                             0.42      0.23
    ## cor(past_c_ngram,past_c_length)                             -0.11      0.30
    ## cor(past_c_freq,past_c_length)                               0.03      0.30
    ## cor(Intercept,freq_center:length_center)                    -0.31      0.22
    ## cor(ngram_center,freq_center:length_center)                 -0.20      0.26
    ## cor(freq_center,freq_center:length_center)                   0.06      0.24
    ## cor(length_center,freq_center:length_center)                 0.01      0.25
    ## cor(past_c_ngram,freq_center:length_center)                  0.03      0.31
    ## cor(past_c_freq,freq_center:length_center)                  -0.11      0.29
    ## cor(past_c_length,freq_center:length_center)                 0.05      0.28
    ## cor(Intercept,past_c_freq:past_c_length)                    -0.32      0.22
    ## cor(ngram_center,past_c_freq:past_c_length)                 -0.17      0.25
    ## cor(freq_center,past_c_freq:past_c_length)                   0.05      0.23
    ## cor(length_center,past_c_freq:past_c_length)                 0.33      0.24
    ## cor(past_c_ngram,past_c_freq:past_c_length)                 -0.03      0.31
    ## cor(past_c_freq,past_c_freq:past_c_length)                  -0.15      0.29
    ## cor(past_c_length,past_c_freq:past_c_length)                 0.54      0.26
    ## cor(freq_center:length_center,past_c_freq:past_c_length)     0.24      0.27
    ##                                                          l-95% CI u-95% CI Rhat
    ## sd(Intercept)                                              114.24   164.36 1.00
    ## sd(ngram_center)                                             2.96     7.22 1.00
    ## sd(freq_center)                                              6.61    12.47 1.00
    ## sd(length_center)                                            7.58    16.46 1.00
    ## sd(past_c_ngram)                                             0.03     2.30 1.00
    ## sd(past_c_freq)                                              0.10     4.38 1.00
    ## sd(past_c_length)                                            1.10     9.54 1.01
    ## sd(freq_center:length_center)                                0.17     2.43 1.01
    ## sd(past_c_freq:past_c_length)                                0.26     2.13 1.01
    ## cor(Intercept,ngram_center)                                  0.25     0.82 1.00
    ## cor(Intercept,freq_center)                                  -0.48     0.11 1.00
    ## cor(ngram_center,freq_center)                               -0.39     0.43 1.01
    ## cor(Intercept,length_center)                                -0.30     0.37 1.00
    ## cor(ngram_center,length_center)                             -0.44     0.44 1.00
    ## cor(freq_center,length_center)                              -0.24     0.53 1.00
    ## cor(Intercept,past_c_ngram)                                 -0.56     0.60 1.00
    ## cor(ngram_center,past_c_ngram)                              -0.60     0.58 1.00
    ## cor(freq_center,past_c_ngram)                               -0.55     0.61 1.00
    ## cor(length_center,past_c_ngram)                             -0.63     0.55 1.00
    ## cor(Intercept,past_c_freq)                                  -0.46     0.59 1.00
    ## cor(ngram_center,past_c_freq)                               -0.46     0.63 1.00
    ## cor(freq_center,past_c_freq)                                -0.71     0.35 1.00
    ## cor(length_center,past_c_freq)                              -0.61     0.50 1.00
    ## cor(past_c_ngram,past_c_freq)                               -0.57     0.63 1.00
    ## cor(Intercept,past_c_length)                                -0.63     0.23 1.00
    ## cor(ngram_center,past_c_length)                             -0.51     0.48 1.00
    ## cor(freq_center,past_c_length)                              -0.42     0.53 1.00
    ## cor(length_center,past_c_length)                            -0.11     0.79 1.00
    ## cor(past_c_ngram,past_c_length)                             -0.66     0.50 1.00
    ## cor(past_c_freq,past_c_length)                              -0.57     0.58 1.00
    ## cor(Intercept,freq_center:length_center)                    -0.71     0.14 1.00
    ## cor(ngram_center,freq_center:length_center)                 -0.67     0.33 1.00
    ## cor(freq_center,freq_center:length_center)                  -0.42     0.51 1.00
    ## cor(length_center,freq_center:length_center)                -0.51     0.48 1.00
    ## cor(past_c_ngram,freq_center:length_center)                 -0.56     0.63 1.00
    ## cor(past_c_freq,freq_center:length_center)                  -0.63     0.49 1.00
    ## cor(past_c_length,freq_center:length_center)                -0.49     0.57 1.00
    ## cor(Intercept,past_c_freq:past_c_length)                    -0.70     0.14 1.00
    ## cor(ngram_center,past_c_freq:past_c_length)                 -0.64     0.35 1.00
    ## cor(freq_center,past_c_freq:past_c_length)                  -0.41     0.51 1.00
    ## cor(length_center,past_c_freq:past_c_length)                -0.19     0.73 1.00
    ## cor(past_c_ngram,past_c_freq:past_c_length)                 -0.61     0.56 1.00
    ## cor(past_c_freq,past_c_freq:past_c_length)                  -0.68     0.44 1.00
    ## cor(past_c_length,past_c_freq:past_c_length)                -0.13     0.88 1.00
    ## cor(freq_center:length_center,past_c_freq:past_c_length)    -0.36     0.70 1.00
    ##                                                          Bulk_ESS Tail_ESS
    ## sd(Intercept)                                                 487     1044
    ## sd(ngram_center)                                             1977     2623
    ## sd(freq_center)                                               889     2089
    ## sd(length_center)                                            1688     2540
    ## sd(past_c_ngram)                                             2633     2271
    ## sd(past_c_freq)                                              1136     1390
    ## sd(past_c_length)                                            1109      931
    ## sd(freq_center:length_center)                                 513      490
    ## sd(past_c_freq:past_c_length)                                1050      928
    ## cor(Intercept,ngram_center)                                  3288     2688
    ## cor(Intercept,freq_center)                                   2245     2849
    ## cor(ngram_center,freq_center)                                 682     1354
    ## cor(Intercept,length_center)                                 3463     3406
    ## cor(ngram_center,length_center)                              1351     2307
    ## cor(freq_center,length_center)                               1711     2563
    ## cor(Intercept,past_c_ngram)                                  8006     2634
    ## cor(ngram_center,past_c_ngram)                               7008     2885
    ## cor(freq_center,past_c_ngram)                                5633     2896
    ## cor(length_center,past_c_ngram)                              5482     3104
    ## cor(Intercept,past_c_freq)                                   5398     3159
    ## cor(ngram_center,past_c_freq)                                4289     2766
    ## cor(freq_center,past_c_freq)                                 4052     3025
    ## cor(length_center,past_c_freq)                               3949     2991
    ## cor(past_c_ngram,past_c_freq)                                2764     3512
    ## cor(Intercept,past_c_length)                                 4782     3179
    ## cor(ngram_center,past_c_length)                              3318     2845
    ## cor(freq_center,past_c_length)                               4074     3501
    ## cor(length_center,past_c_length)                             2467     2489
    ## cor(past_c_ngram,past_c_length)                              2607     3420
    ## cor(past_c_freq,past_c_length)                               3031     3185
    ## cor(Intercept,freq_center:length_center)                     3353     1468
    ## cor(ngram_center,freq_center:length_center)                  2339     3160
    ## cor(freq_center,freq_center:length_center)                   3505     3223
    ## cor(length_center,freq_center:length_center)                 2855     2645
    ## cor(past_c_ngram,freq_center:length_center)                  1721     2633
    ## cor(past_c_freq,freq_center:length_center)                   1405     2367
    ## cor(past_c_length,freq_center:length_center)                 2399     3282
    ## cor(Intercept,past_c_freq:past_c_length)                     3440     2196
    ## cor(ngram_center,past_c_freq:past_c_length)                  2769     2180
    ## cor(freq_center,past_c_freq:past_c_length)                   3340     2772
    ## cor(length_center,past_c_freq:past_c_length)                 2441     2460
    ## cor(past_c_ngram,past_c_freq:past_c_length)                  2620     2655
    ## cor(past_c_freq,past_c_freq:past_c_length)                   2451     2784
    ## cor(past_c_length,past_c_freq:past_c_length)                 1381     1404
    ## cor(freq_center:length_center,past_c_freq:past_c_length)     2172     2394
    ## 
    ## Population-Level Effects: 
    ##                           Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS
    ## Intercept                   867.67     18.41   829.61   904.32 1.03      253
    ## ngram_center                 10.59      1.02     8.62    12.55 1.00     1622
    ## freq_center                  -4.16      1.61    -7.27    -0.86 1.00     2747
    ## length_center                20.06      2.37    15.32    24.70 1.00     3935
    ## past_c_ngram                  1.88      0.79     0.35     3.38 1.00     5903
    ## past_c_freq                   3.00      1.09     0.81     5.18 1.00     4111
    ## past_c_length                -5.01      1.87    -8.67    -1.46 1.00     4420
    ## freq_center:length_center     1.09      0.38     0.37     1.83 1.00     4062
    ## past_c_freq:past_c_length    -1.00      0.36    -1.70    -0.27 1.00     4637
    ##                           Tail_ESS
    ## Intercept                      318
    ## ngram_center                  2930
    ## freq_center                   3152
    ## length_center                 3190
    ## past_c_ngram                  3227
    ## past_c_freq                   2912
    ## past_c_length                 3384
    ## freq_center:length_center     3122
    ## past_c_freq:past_c_length     3098
    ## 
    ## Family Specific Parameters: 
    ##       Estimate Est.Error l-95% CI u-95% CI Rhat Bulk_ESS Tail_ESS
    ## sigma   329.84      1.44   327.02   332.59 1.00     8359     3001
    ## 
    ## Samples were drawn using sampling(NUTS). For each parameter, Bulk_ESS
    ## and Tail_ESS are effective sample size measures, and Rhat is the potential
    ## scale reduction factor on split chains (at convergence, Rhat = 1).

    ## % latex table generated in R 3.6.3 by xtable 1.8-4 package
    ## % Thu Apr 23 21:37:37 2020
    ## \begin{table}[ht]
    ## \centering
    ## \begin{tabular}{lrlrrlrrlr}
    ##   \hline
    ## Term & E\_5-gram & CI\_5-gram & P\_5-gram & E\_GRNN & CI\_GRNN & P\_GRNN & E\_TXL & CI\_TXL & P\_TXL \\ 
    ##   \hline
    ## freq\_center & -4.2 & [-7.3, -0.9] & 0.01 & 1.7 & [-1.2, 4.6] & 0.25 & -0.8 & [-3.7, 2.2] & 0.59 \\ 
    ##   freq\_center:length\_center & 1.1 & [0.4, 1.8] & 0.00 & 1.2 & [0.4, 1.9] & 0.00 & 1.2 & [0.5, 2] & 0.00 \\ 
    ##   Intercept & 867.7 & [829.6, 904.3] & 0.00 & 868.5 & [835.4, 903] & 0.00 & 866.5 & [830.4, 900.7] & 0.00 \\ 
    ##   length\_center & 20.1 & [15.3, 24.7] & 0.00 & 18.0 & [13.6, 22.4] & 0.00 & 20.8 & [16.4, 25.3] & 0.00 \\ 
    ##   past\_c\_freq & 3.0 & [0.8, 5.2] & 0.01 & 1.5 & [-0.2, 3.3] & 0.09 & 0.9 & [-0.9, 2.8] & 0.35 \\ 
    ##   past\_c\_freq:past\_c\_length & -1.0 & [-1.7, -0.3] & 0.01 & -1.3 & [-1.9, -0.6] & 0.00 & -1.2 & [-1.9, -0.5] & 0.00 \\ 
    ##   past\_c\_length & -5.0 & [-8.7, -1.5] & 0.01 & -6.9 & [-10.5, -3.3] & 0.00 & -5.3 & [-9, -1.7] & 0.00 \\ 
    ##   past\_c\_surp & 1.9 & [0.3, 3.4] & 0.02 & 1.9 & [0.6, 3.3] & 0.01 & 0.1 & [-1.2, 1.3] & 0.95 \\ 
    ##   surp\_center & 10.6 & [8.6, 12.6] & 0.00 & 22.1 & [19.8, 24.4] & 0.00 & 17.0 & [14.8, 19.2] & 0.00 \\ 
    ##    \hline
    ## \end{tabular}
    ## \end{table}

## GAMs

I think there might be ways to have mixed effects for this, but for now
we’re not. Also, couldn’t figure out good ways of getting graphs from
the full models, so just fitting the pieces within ggplot for graphs.

Using only pre-error data.

![](nat_stories_lms_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Including post-error data.

![](nat_stories_lms_files/figure-gfm/plot_gam-3-1.png)<!-- -->
