################################################################################
## Step 99.00 trade stats                                                    ###
################################################################################
dtSPL$row <- dtSPL[, .I[1], by=date][,2]
dtSPL$dayDiff <- data.table(dayDifff(SPL.AX))                                   # https://tinyurl.com/ybcssoh8
dtSPL[is.na(dtSPL)] <- 0                                                        # replace na's with zero
data.table::setkey(dtSPL, date)
# ------------------------------------------------------------------------------
l       <- list(dXema_trend, dXsma_trend, gXema_trend, gXsma_trend, nXema_trend, nXsma_trend)
trend   <- rbindlist(l)
# ------------------------------------------------------------------------------# https://tinyurl.com/yb29lhr9
trend$Start <- as_date(trend$Start)
trend$End   <- as_date(trend$End)
# ------------------------------------------------------------------------------
data.table::setkey(trend, Start)
trend      <- trend[dtSPL, nomatch = 0][,-c(30:35)]
data.table::setkey(trend, End)
trend      <- trend[dtSPL, nomatch = 0][,-c(32:37)]
# ------------------------------------------------------------------------------
# trend   <- trend[, c(23, 22, 25, 1, 27, 2, 29, 13, 9:10, 20:21)]
# trend   <- dtSPL[trend][,-c(2:7)]
# ------------------------------------------------------------------------------
# trend[, `:=`(tradeStart, lapply(trend[,4],    function(x)  x + 86400))]
# trend[, `:=`(tradeStart, lapply(trend[,30],    function(x) xts:::index.xts(SPL.AX[x+1])))]
trend$tradeStart = trend$Start + trend$dayDiff
trend[, `:=`(tradeOpen,   apply( trend[,1], 1, function(x) lag(Op(SPL.AX), -1)[x]))]
# ------------------------------------------------------------------------------
# data.table::setkey(trend, End)
# trend   <- dtSPL[trend]
# browser()
# trend   <- dtSPL[trend][,-c(2:7)]
# # ------------------------------------------------------------------------------
# trend[, `:=`(tradeEnd, apply(trend[,31],  1,  function(x) if(x < nrow(SPL.AX)) {xts:::index.xts(SPL.AX[x+1])}))]
# if(x != nrow(SPL.AX)) {
#   print("X is an Integer")
# }
# trend[, `:=`(tradeEnd,    lapply(trend[,1],    function(x) x + trend[,39]))]
trend$tradeEnd = trend$End + trend$i.dayDiff
trend[, `:=`(tradeClose,   apply( trend[,2], 1, function(x) lag(Op(SPL.AX), -1)[x]))]
names(trend)[c(34,36,13,35,37)] <- c("startDate", "endDate", "return", "startOpen", "endOpen")
# ------------------------------------------------------------------------------# https://tinyurl.com/tmmubbh
trendReturns      <- data.table(t(trend[, c(25,13)]))                             # subcatName, return
trendReturns      <- setnames(trendReturns, as.character(trendReturns[1,]))[-1,] %>%
                     mutate_if(is.character,as.numeric) 
# ------------------------------------------------------------------------------
dt_trade_stats    <- rbind.data.frame(dXema_trade_stats,
                                   dXsma_trade_stats,
                                   gXema_trade_stats,
                                   gXsma_trade_stats,
                                   nXema_trade_stats,
                                   nXsma_trade_stats
                                   )
# ------------------------------------------------------------------------------
# nXema_trade_stats <- data.table::transpose(as.data.table(nXema_trend[, c(25,13)]))
# setnames(nXema_trade_stats, as.character(nXema_trade_stats[1,]))
# nXema_trade_stats <- nXema_trade_stats[-1,]
# nXema_trade_stats <- nXema_trade_stats[, lapply(.SD, as.numeric)]
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
death_ma_sigSMA           <- lag(ifelse(sma020 < sma050 & sma050 <
                                        sma100 & sma100 < sma200, 1, 0),
                             1)
# ------------------------------------------------------------------------------
deathOpenEMA              <- (open * death_ma_sigEMA[death_ma_sigEMA$EMA == 1])
deathOpenSMA              <- (open * death_ma_sigSMA[death_ma_sigSMA$SMA == 1])
# ------------------------------------------------------------------------------
# dXema_ret                 <- (ret * death_ma_sigEMA[death_ma_sigEMA$EMA == 1])
# dXsma_ret                 <- (ret * death_ma_sigSMA[death_ma_sigSMA$SMA == 1])
death_ma_retEMA           <- dailyReturn(deathOpenEMA) * -1
death_ma_retSMA           <- dailyReturn(deathOpenSMA) * -1
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
golden_ma_sigSMA           <- lag(ifelse(sma020 > sma050 & sma050 >
                                         sma100 & sma100 > sma200, 1, 0),
                              1)
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
nXsma_sig <- lag(
                ifelse(!(sma020 < sma050 & sma050 < sma100 & sma100 < sma200) &
                       !(sma020 > sma050 & sma050 > sma100 & sma100 > sma200), 1,0),
                1)
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
colnames(nXema)  <- c("nXema", "Buy&Hold")
colnames(nXsma)  <- c("nXsma", "Buy&Hold")
colnames(nX)     <- c("nXema", "nXsma", "Buy&Hold")
# ------------------------------------------------------------------------------
trendReturnsDaily <- cbind(death[,1:2], golden[,1:2], nX)
################################################################################
## Step 99.99: VERSION HISTORY                                               ###
################################################################################
a99.version       <- "1.0.0"
a99.ModDate       <- as.Date("2020-05-19")
# ------------------------------------------------------------------------------
# 2020.05.19 - v.1.0.0
# 1st release
