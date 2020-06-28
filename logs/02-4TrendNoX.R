################################################################################
## Step 00.01 Golden Cross Trading System       https://tinyurl.com/y3sq4ond ###
## Baseline Return                                                           ###
################################################################################
# ret                       <- ROC(Cl(SPL.AX))
################################################################################
## Step 00.02.Baseline Signal & Return                  https://is.gd/swRbXV ###
## Seems counterintuitive but to create a leading .xts indicator use:        ###
## lag(x, -1)                                                                ###
# ------------------------------------------------------------------------------
# golden_ma_sig              <- lag(ifelse(ema020 > ema050 & ema050 >        ###
#ema100 & ema100 > ema200, 1, 0), -1)                                        ###
################################################################################
dtGoldenDeathEMA <- data.table(xts::rbind.xts(death_ma_retEMA, golden_ma_retEMA),
    keep.rownames = T)
dtGoldenDeathSMA <- data.table(xts::rbind.xts(death_ma_retSMA, golden_ma_retSMA),
    keep.rownames = T)    
################################################################################
## Converting a data frame to xts --------------------- https://is.gd/9ucTXR ###
## as_xts(q, date_col = t)                                                   ###
## as_xts is deprecated; use tk_xts                                          ###
################################################################################
## Step 00.03.neither Cross Indicator                                        ###
################################################################################
neitherEMA <- ret * (tk_xts(anti_join(dtSPL, dtGoldenDeathEMA,
    by = c("date" = "index")),date=t)[,4])
neitherSMA <- ret * (tk_xts(anti_join(dtSPL, dtGoldenDeathSMA,
    by = c("date" = "index")),date=t)[,4])
neither <- cbind(neitherEMA, neitherSMA, ret)
# rename columns----------------------------------------------------------------
colnames(neither) <- c("neitherCrossEMA", "neitherCrossSMA", "Buy&Hold")
################################################################################
## Step 00.04.Max Drawdown                                                   ###
################################################################################
trendDrawNeither <- as.data.table(maxDrawdown(neither))
################################################################################
## Step 00.05.Annualized Returns                                             ###
################################################################################
trendSummaryNeither <-as.data.table(table.AnnualizedReturns(neither, 
    Rf = 0.02 / 252), keep.rownames = TRUE)
# trend summary ----------------------------------------------------------------
trendReturnsAnnualized <- cbind(trendSummaryDeath[,1:3],
                      trendSummaryGolden[,2:3],
                      trendSummaryNeither[,2:4])
trendReturnsDaily <- cbind(death[,1:2], golden[,1:2], neither)
################################################################################
## Step 00.06.Closing Price Table                                            ###
################################################################################
neitherCloseEMA <- tk_xts(anti_join(dtSPL, dtGoldenDeathEMA,
    by = c("date" = "index")),date=t)[,4]
neitherCloseSMA <- tk_xts(anti_join(dtSPL, dtGoldenDeathSMA,
    by = c("date" = "index")),date=t)[,4]
# ------------------------------------------------------------------------------
trendClose <- merge(deathCloseEMA, deathCloseSMA, 
                    goldenCloseEMA, goldenCloseSMA, 
                    neitherCloseEMA, neitherCloseSMA)
colnames(trendClose) <- c("deathEMA", "deathSMA", 
                          "goldenEMA", "goldenSMA",
                          "neitherEMA", "neitherSMA")                          
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version                 <- "1.0.0"
a00.ModDate                 <- as.Date("2019-10-11")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st released
