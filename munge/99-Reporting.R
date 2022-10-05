################################################################################
## Step 99.00 trade stats                                                    ###
################################################################################
# browser()
# dtSPL$row <- dtSPL[, .I[1], by = date][,2]
#...............................................................................
# Generate the row number to the dataframe          https://tinyurl.com/ykw6z8be
#...............................................................................
dtSPL         <- dtSPL[, row := .I]               # https://tinyurl.com/ykw6z8be
# dtSPL$dayDiff <- dayDifff(SPL.AX)                 # https://tinyurl.com/ybcssoh8
dtSPL$dayDiff <- dayDifff(dtSPL)
# ------------------------------------------------------------------------------
dtSPL[1,9] <- 1                                   # replace first na's with zero
dtSPL[nrow(dtSPL),9] <- 0                         # replace last na's with zero
data.table::setkey(dtSPL, date)
# ------------------------------------------------------------------------------
tRD <- cbind(dXema_rets,dXsma_rets,gXema_rets,gXsma_rets,nXema_rets,nXsma_rets)
# ------------------------------------------------------------------------------
l       <- list(dXema_trend, dXsma_trend, gXema_trend, gXsma_trend, nXema_trend, nXsma_trend)
trend   <- unique(rbindlist(l))
# trend   <- unique(setorder(rbindlist(l),"subcatName"))
# ------------------------------------------------------------------------------
trendSummaryGroup <- trend[, .(count = .N,                  # .N is nb per group
                               tradeDays = sum(tradeDays),  # compute count
                               return = sum(Pct.Net.Trading.PL) # compute avg ret
                               ),
                               by = .(indicator, catName)][
                               order(indicator, catName)
                               ]
# trendSummaryGroup <- trendSummaryGroup[, .(occurrencePct = count/sum(count),
#                                           tradeDaysPct = tradeDays/sum(tradeDays)),
#                                           by = .(indicator)][
#                                           order(indicator)
#                                       ][, c(1:7)]
emaPct <- trendSummaryGroup[
  indicator == "EMA", occurrencePct := count / sum(count)][
  indicator == "EMA", tradeDaysPct := tradeDays / sum(tradeDays)][1:3]
smaPct <- trendSummaryGroup[
  indicator == "SMA", occurrencePct := count / sum(count)][
  indicator == "SMA", tradeDaysPct := tradeDays / sum(tradeDays)][4:6]
# ------------------------------------------------------------------------------
# [1] "Start"               "End"                 "Init.Qty"            "Init.Pos"            "Max.Pos"             "End.Pos"
# [7] "Closing.Txn.Qty"     "Num.Txns"            "Max.Notional.Cost"   "Net.Trading.PL"      "MAE"                 "MFE"
# [13] "Pct.Net.Trading.PL"  "Pct.MAE"             "Pct.MFE"             "tick.Net.Trading.PL" "tick.MAE"            "tick.MFE
# [19] "duration"            "tradeDays"           "calendarDays"        "catName"             "indicator"           "grp"
# [25] "subcatName"          "open"                "i.open"
# ------------------------------------------------------------------------------
trend   <- trend[, c(23, 22, 25, 1, 26, 2, 27, 13, 9:10, 20:21)]
# ------------------------------------------------------------------------------
trend$Start <- as_date(trend$Start)
trend$End   <- as_date(trend$End)
# ------------------------------------------------------------------------------# https://tinyurl.com/yb29lhr9
# indicator, catName, subcatName, Start, startOpen, end, endOpen, return, Max.Notational.Cost, Net.Trading.PL, tradeDays#, Calendar Days
names(trend)[c(4:8)] <- c("startDate", "startOpen", "endDate", "endOpen", "return")
# ------------------------------------------------------------------------------
# [1] "indicator"         "catName"           "subcatName"        "startDate"         "startOpen"         "endDate"
# [7] "endOpen"           "return"            "Max.Notional.Cost" "Net.Trading.PL"    "tradeDays"         "calendarDays"
# ------------------------------------------------------------------------------
data.table::setkey(trend, startDate)
trend      <- trend[dtSPL, nomatch = 0][,-c(13:18)]
# trend$startDate = trend$startDate + trend$dayDiff
# ------------------------------------------------------------------------------
data.table::setkey(trend, endDate)
trend      <- trend[dtSPL, nomatch = 0][,-c(15:20)]
# trend      <- trend[dtSPL, nomatch = 0][i.dayDiff > 0,-c(15:20)]
# trend$endDate = trend$endDate + trend$i.dayDiff
# ------------------------------------------------------------------------------# https://tinyurl.com/tmmubbh
trendReturns      <- data.table(t(trend[, c(3,8)]))                             # subcatName, return
trendReturns      <- setnames(trendReturns, as.character(trendReturns[1,]))[-1,] %>%
                     mutate_if(is.character,as.numeric)
