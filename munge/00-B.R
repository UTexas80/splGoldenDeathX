################################################################################
## Step 0.01: Get Prices                                                     ###
################################################################################
SPL <- tq_get("SPL.AX") ### Get TidyQuant Stock Prices
SPL <- SPL[complete.cases(SPL), ] ### Delete NA
################################################################################ https://tinyurl.com/yy2mkklj
## Step 0.02: xts Prices                                                     ### https://tinyurl.com/yyyf4qqw
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
SPL.AX <-
  SPL.AX %>%
  na.omit() # Replace missing values (NA)                               https://tinyurl.com/y5etxh8x

################################################################################
## Step 0.03: xts EMA / SMA                                                  ### https://tinyurl.com/yy8ozaa2
################################################################################
ema005 <- EMA(Cl(SPL.AX), 5)
ema010 <- EMA(Cl(SPL.AX), 10)
ema020 <- EMA(Cl(SPL.AX), 20)
ema050 <- EMA(Cl(SPL.AX), 50)
ema100 <- EMA(Cl(SPL.AX), 100)
ema200 <- EMA(Cl(SPL.AX), 200)

sma005 <- SMA(Cl(SPL.AX), 5)
sma010 <- SMA(Cl(SPL.AX), 10)
sma020 <- SMA(Cl(SPL.AX), 20)
sma050 <- SMA(Cl(SPL.AX), 50)
sma100 <- SMA(Cl(SPL.AX), 100)
sma200 <- SMA(Cl(SPL.AX), 200)

xtsEMA <- merge(merge(merge(merge(merge(ema005, ema010, join = "inner"), ema020, join = "inner"), ema050, join = "inner"), ema100, join = "inner"), ema200, join = "inner")
################################################################################
## Step 0.04: rename columns                                                 ### https://tinyurl.com/y6fwyvwk
################################################################################
names(xtsEMA) <- c("ema005", "ema010", "ema020", "ema050", "ema100", "ema200") # Renaming the First n Columns Using Base R
################################################################################
## Step 0.05: save xts to rds                                                ###
################################################################################
saveRDS(
  xtsEMA[complete.cases(xtsEMA), ],
  file = "./rds/xtsEMA.rds"
)

xtsEMA_Months <- nmonths(xtsEMA)
################################################################################
## Step 0.06: save xts to data.table                                         ###
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
## Step 0.07: Group trend elements                                           ###
## prefix with 'grp' perform a group by with elements that are contiguous    ### https://tinyurl.com/yytlybll
################################################################################
dtEMA$subgroup <- rleid(dtEMA$event)
dtEMA <- data.table(dtEMA)
dtEMA[order(event), group := rleid(event)]
dtEMA <- data.table(dtEMA)

