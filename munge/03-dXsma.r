################################################################################
# 1.0 Setup
################################################################################
strategy.st <- portfolio.st <- account.st <- dXsma
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
add.indicator(strategy.st,                          # 20-day SMA indicator
    name                    = "SMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 20),
    label                   = "020")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 50-day SMA indicator
    name                    = "SMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 50),
    label                   = "050")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 100-day SMA indicator
    name                    = "SMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 100),
    label                   = "100")
# ------------------------------------------------------------------------------
add.indicator(strategy.st,                          # 200-day SMA indicator
    name                    = "SMA",
    arguments               = list(
      x                     = quote(mktdata[,4]),
      n                     = 200),
    label                   = "200")
# ------------------------------------------------------------------------------

dXsma_mktdata_ind <-  applyIndicators(              # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
        columns             = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
        formula             = "(SMA.020 < SMA.050 &
                                SMA.050 < SMA.100 &
                                SMA.100 < SMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXsma_shortEntry")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
        (columns            = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
        formula             = "(SMA.020 > SMA.050  |
                                SMA.050 > SMA.100  |
                                SMA.100 > SMA.200) &
                               index(mktdata)  > '2002-12-02'",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXsma_shortExit")
# ------------------------------------------------------------------------------
str(getStrategy(dXsma)$signals)
# ------------------------------------------------------------------------------
dXsma_mktdata_sig  <-  applySignals(
    strategy                = strategy.st,
    mktdata                 = dXsma_mktdata_ind)
################################################################################
# 5.0	Rules
################################################################################
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXsma_shortEntry",
        sigval              = TRUE,
        orderqty            = -init_equity,
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
        sigcol              = "dXsma_shortExit",
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
    maxpos                  <- -init_equity,
    minpos                  <- 0)
################################################################################
# 7.0	Strategy
################################################################################
# browser()
t1      <- Sys.time()
dXsma_strategy <- applyStrategy(strategy.st, portfolio.st, mktdata, symbols)
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
# 9.0	Trade Stats - create dashboard trade statistics
################################################################################
dXsma_pts    <- blotter::perTradeStats(portfolio.st, symbols)
# ------------------------------------------------------------------------------
dXsma_stats  <- tradeStats(Portfolios = portfolio.st,
                           use="trades",
                           inclZeroDays=FALSE)
# -----------------------------------------------------------------------------
dXsma_profit <- dXsma_stats %>%
  select(Net.Trading.PL, Gross.Profits, Gross.Losses, Profit.Factor)
t(dXsma_profit)
# ------------------------------------------------------------------------------
dXsma_wins   <-  dXsma_stats %>%
  select(Avg.Trade.PL, Avg.Win.Trade, Avg.Losing.Trade, Avg.WinLoss.Ratio)
t(dXsma_wins)
# ------------------------------------------------------------------------------
dXsma_stats  <- as.data.table(dXsma_stats)
dXsma_stats[, 4:ncol(dXsma_stats)] <- round(dXsma_stats[, 4:ncol(dXsma_stats)], 2)
dXsma_stats  <- dXsma_stats[, data.table(t(.SD), keep.rownames = TRUE)]
# ------------------------------------------------------------------------------
# use first row data as column names                https://tinyurl.com/ya3v4edm
# ------------------------------------------------------------------------------
dXsma_trade_stats <- data.table::transpose(dXsma_stats)
setnames(dXsma_trade_stats, as.character(dXsma_trade_stats[1,]))
dXsma_trade_stats <- dXsma_trade_stats[-1,]
################################################################################
# 10.0	Trend - create dashboard dataset
################################################################################
dXsma_trend <- data.table(dXsma_pts)
dXsma_trend[, `:=`(tradeDays, lapply(paste0(dXsma_pts[, 1], "/", dXsma_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))]
dXsma_trend[, calendarDays := as.numeric(duration/86400)]
# ------------------------------------------------------------------------------
dXsma_trend[, c("catName","indicator"):=list("DeathX", "EMA")]
dXsma_trend[, grp := .GRP, by=Start]
dXsma_trend[, subcatName := paste0(catName,
                            paste0(sprintf("%03d", grp)))]
# ------------------------------------------------------------------------------
dXsma_trend[, `:=`(tradeDays, lapply(paste0(dXsma_pts[, 1], "/", dXsma_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))][
, calendarDays := as.numeric(duration/86400)][
, c("catName","indicator"):=list("DeathX", "SMA")][
, grp := .GRP, by=Start][ 
, subcatName := paste0(catName, 
                paste0(sprintf("%03d", grp),
                paste0(indicator)))]
# ------------------------------------------------------------------------------
# unlist a column in a data.table                           https://is.gd/ZuntI3
# ------------------------------------------------------------------------------
dXsma_trend[rep(dXsma_trend[,.I], lengths(tradeDays))][
    , tradeDays := unlist(dXsma_trend$tradeDays)][]
dXsma_trend$tradeDays <- unlist(dXsma_trend$tradeDays)
# ------------------------------------------------------------------------------
# add Start / End open price                                                 ***
# ------------------------------------------------------------------------------
setkey(dXsma_trend, "Start")
dXsma_trend <- na.omit(dXsma_trend[SPL][, -c(27:31)])
setkey(dXsma_trend, "End")
dXsma_trend <- na.omit(dXsma_trend[SPL][, -c(28:32)])
################################################################################
# 11.0	# Performance and Risk Metrics 
################################################################################
dXsma_rets           <- PortfReturns(Account =  account.st)
rownames(dXsma_rets) <- NULL
# ------------------------------------------------------------------------------
dXsma_perf <- table.Arbitrary(dXsma_rets,
  metrics = c(
    "Return.cumulative",
    "Return.annualized",
    "SharpeRatio.annualized",
    "CalmarRatio"
  ),
  metricsNames = c(
    "Cumulative Return",
    "Annualized Return",
    "Annualized Sharpe Ratio",
    "Calmar Ratio"
  )
)
# ------------------------------------------------------------------------------ Risk
dXsma_risk <- table.Arbitrary(dXsma_rets,
  metrics = c(
    "StdDev.annualized",
    "maxDrawdown"
  ),
  metricsNames = c(
    "Annualized StdDev",
    "Max DrawDown"
  )
)