# ------------------------------------------------------------------------------
# [1] "indicator"         "catName"           "subcatName"        "startDate"         "startOpen"         "endDate"           "endOpen"
# [8] "return"            "Max.Notional.Cost" "Net.Trading.PL"    "tradeDays"         "calendarDays"
# ------------------------------------------------------------------------------
dt_trade_stats    <- rbind.data.frame(dXema_trade_stats,
                                   dXsma_trade_stats,
                                   gXema_trade_stats,
                                   gXsma_trade_stats,
                                   nXema_trade_stats,
                                   nXsma_trade_stats
                                   )
# ------------------------------------------------------------------------------
# Converting column from character to numeric       https://tinyurl.com/ycn9yuun
# ------------------------------------------------------------------------------
dt_trade_stats_num <- dt_trade_stats[,-c(1:2)] %>%
                      mutate_if(is.character,as.numeric)
dt_trade_stats     <- cbind(dt_trade_stats[,1], dt_trade_stats_num)
dt_trade_stats[, Percent.Positive := Percent.Positive/100][,
                 Percent.Negative := Percent.Negative/100]
################################################################################
## Step 99.01 Daily Trend Returns                                  quantmod  ###
################################################################################
symbols           <- SPL.AX
close             <- Cl(SPL.AX)
open              <- Op(SPL.AX)
ret               <- ROC(Op(SPL.AX), n = 1)
################################################################################
## Step 99.02 death Cross Indicator                                          ###
################################################################################
death_ma_sigEMA           <- lag(ifelse(ema020 < ema050 & ema050 <
                                        ema100 & ema100 < ema200, 1, 0),
                             1)
# ------------------------------------------------------------------------------
# get signals last day of the trend
# ------------------------------------------------------------------------------
x1 <- as.xts(dXema_trend[,c(2,6)])
x1[,1] <- 1
names(x1)[1] <- "EMA"
# ------------------------------------------------------------------------------
# Remove duplicates dates from rbin keeping entry with largest absolute value (1) 
# https://tinyurl.com/y738qcsc
# ------------------------------------------------------------------------------
y1 <- death_ma_sigEMA
z1 <- rbind(x1,y1)
death_ma_sigEMA<-as.xts(as.data.table(z1)[, .SD[which.max(abs(EMA))], by=index])
# ------------------------------------------------------------------------------
death_ma_sigSMA           <- lag(ifelse(sma020 < sma050 & sma050 <
                                        sma100 & sma100 < sma200, 1, 0),
                             1)
