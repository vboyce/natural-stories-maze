library(tidyverse)
library(here)

# Split-half correlations within SPR, within Maze, and between Maze and SPR (manuscript section
# "How do A-maze and SPR compare in sensitivity?"). The manuscript used one random split (seed 42);
# a single split is noisy, so we repeat the split for seeds 1 to 1000 and report the distribution.
# The procedure for each split is the one in the manuscript's former spr-split-half, maze-split-half
# and maze-spr chunks. Takes roughly 15 minutes; the manuscript reads the saved result.
# Run from anywhere in the repo: Rscript Analysis/split_half.R

n_splits <- 1000

tokenization <- here("Data/SPR/all_stories.tok.txt") %>%
  read_delim(delim="\t") %>%
  mutate(Word_In_Story_Num=zone,
         Story_Num=item)

labs <- read_rds(here("Prep_code/natural_stories_surprisals.rds")) %>%
  left_join(read_delim(here("Materials/natural_stories_sentences.tsv"), delim="\t")) %>%
  select(word_num=Word_In_Sentence_Num, word=Word, sentence=Sentence, everything())

spr <- read_rds(here("Data/SPR/first.rds")) %>% left_join(tokenization) %>% left_join(labs) %>% select(WorkerId,rt,Story_Num,Sentence_Num, word_num)

maze <- read_rds(here("Data/maze_pre_error.rds")) %>% left_join(labs) %>% select(subject, rt, Story_Num, Sentence_Num, word_num)

# Maze has 63 participants, so SPR is downsampled to 63 participant-stories before splitting
n_maze_participants <- n_distinct(maze$subject)
stopifnot(n_maze_participants==63)

split_half_correlations <- function(seed){
  set.seed(seed)
  spr_subs <- spr %>% filter(!is.na(Story_Num)) %>% select(WorkerId, Story_Num) %>% unique() %>%
    sample_n(n_maze_participants) %>% group_by(Story_Num) %>%
    mutate(half=ifelse(row_number() <= .5*n(),"spr1", "spr2")) %>%
    ungroup()

  spr_sentence_avg <- spr %>%
    inner_join(spr_subs, by=c("WorkerId", "Story_Num")) %>%
    group_by(half,Story_Num, Sentence_Num, word_num) %>% summarize(spr=mean(rt), .groups="drop") %>%
    pivot_wider(names_from=half, values_from=spr) %>%
    group_by(Story_Num, Sentence_Num) %>%
    summarize(spr1=mean(spr1), spr2=mean(spr2), .groups="drop")

  # the manuscript reset the seed before the Maze split, so we do too
  set.seed(seed)
  maze_subs <- maze %>% select(subject, Story_Num) %>% unique() %>%
    sample_n(n_maze_participants) %>% group_by(Story_Num) %>%
    mutate(half=ifelse(row_number() <= .5*n(),"maze1", "maze2")) %>%
    ungroup()

  maze_sentence_avg <- maze %>%
    inner_join(maze_subs, by=c("subject", "Story_Num")) %>%
    group_by(half,Story_Num, Sentence_Num, word_num) %>% summarize(maze=mean(rt), .groups="drop") %>%
    pivot_wider(names_from=half, values_from=maze) %>%
    group_by(Story_Num, Sentence_Num) %>%
    summarize(maze1=mean(maze1), maze2=mean(maze2), .groups="drop")

  # between methods: correlate each Maze half with each SPR half, then average the 4 correlations
  summ_spr <- spr %>% inner_join(spr_subs, by=c("WorkerId", "Story_Num")) %>%
    group_by(Story_Num, Sentence_Num, word_num, half) %>% summarize(spr=mean(rt, na.rm=T), .groups="drop") %>%
    rename(spr_half=half) %>% filter(!is.na(spr))
  spr_maze <- maze %>% inner_join(maze_subs, by=c("subject", "Story_Num")) %>%
    group_by(Story_Num, Sentence_Num, word_num, half) %>% summarize(maze=mean(rt, na.rm=T), .groups="drop") %>%
    rename(maze_half=half) %>% filter(!is.na(maze)) %>%
    inner_join(summ_spr, by=c("Story_Num", "Sentence_Num", "word_num"), relationship="many-to-many") %>%
    group_by(Story_Num, Sentence_Num, maze_half, spr_half) %>%
    summarize(maze=mean(maze), spr=mean(spr), .groups="drop") %>%
    group_by(maze_half, spr_half) %>%
    summarize(r=cor(spr, maze, use="complete.obs"), .groups="drop")
  stopifnot(nrow(spr_maze)==4)

  tibble(seed=seed,
         spr_spr=cor(spr_sentence_avg$spr1, spr_sentence_avg$spr2, use="complete.obs"),
         maze_maze=cor(maze_sentence_avg$maze1, maze_sentence_avg$maze2, use="complete.obs"),
         spr_maze=mean(spr_maze$r))
}

splits <- map_dfr(1:n_splits, split_half_correlations)

summary_by_measure <- splits %>%
  mutate(maze_minus_spr=maze_maze-spr_spr,
         between_minus_spr=spr_maze-spr_spr) %>%
  pivot_longer(-seed, names_to="measure", values_to="value") %>%
  group_by(measure) %>%
  summarize(median=median(value),
            lower=quantile(value, .025),
            upper=quantile(value, .975),
            share_above_0=mean(value>0))

list(splits=splits, summary=summary_by_measure) %>%
  write_rds(here("Analysis/models/split_half_reliability.rds"))
