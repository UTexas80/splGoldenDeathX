################################################################################
# 1.0 Setup
################################################################################
strategy.st <- portfolio.st <- account.st <- dXema
rm.strat(strategy.st)
rm.strat(account.st)
rm.strat(portfolio.st)
################################################################################
# 2.0	Initialization
################################################################################
initPortf(name              = portfolio.st,         # Portfolio Initialization
    symbols                 = symbols,
    currency                = curr,
    initDate                = initDate,
    initEq                  = initEq)
# ------------------------------------------------------------------------------
initAcct(name               = account.st,           # Account Initialization
    portfolios              = portfolio.st,
    currency                = curr,
    initDate                = initDate,
    initEq                  = initEq)
# ------------------------------------------------------------------------------
initOrders(portfolio        = portfolio.st,         # Order Initialization
    symbols                 = symbols,
    initDate                = initDate)
# ------------------------------------------------------------------------------
strategy(strategy.st, store = TRUE)                 # Strategy initialization
################################################################################
# 3.0	Indicators
################################################################################
add.indicator(strategy.st,                          # 20-day EMA indicator
    name                    = "EMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 20),
    label                   = "020")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 50-day EMA indicator
    name                    = "EMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 50),
    label                   = "050")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 100-day EMA indicator
    name                    = "EMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 100),
    label                   = "100")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 200-day EMA indicator
    name                    = "EMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 200),
    label                   = "200")
# ------------------------------------------------------------------------------
str(getStrategy(dXema)$indicators)
dXema_mktdata_ind <-  applyIndicators(              # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
        columns             = c("EMA.020","EMA.050","EMA.100","EMA.200"),
#        formula             = "(EMA.020 < EMA.050 &
#                                EMA.050 < EMA.100 &
#                                EMA.100 < EMA.200)",
        formula             =  deathX,        
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXema_shortEntry")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
        (columns            = c("EMA.020","EMA.050","EMA.100","EMA.200"),
#        formula             = "(EMA.020 > EMA.050 | EMA.050 > EMA.100 | EMA.100 > EMA.200) & index.xts(mktdata)  > '2002-12-02'",
          formula            = "(EMA.020 > EMA.050 & EMA.050 > EMA.100 & EMA.100 > EMA.200) & index.xts(mktdata) > '2002-12-02)'",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXema_shortExit")
# ------------------------------------------------------------------------------
str(getStrategy(dXema)$signals)
browser()
dXema_mktdata_sig           <- applySignals(
    strategy                = strategy.st,
    mktdata                 = complete.cases(dXema_mktdata_ind))
browser()
################################################################################
# 5.0	Rules
################################################################################
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXema_shortEntry",
        sigval              = TRUE,
        orderqty            = -1000,
        orderside           = "short",
        ordertype           = "market",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0),
  #      osFUN               = osMaxPos),
    type                    = "enter",
    path.dep                = TRUE)
# ------------------------------------------------------------------------------
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXema_shortExit",
        sigval              = TRUE,
        orderqty            = "all",
        orderside           = "short",
        ordertype           = "market",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0),
    type                    = "exit",
    path.dep                = TRUE)
################################################################################
# 6.0	Position Limits
################################################################################
addPosLimit(portfolio.st, symbols,
    timestamp               <- from,
    maxpos                  <- 100,
    minpos                  <- 0)
################################################################################
# 7.0	Strategy
################################################################################
# browser()
t1      <- Sys.time()
dXema_strategy <- applyStrategy(strategy.st, portfolio.st, mktdata, symbols)
t2      <- Sys.time()
print(t2 - t1)
################################################################################
# 8.0	Evaluation - update P&L and generate transactional history
################################################################################
updatePortf(portfolio.st)
dateRange  <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(account.st, dateRange)
# ------------------------------------------------------------------------------
updateEndEq(account.st)
save.strategy(strategy.st)
################################################################################
# 9.0	Trend - create dashboard dataset
################################################################################
dXema_pts   <- blotter::perTradeStats(portfolio.st, symbols)
dXema_trend <- data.table(dXema_pts)
# dXema_trend[, `:=`(tradeDays, lapply(paste0(dXema_pts[, 1], "/", dXema_pts[, 2]), 
#   function(x) length(SPL.AX[, 6][x])+1))]
# dXema_trend[, calendarDays := as.numeric(duration/86400)]
# # ------------------------------------------------------------------------------
# dXema_trend[, c("catName","indicator"):=list("DeathX", "EMA")]
# dXema_trend[, grp := .GRP, by=Start] 
# dXema_trend[, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]
# ------------------------------------------------------------------------------
dXema_trend[, `:=`(tradeDays, lapply(paste0(dXema_pts[, 1], "/", dXema_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))][
, calendarDays := as.numeric(duration/86400)][
, c("catName","indicator"):=list("DeathX", "EMA")][
, grp := .GRP, by=Start][ 
, subcatName := paste0(catName, 
                paste0(sprintf("%03d", grp),
                paste0(indicator)))]
# ------------------------------------------------------------------------------
# unlist a column in a data.table                           https://is.gd/ZuntI3
# ------------------------------------------------------------------------------
dXema_trend[rep(dXema_trend[,.I], lengths(tradeDays))][
  , tradeDays := unlist(dXema_trend$tradeDays)][]
dXema_trend$tradeDays <- unlist(dXema_trend$tradeDays)
# ------------------------------------------------------------------------------
# add Start / End open price                                                 ***
# ------------------------------------------------------------------------------
setkey(dXema_trend, "Start")
dXema_trend          <- na.omit(dXema_trend[SPL][, -c(27:31)])
setkey(dXema_trend, "End")
dXema_trend          <- na.omit(dXema_trend[SPL][, -c(28:32)])
################################################################################
# 10.0	# Performance and Risk Metrics 
################################################################################
# ------------------------------------------------------------------------------
# Profits
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
dXema_stats          <- tradeStats(Portfolios = portfolio.st, use="trades", inclZeroDays=FALSE)
# ------------------------------------------------------------------------------
dXema_profit         <- dXema_stats %>% 
  select(Net.Trading.PL, Gross.Profits, Gross.Losses, Profit.Factor)
t(dXema_profit)
# ------------------------------------------------------------------------------
dXema_wins           <-  dXema_stats %>% 
  select(Avg.Trade.PL, Avg.Win.Trade, Avg.Losing.Trade, Avg.WinLoss.Ratio)
t(dXema_wins)
# ------------------------------------------------------------------------------
dXema_rets           <- PortfReturns(Account =  account.st)
rownames(dXema_rets) <- NULL
# ------------------------------------------------------------------------------
dXema_perf           <- table.Arbitrary(dXema_rets,
                            metrics = c(
                              "Return.cumulative",
                              "Return.annualized",
                              "SharpeRatio.annualized",
                              "CalmarRatio"),
                            metricsNames = c(
                              "Cumulative Return",
                              "Annualized Return",
                              "Annualized Sharpe Ratio",
                              "Calmar Ratio"))
# ------------------------------------------------------------------------------
dXema_stats          <- data.table(dXema_stats)
dXema_stats[, 4:ncol(dXema_stats)] <- round(dXema_stats[, 4:ncol(dXema_stats)], 2)
dXema_stats         <- dXema_stats[, data.table(t(.SD), keep.rownames = TRUE)]
# ------------------------------------------------------------------------------
# Risk Statistics
# ------------------------------------------------------------------------------ 
dXema_risk           <- table.Arbitrary(dXema_rets,
                            metrics = c(
                              "StdDev.annualized",
                              "maxDrawdown"),
                            metricsNames = c(
                              "Annualized StdDev",
                              "Max DrawDown"))
