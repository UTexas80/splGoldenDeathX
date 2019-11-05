################################################################################
## Step 02.1a Grouping Set aggregation for data tables                       ###
## https://is.gd/ZeSKLS                                                      ###
################################################################################
trendSummaryGroup <- groupingsets(trend[, c(4:7)], j = c(list(count = .N), 
  lapply(.SD, sum)), by = c("catName", "indicator"), sets = list(c("catName", 
  "indicator"), "indicator", character()), id = TRUE)
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version                 <- "1.0.0"
a00.ModDate                 <- as.Date("2019-11-05")
# ------------------------------------------------------------------------------
# 2019.11.09 - v.1.0.0
#  1st released
