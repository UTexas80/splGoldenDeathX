# ------------------------------------------------------------------------------
# Detecting Streaks in R                            https://tinyurl.com/ybgqmc36
# ------------------------------------------------------------------------------
library(tidyverse)

get_streaks <- function(vec){
    x <- data.frame(trials=vec)
    x <- x %>% mutate(lagged=lag(trials)) %>%  #note: that's dplyr::lag, not stats::lag
            mutate(start=(trials != lagged))
    x[1, "start"] <- TRUE
    x <- x %>% mutate(streak_id=cumsum(start))
    x <- x %>% group_by(streak_id) %>% mutate(streak=row_number()) %>%
        ungroup()
    return(x)
}

shots <- read_csv("playoff_shots.csv")
durant_ft <- shots %>% filter(player_name == "Kevin Durant" & shot_type == "FT")
durant_ft <- get_streaks(durant_ft$result)

ggplot(durant_ft, aes(x=1:nrow(durant_ft), y=streak)) + geom_bar(stat="identity")

durant_ft2 <- durant_ft %>% mutate(streak = streak * ifelse(trials == "make", 1, -1))
caption <- paste(c("Kevin Durant", "FT"), collapse = "\n")
ggplot(durant_ft2, aes(x=1:nrow(durant_ft2), y=streak)) +
    geom_bar(aes(fill=trials), stat="identity") +
    theme_void() +
    geom_hline(yintercept = 0) +
    geom_vline(xintercept = 0) +
    scale_fill_manual(values=c("make"="darkgreen", "miss"="red"), guide=FALSE) +
    annotate(geom="text", label=caption, x=nrow(durant_ft2), y=max(durant_ft2$streak),
             hjust="right", vjust="top")