# ------------------------------------------------------------------------------
# get signals last day of the trend
# ------------------------------------------------------------------------------
x2 <- as.xts(dXema_trend[,c(2,6)])
x2[,1] <- 1
names(x2)[1] <- "SMA"
# ------------------------------------------------------------------------------
# Remove duplicates dates from rbin keeping entry with largest absolute value (1) 
# https://tinyurl.com/y738qcsc
# ------------------------------------------------------------------------------
y2 <- death_ma_sigSMA
z2 <- rbind(x2,y2)
death_ma_sigSMA<-as.xts(as.data.table(z2)[, .SD[which.max(abs(SMA))], by=index])
# ------------------------------------------------------------------------------
deathOpenEMA              <- (open * death_ma_sigEMA[death_ma_sigEMA$EMA == 1])
deathOpenSMA              <- (open * death_ma_sigSMA[death_ma_sigSMA$SMA == 1])
# ------------------------------------------------------------------------------
# dXema_ret                 <- (ret * death_ma_sigEMA[death_ma_sigEMA$EMA == 1])
# dXsma_ret                 <- (ret * death_ma_sigSMA[death_ma_sigSMA$SMA == 1])
# ------------------------------------------------------------------------------
death_ma_retEMA           <- dailyReturn(deathOpenEMA)
death_ma_retSMA           <- dailyReturn(deathOpenSMA)
# ------------------------------------------------------------------------------
death_ma_retEMA           <- death_ma_retEMA
death_ma_retSMA           <- death_ma_retSMA
# ------------------------------------------------------------------------------
deathEMA                  <- cbind(death_ma_retEMA, ret)
deathSMA                  <- cbind(death_ma_retSMA, ret)
death                     <- cbind(death_ma_retEMA, death_ma_retSMA, ret)
# ------------------------------------------------------------------------------
colnames(deathEMA)        <- c("deathCrossEMA", "Buy&Hold")
colnames(deathSMA)        <- c("deathCrossSMA", "Buy&Hold")
colnames(death)           <- c("dXema", "dXsma", "Buy&Hold")
################################################################################
## Step 99.04 Golden Cross Indicator                                         ###
################################################################################
golden_ma_sigEMA           <- lag(ifelse(ema020 > ema050 & ema050 >
                                         ema100 & ema100 > ema200, 1, 0),
                              1)
# ------------------------------------------------------------------------------
# get signals last day of the trend
# ------------------------------------------------------------------------------
x3 <- as.xts(gXema_trend[,c(2,6)])
x3[,1] <- 1
names(x3)[1] <- "EMA"
# ------------------------------------------------------------------------------
# Remove duplicates dates from rbin keeping entry with largest absolute value (1) 
# https://tinyurl.com/y738qcsc
# ------------------------------------------------------------------------------
y3 <- golden_ma_sigEMA
z3 <- rbind(x3,y3)
golden_ma_sigEMA<-as.xts(as.data.table(z3)[, .SD[which.max(abs(EMA))], by=index])
# ------------------------------------------------------------------------------
golden_ma_sigSMA           <- lag(ifelse(sma020 > sma050 & sma050 >
                                         sma100 & sma100 > sma200, 1, 0),
                              1)
# ------------------------------------------------------------------------------
# get signals last day of the trend
# ------------------------------------------------------------------------------
x4 <- as.xts(gXsma_trend[,c(2,6)])
x4[,1] <- 1
names(x4)[1] <- "SMA"
# ------------------------------------------------------------------------------
# Remove duplicates dates from rbin keeping entry with largest absolute value (1) 
# https://tinyurl.com/y738qcsc
# ------------------------------------------------------------------------------
y4 <- golden_ma_sigSMA
z4 <- rbind(x4,y4)
golden_ma_sigSMA<-as.xts(as.data.table(z4)[, .SD[which.max(abs(SMA))], by=index])
# ------------------------------------------------------------------------------
goldenOpenEMA             <- (open * golden_ma_sigEMA[golden_ma_sigEMA$EMA == 1])
goldenOpenSMA             <- (open * golden_ma_sigSMA[golden_ma_sigSMA$SMA == 1])
# ------------------------------------------------------------------------------
# golden_ma_retEMA           <- (ret * golden_ma_sigEMA[golden_ma_sigEMA$EMA == 1])
# golden_ma_retSMA           <- (ret * golden_ma_sigSMA[golden_ma_sigSMA$SMA == 1])
golden_ma_retEMA           <- dailyReturn(goldenOpenEMA)
golden_ma_retSMA           <- dailyReturn(goldenOpenSMA)
# ------------------------------------------------------------------------------
goldenEMA                  <- cbind(golden_ma_retEMA, ret)
goldenSMA                  <- cbind(golden_ma_retSMA, ret)
golden                     <- cbind(golden_ma_retEMA, golden_ma_retSMA, ret)
# ------------------------------------------------------------------------------
colnames(goldenEMA)        <- c("GoldenCrossEMA", "Buy&Hold")
colnames(goldenSMA)        <- c("GoldenCrossSMA", "Buy&Hold")
colnames(golden)           <- c("gXema", "gXsma", "Buy&Hold")
################################################################################
## Step 99.05 No Cross Indicator                                         ###
################################################################################
nXema_sig <- lag(
                ifelse(!(ema020 < ema050 & ema050 < ema100 & ema100 < ema200) &
                       !(ema020 > ema050 & ema050 > ema100 & ema100 > ema200), 1,0),
                1)
