################################################################################
## Step 00.00: Get Prices                                                    ###
################################################################################
SPL <- tq_get("SPL.AX")                           ### Get TidyQuant Stock Prices
SPL <- SPL[complete.cases(SPL), ]                 ### Delete NA
################################################################################
## Step 00.01: xts Prices                      https://tinyurl.com/yy2mkklj  ###
##                                             https://tinyurl.com/yyyf4qqw  ###
################################################################################
xtsPrices <-
  getSymbols(symbols,
    src = "yahoo",
    from = dateFrom,
    auto.assign = TRUE,
    warnings = FALSE
  ) %>%
  map(~ Ad(get(.))) %>%
  reduce(merge) %>%
  `colnames<-`(symbols)
# ------------------------------------------------------------------------------
SPL.AX <-
  SPL.AX %>%
  na.omit() # Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###
################################################################################
## Step 00.02 death Cross Trading System          https://tinyurl.com/y3sq4ond  ###
## Baseline Return                                                           ###
################################################################################
close                     <- Cl(SPL.AX)
ret                       <- ROC(Cl(SPL.AX))  
################################################################################
## Step 00.03: xts EMA / SMA                    https://tinyurl.com/yy8ozaa2 ### 
## Exponential Moving Average - EMA calculates an exponentially-weighted     ###
## mean, giving more weight to recent observations                           ###
## Simple Moving Average - SMA calculates the arithmetic mean of the series  ###
## over the past n observations.                                             ###
################################################################################
ema005 <- EMA(Cl(SPL.AX), 5)
ema010 <- EMA(Cl(SPL.AX), 10)
ema020 <- EMA(Cl(SPL.AX), 20)
ema050 <- EMA(Cl(SPL.AX), 50)
ema100 <- EMA(Cl(SPL.AX), 100)
ema200 <- EMA(Cl(SPL.AX), 200)
# ------------------------------------------------------------------------------
sma005 <- SMA(Cl(SPL.AX), 5)
sma010 <- SMA(Cl(SPL.AX), 10)
sma020 <- SMA(Cl(SPL.AX), 20)
sma050 <- SMA(Cl(SPL.AX), 50)
sma100 <- SMA(Cl(SPL.AX), 100)
sma200 <- SMA(Cl(SPL.AX), 200)
# ------------------------------------------------------------------------------
xtsEMA <- merge(merge(merge(merge(merge(ema005, ema010, join = "inner"), 
  ema020, join = "inner"), ema050, join = "inner"), ema100, 
  join = "inner"), ema200, join = "inner")
################################################################################
## Step 00.04: rename columns using Base R     https://tinyurl.com/y6fwyvwk  ### 
################################################################################
names(xtsEMA) <- c("ema005", "ema010", "ema020", "ema050", "ema100", "ema200") 
################################################################################
## Step 00.05: falkulate xtsEMA Months                                       ###
################################################################################
xtsEMA_Months <- nmonths(xtsEMA)
################################################################################
## Step 00.06: save xts to data.table                                        ###
## add variable to indicate trend                                            ###
################################################################################
dtEMA <- as.data.table(xtsEMA)
dtEMA <- dtEMA %>%
  mutate(
    event = case_when(
      ema020 > ema050 & ema050 > ema100 & ema100 > ema200 ~ "GoldenX",
      ema200 > ema100 & ema100 > ema050 & ema050 > ema020 ~ "DeathX",
      TRUE ~ "n"
    )
  )
dtEMA <- data.table(dtEMA)
################################################################################
## Step 00.07: Group trend elements             https://tinyurl.com/yytlybll ###
## prefix with 'grp' perform a group by with elements that are contiguous    ###
################################################################################
# EMA---------------------------------------------------------------------------
dtEMA$subgroup <- rleid(dtEMA$event)
dtEMA <- data.table(dtEMA)
dtEMA[order(event), group := rleid(event)]
dtEMA <- data.table(dtEMA)
# ------------------------------------------------------------------------------
dtEMA <- dtEMA[order(group, subgroup)][event == "n", `:=`(eventGroup, 
  rleid(subgroup))]
dtEMA <- dtEMA[order(group, subgroup)][event == "DeathX", `:=`(eventGroup, 
  rleid(subgroup))]
