################################################################################
## Step 00.01 death Cross Trading System       https://tinyurl.com/y3sq4ond  ###
## Baseline Return                                                           ###
################################################################################
close                     <- Cl(SPL.AX)
ret                       <- ROC(Cl(SPL.AX))
################################################################################
## Step 00.02.Baseline Signal & Return                  https://is.gd/swRbXV ###
## Seems counterintuitive but to create a leading .xts indicator use:        ###
## lag(x, -1)                                                                ###
# ------------------------------------------------------------------------------
#death_ma_sig             <- lag(ifelse(ema020 > ema050 & ema050 >           ###
#ema100 & ema100 > ema200, 1, 0), -1)                                        ###
################################################################################
death_ma_sigEMA           <- ifelse(ema020 < ema050 & ema050 <
ema100 & ema100 < ema200, 1, 0)
# ------------------------------------------------------------------------------
death_ma_sigSMA           <- ifelse(sma020 < sma050 & sma050 <
sma100 & sma100 < sma200, 1, 0)
# ------------------------------------------------------------------------------
deathCloseEMA             <- (close * death_ma_sigEMA[death_ma_sigEMA$EMA == 1])
deathCloseSMA             <- (close * death_ma_sigSMA[death_ma_sigSMA$SMA == 1])
# ------------------------------------------------------------------------------
death_ma_retEMA           <- (ret * death_ma_sigEMA[death_ma_sigEMA$EMA == 1])
death_ma_retSMA           <- (ret * death_ma_sigSMA[death_ma_sigSMA$SMA == 1])
################################################################################
## Step 00.04.death Cross Indicator                                          ###
################################################################################
deathEMA                  <- cbind(death_ma_retEMA, ret)
deathSMA                  <- cbind(death_ma_retSMA, ret)
death                     <- cbind(death_ma_retEMA, death_ma_retSMA, ret)
# ------------------------------------------------------------------------------
colnames(deathEMA)        <- c("deathCrossEMA", "Buy&Hold")
colnames(deathSMA)        <- c("deathCrossSMA", "Buy&Hold")
colnames(death)           <- c("deathCrossEMA", "deathCrossSMA", "Buy&Hold")
################################################################################
## Step 00.05.Max Drawdown & Performance Summary                             ###
################################################################################
trendDrawDeathEMA         <-as.data.table(maxDrawdown(deathEMA))
trendDrawDeathSMA         <-as.data.table(maxDrawdown(deathSMA))
trendDrawDeath            <-as.data.table(cbind(trendDrawDeathEMA,
                                trendDrawDeathSMA))
# ------------------------------------------------------------------------------
trendSummaryDeathEMA      <-as.data.table(table.AnnualizedReturns(deathEMA,
    Rf = 0.02 / 252), keep.rownames = TRUE)

trendSummaryDeathSMA      <-as.data.table(table.AnnualizedReturns(deathSMA,
    Rf = 0.02 / 252), keep.rownames = TRUE)

trendSummaryDeath         <-as.data.table(table.AnnualizedReturns(death,
    Rf = 0.02 / 252), keep.rownames = TRUE)
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version               <- "1.0.0"
a00.ModDate               <- as.Date("2019-10-11")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st released