# ------------------------------------------------------------------------------
# get signals last day of the trend
# ------------------------------------------------------------------------------
x5 <- as.xts(nXema_trend[,c(2,6)])
x5[,1] <- 1
names(x5)[1] <- "EMA"
# ------------------------------------------------------------------------------
# Remove duplicates dates from rbin keeping entry with largest absolute value (1) 
# https://tinyurl.com/y738qcsc
# ------------------------------------------------------------------------------
y5 <- nXema_sig
z5 <- rbind(x5,y5)
nXema_sig <-as.xts(as.data.table(z5)[, .SD[which.max(abs(EMA))], by=index])
# ------------------------------------------------------------------------------
nXsma_sig <- lag(
                ifelse(!(sma020 < sma050 & sma050 < sma100 & sma100 < sma200) &
                       !(sma020 > sma050 & sma050 > sma100 & sma100 > sma200), 1,0),
                1)
# ------------------------------------------------------------------------------
# get signals last day of the trend
# ------------------------------------------------------------------------------
x6 <- as.xts(nXsma_trend[,c(2,6)])
x6[,1] <- 1
names(x6)[1] <- "SMA"
# ------------------------------------------------------------------------------
# Remove duplicates dates from rbin keeping entry with largest absolute value (1) 
# https://tinyurl.com/y738qcsc
# ------------------------------------------------------------------------------
y6 <- nXsma_sig
z6 <- rbind(x6,y6)
nXsma_sig <-as.xts(as.data.table(z6)[, .SD[which.max(abs(SMA))], by=index])
# ------------------------------------------------------------------------------
nXema_open <- (open * nXema_sig[nXema_sig$EMA == 1])
nXsma_open <- (open * nXsma_sig[nXsma_sig$SMA == 1])
# ------------------------------------------------------------------------------
nXema_ret  <- dailyReturn(nXema_open)
nXsma_ret  <- dailyReturn(nXsma_open)
# ------------------------------------------------------------------------------
nXema      <- cbind(nXema_ret, ret)
nXsma      <- cbind(nXsma_ret, ret)
nX         <- cbind(nXema[,1], nXsma[,1], ret)
# ------------------------------------------------------------------------------
colnames(nXema)    <- c("nXema", "Buy&Hold")
colnames(nXsma)    <- c("nXsma", "Buy&Hold")
colnames(nX)       <- c("nXema", "nXsma", "Buy&Hold")
# ------------------------------------------------------------------------------
# trendReturnsDaily <- cbind(death[,1:2], golden[,1:2], nX)
trendReturnsDaily   <- cbind(death[,-c(3)],golden[,-c(3)],nX)
trendReturnsMonthly <- daily2monthly.zoo(trendReturnsDaily, FUN = sum, na.rm = TRUE,)
trendReturnsAnnual  <- daily2annual.zoo(trendReturnsDaily, FUN = sum, na.rm = TRUE)
Return.annualized(trendReturnsAnnual)
Return.cumulative(trendReturnsAnnual)
################################################################################
## Step 99.99: VERSION HISTORY                                               ###
################################################################################
a99.version       <- "1.0.0"
a99.ModDate       <- as.Date("2020-05-19")
# ------------------------------------------------------------------------------
# 2020.05.19 - v.1.0.0
# 1st release
# ------------------------------------------------------------------------------
# 2022.10.03 - v.1.0.1
# Generate the row number to the dataframe          https://tinyurl.com/ykw6z8be
# ------------------------------------------------------------------------------