dtEMA <- dtEMA[order(group, subgroup)][event == "GoldenX", `:=`(eventGroup, 
  rleid(subgroup))]
# Concatenate and zero fill two columns ------- https://tinyurl.com/yxmv734u ---
dtEMA[, eventGroupNum := paste0(event, paste0(sprintf("%03d", eventGroup)))]   
# rename column name by index & setkey--------- https://tinyurl.com/y6fwyvwk --- 
names(dtEMA)[1] <- "date" 
setkey(dtEMA, "date")
################################################################################
## Step 00.08: SMA Group trend elements         https://tinyurl.com/yytlybll ###
## prefix with 'grp' perform a group by with elements that are contiguous    ###
################################################################################
xtsSMA <- merge(merge(merge(merge(merge(sma005, sma010, join = "inner"),
  sma020, join = "inner"), sma050, join = "inner"), sma100, 
  join = "inner"), sma200, join = "inner")
# ------------------------------------------------------------------------------
names(xtsSMA) <- c("sma005", "sma010", "sma020", "sma050", "sma100", "sma200") 
# ------------------------------------------------------------------------------
dtSMA <- as.data.table(xtsSMA)
dtSMA <- dtSMA %>%
  mutate(
    catName = case_when(
      sma020 > sma050 & sma050 > sma100 & sma100 > sma200 ~ "GoldenX",
      sma200 > sma100 & sma100 > sma050 & sma050 > sma020 ~ "DeathX",
      TRUE ~ "n"
    )
  )
dtSMA <- data.table(dtSMA)
# ------------------------------------------------------------------------------
dtSMA$number <- rleid(dtSMA$catName)
dtSMA <- data.table(dtSMA)
dtSMA[order(catName), group := rleid(catName)]
dtSMA <- data.table(dtSMA)
# ------------------------------------------------------------------------------
dtSMA <- dtSMA[order(group, number)][catName == "n", `:=`(subGroup, 
  rleid(number))]
dtSMA <- dtSMA[order(group, number)][catName == "DeathX", `:=`(subGroup, 
  rleid(number))]
dtSMA <- dtSMA[order(group, number)][catName == "GoldenX", `:=`(subGroup, 
  rleid(number))]
# Concatenate and zero fill two columns ------- https://tinyurl.com/yxmv734u ---
dtSMA[, catNum := paste0(catName, paste0(sprintf("%03d", subGroup)))]   
# rename column name by index & setkey--------- https://tinyurl.com/y6fwyvwk --- 
names(dtSMA)[1] <- "date" 
dtSMA[, indicator := "SMA"]
setkey(dtSMA, "date")
################################################################################
## Step 00.09 T/F: determine if a day meets the golden/death X criteria      ###
################################################################################
goldenX <- ema020 > ema050 & ema050 > ema100 & ema100 > ema200
dtGoldenX <- as.data.table(goldenX)
dtGoldenX <- dtGoldenX[EMA == TRUE]
################################################################################
## Step 00.10 rename column names by index      https://tinyurl.com/y6fwyvwk ### 
## create data.table index                                                   ###
################################################################################
names(dtGoldenX)[1] <- "date" # rename column name by index
setkey(dtGoldenX, "date") # create data.table index
################################################################################
## Step 00.11 T/F: determine if a day meets the golden/death X criteria      ###
################################################################################
# convert column from logical to character; xts doesn't recognize TRUE/FALSE ---
dtGoldenX %>% mutate_if(is.logical, as.character) -> dtGoldenX 
# converting data table to xts ---------------- https://tinyurl.com/y66xbu3h ---
goldenX.xts <- xts(dtGoldenX[, -1], order.by = dtGoldenX[, 1])                  
priceGoldenX.xts <- SPL.AX[index(goldenX.xts)]
dtGoldenX <- data.table(dtGoldenX)
dtGoldenX[EMA == "TRUE", EMA := "goldenX"]
################################################################################
## Step 00.12 T/F: determine if a day meets the golden/death X criteria      ###
################################################################################
deathX <- ema200 > ema100 & ema100 > ema050 & ema050 > ema020
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st released
