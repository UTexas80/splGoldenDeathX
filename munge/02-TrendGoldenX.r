################################################################################
## Step 00.01 Golden Cross Trading System       https://tinyurl.com/y3sq4ond ###
## Baseline Return                                                           ###
################################################################################
ret                      <- ROC(Cl(SPL.AX))
################################################################################
## Step 00.02.Baseline Signal & Return                  https://is.gd/swRbXV ###
## Seems counterintuitive but to create a leading .xts indicator use:        ###
## lag(x, -1)                                                                ###
# ------------------------------------------------------------------------------
#golden_ma_sig             <- lag(ifelse(ema020 > ema050 & ema050 >          ###
#ema100 & ema100 > ema200, 1, 0), -1)                                        ###
################################################################################
golden_ma_sigEMA           <- ifelse(ema020 > ema050 & ema050 >
ema100 & ema100 > ema200, 1, 0)
# ------------------------------------------------------------------------------
golden_ma_sigSMA           <- ifelse(sma020 > sma050 & sma050 >
sma100 & sma100 > sma200, 1, 0)
# ------------------------------------------------------------------------------
goldenCloseEMA             <- (close * golden_ma_sigEMA[golden_ma_sigEMA$EMA == 1])
goldenCloseSMA             <- (close * golden_ma_sigSMA[golden_ma_sigSMA$SMA == 1])
# ------------------------------------------------------------------------------
golden_ma_retEMA           <- (ret * golden_ma_sigEMA[golden_ma_sigEMA$EMA == 1])
golden_ma_retSMA           <- (ret * golden_ma_sigSMA[golden_ma_sigSMA$SMA == 1])
################################################################################
## Step 00.04.GOlden Cross Indicator                                         ###
################################################################################
goldenEMA                  <- cbind(golden_ma_retEMA, ret)
goldenSMA                  <- cbind(golden_ma_retSMA, ret)
golden                     <- cbind(golden_ma_retEMA, golden_ma_retSMA, ret)
# ------------------------------------------------------------------------------
colnames(goldenEMA)        <- c("GoldenCrossEMA", "Buy&Hold")
colnames(goldenSMA)        <- c("GoldenCrossSMA", "Buy&Hold")
colnames(golden)           <- c("GoldenCrossEMA", "GoldenCrossSMA", "Buy&Hold")
################################################################################
## Step 00.05.Max Drawdown & Performance Summary                             ###
################################################################################
trendDrawGoldenEMA         <-as.data.table(maxDrawdown(goldenEMA))
trendDrawGoldenSMA         <-as.data.table(maxDrawdown(goldenSMA))
trendDrawGolden            <-as.data.table(cbind(trendDrawGoldenEMA, 
                                trendDrawGoldenSMA))
# ------------------------------------------------------------------------------
trendSummaryGoldenEMA      <-as.data.table(table.AnnualizedReturns(goldenEMA, 
    Rf = 0.02 / 252), keep.rownames = TRUE)
trendSummaryGoldenSMA      <-as.data.table(table.AnnualizedReturns(goldenSMA, 
    Rf = 0.02 / 252), keep.rownames = TRUE)
trendSummaryGolden         <-as.data.table(table.AnnualizedReturns(golden, 
    Rf = 0.02 / 252), keep.rownames = TRUE)

trendClose                 <-merge(deathCloseEMA, deathCloseSMA, goldenCloseEMA, 
                                goldenCloseSMA)   
colnames(trendClose)       <- c("deathEMA", "deathSMA", "goldenEMA", "goldenSMA")
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version                <- "1.0.0"
a00.ModDate                <- as.Date("2019-10-11")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st released