
################################################################################
## Step 00.00 xtsMonthly Returns in the xts World                            ###
## https://tinyurl.com/yyyf4qqw                                              ###
################################################################################
prices_monthly    <- to.monthly(xtsPrices, indexAt = "lastof", OHLC = FALSE)
asset_returns_xts <- na.omit(Return.calculate(prices_monthly, method = "log"))
################################################################################
## Step 00.01: AUD Prices                                                    ###
################################################################################
aud_usd           <- na.omit(getSymbols("AUD=X", src = "yahoo", 
    auto.assign = FALSE))
aud_usd           <- aud_usd[complete.cases(aud_usd), ]
usd_aud           <- 1 / aud_usd
# ------------------------------------------------------------------------------
dtSPL             <- as.data.table(SPL.AX, keep.rownames = TRUE)
names(dtSPL)[1]   <- "date"
setkey(dtSPL, "date")
# dtSPL             <- dtSPL[dtEMA][, c(1:5, 18)]
# ------------------------------------------------------------------------------
xtsPrice     <- as.xts.data.table(dcast.data.table(dtSPL[dtEMA][, c(1:5, 18)], formula = date ~ 
  eventGroupNum, value.var = "SPL.AX.Close"))

xtsPriceSMA  <- as.xts.data.table(dcast.data.table(dtSPL[dtSMA][, c(1:5, 18)], formula = date ~ 
  catNum, value.var = "SPL.AX.Close"))

cumReturn         <- apply(X = xtsPrice, 2, FUN = function(Z) Return.cumulative(as.numeric(Z), 
  geometric = TRUE))  # https://tinyurl.com/y2d2ve83
################################################################################
## Step 00.02 Golden Cross Trading System       https://tinyurl.com/y3sq4ond ###
## Baseline Return                                                           ###
################################################################################
ret               <- ROC(Cl(SPL.AX))
################################################################################
## Step 00.03.Baseline Signal & Return                  https://is.gd/swRbXV ###
## Seems counterintuitive but to create a leading .xts indicator use:        ###
## lag(x, -1)                                                                ###
################################################################################
golden_ma_sigEMA  <- ifelse(ema020 > ema050 & ema050 >
ema100 & ema100 > ema200, 1, 0)
# ------------------------------------------------------------------------------
golden_ma_sigSMA  <- lag(ifelse(sma020 > sma050 & sma050 >
sma100 & sma100 > sma200, 1, 0), -1)
# ------------------------------------------------------------------------------
#golden_ma_sig    <- lag(ifelse(ema020 > ema050 & ema050 >
#ema100 & ema100 > ema200, 1, 0), -1)  
# ------------------------------------------------------------------------------
golden_ma_retEMA    <- (ret * golden_ma_sigEMA[golden_ma_sigEMA$EMA == 1])
golden_ma_retSMA    <- (ret * golden_ma_sigSMA[golden_ma_sigSMA$SMA == 1])
################################################################################
## Step 00.04.GOlden Cross Indicator                                         ###
################################################################################
goldenEMA            <- cbind(golden_ma_retEMA, ret)
goldenSMA            <- cbind(golden_ma_retSMA, ret)
colnames(goldenEMA)  <- c("GoldenCrossEMA", "Buy&Hold")
colnames(goldenEMA)  <- c("GoldenCrossSMA", "Buy&Hold")
################################################################################
## Step 00.05.Max Drawdown & Performance Summary                             ###
################################################################################
trendDrawEMA         <-as.data.table(maxDrawdown(goldenEMA))
trendDrawSMA         <-as.data.table(maxDrawdown(goldenSMA))
trendSummaryEMA      <-as.data.table(table.AnnualizedReturns(goldenEMA, 
    Rf = 0.02 / 252), keep.rownames = TRUE)
trendSummarySMA      <-as.data.table(table.AnnualizedReturns(goldenSMA, 
    Rf = 0.02 / 252), keep.rownames = TRUE)
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st released
