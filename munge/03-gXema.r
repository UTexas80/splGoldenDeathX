 ################################################################################
# 1.0 Setup
################################################################################
strategy.st <- portfolio.st <- account.st <- gXema
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
gXema_mktdata_ind <-  applyIndicators(               # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
         columns            = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
         formula            = "(EMA.020 > EMA.050 &
                                EMA.050 > EMA.100 &
                                EMA.100 > EMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "gXema_open")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
         (columns           = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
         formula            = "(EMA.020 < EMA.050 |
                                EMA.050 < EMA.100 |
                                EMA.100 < EMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "gXema_close")
# ------------------------------------------------------------------------------
str(getStrategy(gXema)$signals)
gXema_mktdata_sig  <- applySignals(
    strategy                = strategy.st,
    mktdata                 = gXema_mktdata_ind)
################################################################################
# 5.0	Rules
################################################################################
 add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "gXema_open",
        sigval              = TRUE,
        orderqty            = init_equity,
        orderside           = "long",
        ordertype           = "market",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0,
        osFUN               = osMaxPos),
    type                    = "enter",
    path.dep                = TRUE)
# ------------------------------------------------------------------------------
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "gXema_close",
        sigval              = TRUE,
        orderqty            = "all",
        orderside           = "long",
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
    timestamp               <- initDate,
    maxpos                  <- init_equity,
    minpos                  <- 0)
################################################################################
# 7.0	Strategy
################################################################################
# browser()
t1 <- Sys.time()
gXema_strategy <- applyStrategy(strategy.st, portfolio.st, mktdata, symbols)
t2 <- Sys.time()
print(t2 - t1)
# ------------------------------------------------------------------------------
# cwd             <- getwd()
gXema_results   <- here::here("SPL-Dashboard/rds", "gXema_results.RData")
# ------------------------------------------------------------------------------
# if(file.exists(gXema_results)) {
#   base::load(gXema_results)
# } else {
#     gXema_strategy <- applyStrategy(strategy.st, portfolio.st)

#     if(checkBlotterUpdate(portfolio.st, account.st, verbose = TRUE)) {

#       save(
#         list = "gXema_strategy", 
#         file = here::here("SPL-Dashboard/rds/", paste0(gXema, "_", "results.RData")))

#     setwd("./SPL-Dashboard/rds")
#     save.strategy(strategy.st)
# #   save.strategy(paste0(strategy.st, "_", "strategy"))
#     setwd(cwd)

#     }
#   }
# ------------------------------------------------------------------------------
# t2 <- Sys.time()
# print(t2 - t1)
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
gXema_pts <- blotter::perTradeStats(portfolio.st, symbols)
# ------------------------------------------------------------------------------
gXema_stats <- data.table(tradeStats(portfolio.st,
                          use = "trades",
                          inclZeroDays = FALSE))
# ------------------------------------------------------------------------------
gXema_profit         <- gXema_stats %>%
  select(Net.Trading.PL, Gross.Profits, Gross.Losses, Profit.Factor)
t(gXema_profit)
# ------------------------------------------------------------------------------
gXema_wins           <-  gXema_stats %>%
  select(Avg.Trade.PL, Avg.Win.Trade, Avg.Losing.Trade, Avg.WinLoss.Ratio)
t(gXema_wins)
# ------------------------------------------------------------------------------
gXema_stats[, 4:ncol(gXema_stats)] <- round(gXema_stats[, 4:ncol(gXema_stats)], 2)
gXema_stats <- gXema_stats[, data.table(t(.SD), keep.rownames = TRUE)]
# ------------------------------------------------------------------------------
# use first row data as column names                https://tinyurl.com/ya3v4edm
# ------------------------------------------------------------------------------
gXema_trade_stats <- data.table::transpose(gXema_stats)
setnames(gXema_trade_stats, as.character(gXema_trade_stats[1,]))
gXema_trade_stats <- gXema_trade_stats[-1,]
################################################################################
# 10.0	Trend - create dashboard dataset
################################################################################
gXema_trend <- data.table(gXema_pts)
gXema_trend[, `:=`(tradeDays, lapply(paste0(gXema_pts[, 1], "/", gXema_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))]
gXema_trend[, calendarDays := as.numeric(duration/86400)]
# ------------------------------------------------------------------------------
gXema_trend[, c("catName","indicator"):=list("GoldenX", "EMA")]
gXema_trend[, grp := .GRP, by=Start] 
gXema_trend[, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]
# ------------------------------------------------------------------------------
gXema_trend[, `:=`(tradeDays, lapply(paste0(gXema_pts[, 1], "/", gXema_pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))][
, calendarDays := as.numeric(duration/86400)][
, c("catName","indicator"):=list("GoldenX", "EMA")][
, grp := .GRP, by=Start][ 
, subcatName := paste0(catName, 
                paste0(sprintf("%03d", grp),
                paste0(indicator)))]
# ------------------------------------------------------------------------------
# unlist a column in a data.table                           https://is.gd/ZuntI3
# ------------------------------------------------------------------------------
gXema_trend[rep(gXema_trend[, .I], lengths(tradeDays))][
  , tradeDays := unlist(gXema_trend$tradeDays)][]
gXema_trend$tradeDays <- unlist(gXema_trend$tradeDays)
# ------------------------------------------------------------------------------
# add Start / End open price                                                 ***
# ------------------------------------------------------------------------------
setkey(gXema_trend, "Start")
gXema_trend <- na.omit(gXema_trend[SPL, nomatch = 0][, -c(26,28:32)])
setkey(gXema_trend, "End")
gXema_trend <- na.omit(gXema_trend[SPL, nomatch = 0][, -c(27,29:33)])
################################################################################
# 11.0	# Performance and Risk Metrics                                       ***
################################################################################
gXema_rets           <- PortfReturns(Account =  account.st)
rownames(gXema_rets) <- NULL
names(gXema_rets)[1] <- strategy.st
# ------------------------------------------------------------------------------
gXema_perf <- table.Arbitrary(gXema_rets,
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
gXema_risk <- table.Arbitrary(gXema_rets,
  metrics = c(
    "StdDev.annualized",
    "maxDrawdown"
  ),
  metricsNames = c(
    "Annualized StdDev",
    "Max DrawDown"
  )
)
