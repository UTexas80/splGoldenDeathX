################################################################################
## Step 00.01 Golden Cross Trading System       https://tinyurl.com/y3sq4ond ###
## Baseline Return                                                           ###
################################################################################
# ret                      <- ROC(Cl(SPL.AX))
################################################################################
## Step 00.02.Baseline Signal & Return                  https://is.gd/swRbXV ###
## Seems counterintuitive but to create a leading .xts indicator use:        ###
## lag(x, -1)                                                                ###
# ------------------------------------------------------------------------------
#golden_ma_sig             <- lag(ifelse(ema020 > ema050 & ema050 >          ###                    
#ema100 & ema100 > ema200, 1, 0), -1)                                        ###
################################################################################
dtGoldenDeathEMA<-data.table(xts::rbind.xts(death_ma_retEMA, golden_ma_retEMA),
    keep.rownames = T)
neither_ma_sigEMA <- as.xts(anti_join(dtSPL, dtGoldenDeathEMA, by = c("date" = "index")))

# neither_ma_sigEMA <- !ifelse((ema020 > ema050 & ema050 > ema100 & ema100 > ema200) 
#                            & (ema200 > ema100 & ema100 > ema050 & ema050 > ema020), 
#                              1, 0)
# ------------------------------------------------------------------------------
dtGoldenDeathSMA<-data.table(xts::rbind.xts(death_ma_retSMA, golden_ma_retSMA),
    keep.rownames = T)
neither_ma_sigSMA <- anti_join(dtSPL, dtGoldenDeathSMA, by = c("date" = "index"))

# neither_ma_sigSMA <- !ifelse((sma020 > sma050 & sma050 > sma100 & sma100 > sma200) 
#                            & (sma200 > sma100 & sma100 > sma050 & sma050 > sma020), 
#                              1, 0)
# ------------------------------------------------------------------------------
neitherCloseEMA             <- (close * neither_ma_sigEMA[neither_ma_sigEMA$EMA == 1])
neitherCloseSMA             <- (close * neither_ma_sigSMA[neither_ma_sigSMA$SMA == 1])
# ------------------------------------------------------------------------------
neither_ma_retEMA           <- (ret * neither_ma_sigEMA[neither_ma_sigEMA$EMA == 1])
neither_ma_retSMA           <- (ret * neither_ma_sigSMA[neither_ma_sigSMA$SMA == 1])
################################################################################
## Step 00.04.neither Cross Indicator                                         ###
################################################################################
neitherEMA                  <- cbind(neither_ma_retEMA, ret)
neitherSMA                  <- cbind(neither_ma_retSMA, ret)
neither                     <- cbind(neither_ma_retEMA, neither_ma_retSMA, ret)
# ------------------------------------------------------------------------------
colnames(neitherEMA)        <- c("neitherCrossEMA", "Buy&Hold")
colnames(neitherSMA)        <- c("neitherCrossSMA", "Buy&Hold")
colnames(neither)           <- c("neitherCrossEMA", "neitherCrossSMA", "Buy&Hold")
################################################################################
## Step 00.05.Max Drawdown & Performance Summary                             ###
################################################################################
trendDrawneitherEMA         <-as.data.table(maxDrawdown(neitherEMA))
trendDrawneitherSMA         <-as.data.table(maxDrawdown(neitherSMA))
trendDrawneither            <-as.data.table(cbind(trendDrawneitherEMA, trendDrawneitherSMA))
# ------------------------------------------------------------------------------
trendSummaryneitherEMA      <-as.data.table(table.AnnualizedReturns(neitherEMA, 
    Rf = 0.02 / 252), keep.rownames = TRUE)
trendSummaryneitherSMA      <-as.data.table(table.AnnualizedReturns(neitherSMA, 
    Rf = 0.02 / 252), keep.rownames = TRUE)
trendSummaryneither         <-as.data.table(table.AnnualizedReturns(neither, 
    Rf = 0.02 / 252), keep.rownames = TRUE)

trendClose                 <-merge(deathCloseEMA, deathCloseSMA, neitherCloseEMA, neitherCloseSMA)   
colnames(trendClose)       <- c("deathEMA", "deathSMA", "neitherEMA", "neitherSMA")
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version                <- "1.0.0"
a00.ModDate                <- as.Date("2019-10-11")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st released