dtEMA <- dtEMA[order(group, subgroup)][event == "n", eventGroup := rleid(subgroup)]
dtEMA <- dtEMA[order(group, subgroup)][event == "DeathX", eventGroup := rleid(subgroup)]
dtEMA <- dtEMA[order(group, subgroup)][event == "GoldenX", eventGroup := rleid(subgroup)]
dtEMA[, eventGroupNum := paste0(event, paste0(sprintf("%03d", eventGroup)))] # Concatenate and zero fill two columns                     https://tinyurl.com/yxmv734u
################################################################################
## Step 0.08: another variation of Step 03: xts EMA / SMA                    ###
## Exponential Moving Average - EMA calculates an exponentially-weighted     ###
## mean, giving more weight to recent observations                           ###
## Simple Moving Average - SMA calculates the arithmetic mean of the series  ###
## over the past n observations.                                             ###
################################################################################
ema.005 <- EMA(SPL$close, 5)
sma.005 <- SMA(SPL$close, 5)
ema.010 <- EMA(SPL$close, 10)
sma.010 <- SMA(SPL$close, 10)
sma.015 <- SMA(SPL$close, 15)
ema.020 <- EMA(SPL$close, 20)
sma.020 <- SMA(SPL$close, 20)
ema.050 <- EMA(SPL$close, 50)
sma.050 <- SMA(SPL$close, 50)
ema.100 <- EMA(SPL$close, 100)
sma.100 <- SMA(SPL$close, 100)
ema.200 <- EMA(SPL$close, 200)
sma.200 <- SMA(SPL$close, 200)
################################################################################
## Step 0.09 T/F: determine if a day meets the golden/death X criteria       ###
################################################################################
goldenX <- ema020 > ema050 & ema050 > ema100 & ema100 > ema200
deathX <- ema200 > ema100 & ema100 > ema050 & ema050 > ema020
dtGoldenX <- as.data.table(goldenX)
dtGoldenX <- dtGoldenX[EMA == TRUE]
################################################################################
## Step 0.10 rename column names by index                                    ### https://tinyurl.com/y6fwyvwk
## create data.table index                                                   ###
################################################################################
names(dtEMA)[1] <- "date" # rename column name by index
names(dtGoldenX)[1] <- "date" # rename column name by index
setkey(dtGoldenX, "date") # create data.table index
################################################################################
## Step 0.11 convert column from logical to character; xts doesn't recognize ### https://tinyurl.com/y6fwyvwk
## TRUE/FALSE                                                                ###
## convert data table to xts & visa-versa                                    ###
################################################################################
dtGoldenX %>% mutate_if(is.logical, as.character) -> dtGoldenX # convert column from logical to character; xts doesn't recognize TRUE/FALSE
goldenX.xts <- xts(dtGoldenX[, -1], order.by = dtGoldenX[, 1]) # converting data table to xts                              https://tinyurl.com/y66xbu3h
priceGoldenX.xts <- SPL.AX[index(goldenX.xts)]
dtGoldenX <- data.table(dtGoldenX)
dtGoldenX[EMA == "TRUE", EMA := "goldenX"]
################################################################################
## Step 0.12 xtsMonthly Returns in the xts World                             ### https://tinyurl.com/yyyf4qqw
################################################################################
prices_monthly <- to.monthly(xtsPrices, indexAt = "lastof", OHLC = FALSE)
asset_returns_xts <- na.omit(Return.calculate(prices_monthly, method = "log"))
################################################################################
## Step 0.13 AUD                                                             ###
################################################################################
aud_usd <- getSymbols("AUD=X", src = "yahoo", auto.assign = FALSE)
aud_usd <- aud_usd[complete.cases(aud_usd), ]
usd_aud <- 1 / aud_usd

dtSPL <- as.data.table(SPL.AX, keep.rownames = TRUE)
names(dtSPL)[1] <- "date"
setkey(dtSPL, "date")
setkey(dtEMA, "date")
dtSPL <- dtSPL[dtEMA][, c(1:2, 18)]

xtsPrice <- as.xts.data.table(dcast.data.table(dtSPL, formula = date ~ eventGroupNum, value.var = "SPL.AX.Open"))
cumReturn <- apply(X = xtsPrice, 2, FUN = function(Z) Return.cumulative(as.numeric(Z), geometric = TRUE)) # https://tinyurl.com/y2d2ve83

################################################################################
## Step 0.14 Golden Cross Trading System                                     ### https://tinyurl.com/y3sq4ond
################################################################################
# 0.14.a   20 / 50 / 100/ 200 day . xts Simple Moving Averages
ma_SPL <- SPL.AX
ma_SPL$ma020 <- SMA(na.omit(SPL.AX$SPL.AX.Close), 20)
ma_SPL$ma050 <- SMA(na.omit(SPL.AX$SPL.AX.Close), 50)
ma_SPL$ma100 <- SMA(na.omit(SPL.AX$SPL.AX.Close), 100)
ma_SPL$ma200 <- SMA(na.omit(SPL.AX$SPL.AX.Close), 200)

ma_SPL <- ma_SPL[, 7:10]

# 0.14.b Baseline Return
ret <- ROC(Cl(SPL.AX))

# 0.14.c Baseline Signal & Return
golden_ma_sig <- Lag(ifelse(ma_SPL$ma020 > ma_SPL$ma050 & ma_SPL$ma050 > ma_SPL$ma100 & ma_SPL$ma100 > ma_SPL$ma200, 1, 0))
golden_ma_ret <- (ret * golden_ma_sig)

# 0.14.d GOlden Cross Indicator
golden <- cbind(golden_ma_ret, ret)
colnames(golden) <- c("GoldenCross", "Buy&Hold")

# 0.14.e Max Drawdown & Performance Summary
maxDrawdown(golden)
table.AnnualizedReturns(golden, Rf = 0.02 / 252)
charts.PerformanceSummary(golden, Rf = 0.02, main = "Golden Cross", geometric = FALSE)

# 0.14.f save .rds
saveRDS(
  golden,
  file = "./rds/golden.rds"
)
saveRDS(
  ma_SPL,
  file = "./rds/ma_SPL.rds"
)