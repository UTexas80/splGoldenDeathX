################################################################################
# How Do I in R?                                https://tinyurl.com/y9j67lfk ###
################################################################################
## Step 04.3.01 get stock symbols               https://tinyurl.com/y3adrqwa ###
## Check existence of directory and create if doesn't exist                  ###
################################################################################
symbols      <- basic_symbols()
suppressMessages(
  getSymbols(
    Symbols = symbols,
    src = "yahoo",
    index.class = "POSIXct",
    from = start_date,
    to = end_date,
    adjust = adjustment)
           )
# ------------Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###
SPL.AX <-
  SPL.AX %>%
  na.omit()
## -- use FinancialInstrument::stock() to define the meta-data for the symbols.-
# stock(symbols, currency = "USD", multiplier = 1)
################################################################################
## Step 04.02: Portfolio, Account, Strategy Setup                            ###
################################################################################
# Delete portfolio, account, and order book if they already exist------------###
suppressWarnings(rm("account.GoldenX","portfolio.GoldenX",pos=.blotter))
suppressWarnings(rm("order_book.GoldenX",pos=.strategy))
## -- remove residuals from previous runs. ----------------------------------###
rm.strat("goldenX_EMA_portfolio")
rm.strat("GoldenX")
# ------------------------------------------------------------------------------
# To start, we initialize account and portfolio where:                       ###
# Porfolio: stores which stocks to be traded                                 ###
# Account: stores money transactions                                         ###
# ------------------------------------------------------------------------------
initPortf(name = "goldenX_EMA_portfolio",     # Portfolio Initialization     ###
          symbols = symbols,
          initDate = init_date)
# ------------------------------------------------------------------------------
initAcct(name = "GoldenX",                     # Account Initialization      ###
         portfolios="goldenX_EMA_portfolio",
         initDate=init_date,
         initEq=init_equity)
# ------------------------------------------------------------------------------
initOrders(portfolio="goldenX_EMA_portfolio",  # Order Initialization        ###
           symbols = symbols,
           initDate=init_date)
# ------------------------------------------------------------------------------
goldenX_EMA_strategy <- strategy("GoldenX")    # Strategy Initialization     ###
################################################################################
## Step 04.03: Add Indicators to the Strategy                                ###
################################################################################

####INDICATORS####---------------------------------------https://is.gd/SBHCcH---
# Add the 20-day SMA indicator
goldenX_EMA_strategy <- add.indicator(strategy=goldenX_EMA_strategy, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=20), label="020")

# Add the 50-day SMA indicator
goldenX_EMA_strategy <- add.indicator(strategy=goldenX_EMA_strategy, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=50), label="050")

# Add the 100-day SMA indicator
goldenX_EMA_strategy <- add.indicator(strategy=goldenX_EMA_strategy, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=100), label="100")

# Add the 200-day SMA indicator
goldenX_EMA_strategy <- add.indicator(strategy=goldenX_EMA_strategy, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=200), label="200")
# ------------------------------------------------------------------------------
# Add the RSI indicator
# goldenX_EMA_strategy <- add.indicator(strategy=goldenX_EMA_strategy, name="RSI", arguments =
# list(price = quote(getPrice(mktdata)), n=4), label="RSI")
################################################################################
## Step 04.04: Pass Signals to the Strategy                                  ###
################################################################################

####SIGNALS####------------------------------------------https://is.gd/SBHCcH---
# The first is when a Golden Cross occurs, i.e.,
# EMA020 > EMA050 & EMA050 > EMA100 & EMA100 > EMA200
goldenX_EMA_strategy <- add.signal(goldenX_EMA_strategy,
                name="sigFormula",
                arguments = list
                    (columns=c("EMA.020","EMA.050","EMA.100", "EMA.200"),
                  formula = "(EMA.020 > EMA.050 & EMA.050 > EMA.100 & EMA.100 > EMA.200)",
                  label="trigger",
                  cross=TRUE),
                label="goldenX_EMA_open")

# The second is when a Golden Cross criteria is no longer met
goldenX_EMA_strategy <- add.signal(goldenX_EMA_strategy,
                name="sigFormula",
                arguments = list
                  (columns=c("EMA.020","EMA.050","EMA.100", "EMA.200"),
                formula = "(EMA.020 <= EMA.050 | EMA.050 <= EMA.100 | EMA.100 <= EMA.200)",
                label="trigger",
                cross=TRUE),
                label="goldenX_EMA_close")
# ------------------------------------------------------------------------------
# stratRSI4 <- add.signal(goldenX_EMA_strategy,
#                 name="sigThreshold",
#                 arguments=list(
#                   threshold=55,
#                   column="RSI",
#                   relationship="lt",
#                   cross=TRUE),
#                 label="Cl.lt.RSI")
################################################################################
## Step 04.05: Add Rules to the Strategy                                     ###
## Whenever our long variable (sigcol) is TRUE (sigval) we want to place a   ###
## stoplimit order (ordertype). Our preference is at the High (prefer) plus  ###
## threshold. We want to buy 100 shares (orderqty). A new variable EnterLONG ###
## will be added to mktdata. When we enter (type) a position EnterLONG will  ###
## be ## TRUE, otherwise FALSE. This order will not replace any other        ###
## open orders                                                               ###
################################################################################
## rules set up to enter positions based on our signals.                     ###
####RULES####--------------------------------------------https://is.gd/SBHCcH---
# The first is to buy when the Golden Crossing criteria is met
# (the first signal)
goldenX_EMA_strategy <- add.rule(goldenX_EMA_strategy,  # Open Long Position ###
                name="ruleSignal",
                arguments=list(sigcol="goldenX_EMA_open",
                               sigval=TRUE,
                               orderqty=1000,
                               ordertype="market",
                               orderside="long",
                               pricemethod="market",
                               TxnFees=0,
                               osFUN=osMaxPos),
                               type="enter",
                               path.dep=TRUE)
####RULES####--------------------------------------------https://is.gd/SBHCcH---
# The second is to sell when the Golden Crossing criteria is breached
goldenX_EMA_strategy <- add.rule(goldenX_EMA_strategy,
                name="ruleSignal",
                arguments=list(sigcol="goldenX_EMA_close",
                               sigval=TRUE,
                               orderqty="all",
                               ordertype="market",
                               orderside="long",
                               pricemethod="market",
                               TxnFees=0),
                               type="exit",
                               path.dep=TRUE)
################################################################################
## Step 04.06: Set Position Limits                                           ###
################################################################################
addPosLimit("goldenX_EMA_portfolio", "SPL.AX", timestamp=initDate, maxpos=100, minpos=0)
################################################################################
## Step 04.07: Apply and Save Strategy                                       ###
################################################################################
cwd          <- getwd()
goldenX_EMA  <- here::here("dashboard/rds/", "goldenX_EMA_results.RData.RData")
if( file.exists(goldenX_EMA)) {
  load(goldenX_EMA)
} else {
  results   <- applyStrategy(goldenX_EMA_strategy, portfolios = "goldenX_EMA_portfolio")
  updatePortf("goldenX_EMA_portfolio")
  updateAcct("GoldenX")
  updateEndEq("GoldenX")
  if(checkBlotterUpdate("goldenX_EMA_portfolio", "GoldenX", verbose = TRUE)) {
    save(list = "results", file = here::here("dashboard/rds/", "goldenX_EMA_results.RData"))
    setwd("./dashboard/rds/")
    save.strategy("goldenX_EMA_strategy")
    setwd(cwd)
  }
}
################################################################################
## Step 04.08: Generate Performance Reports    https://tinyurl.com/us96c8p   ###
################################################################################
## Compute Trade Statistics------------------------------https://is.gd/SBHCcH---
pts <- perTradeStats("goldenX_EMA_portfolio", "SPL.AX")

dt_pts <- data.table(pts)
dt_pts[, `:=`(tradeDays, lapply(paste0(pts[, 1], "/", pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))]

dt_pts[, calendarDays := duration/86400]
dt_pts[, c("catName","indicator"):=list("GoldenX", "EMA")]
dt_pts[, grp := .GRP, by=Start] 
dt_pts[, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]


dt_pts[, `:=`(tradeDays, lapply(paste0(pts[, 1], "/", pts[, 2]), 
  function(x) length(SPL.AX[, 6][x])+1))][
, calendarDays := duration/86400][
, c("catName","indicator"):=list("GoldenX", "EMA")][
, grp := .GRP, by=Start][ 
, subcatName := paste0(catName, paste0(sprintf("%03d", grp)))]

# unlist a column in a data.table                           https://is.gd/ZuntI3
dt_pts[rep(dt_pts[,.I], lengths(tradeDays))][, tradeDays := unlist(dt_pts$tradeDays)][]

tstats <- tradeStats("goldenX_EMA_portfolio", "SPL.AX")
# trade related 
tab.trades <- cbind(
          c(
            "Trades",
            "Win Percent",
            "Loss Percent",
            "W/L Ratio"), 
          c(tstats[,"Num.Trades"],
            tstats[,c("Percent.Positive","Percent.Negative")], 
            tstats[,"Percent.Positive"]/
            tstats[,"Percent.Negative"]))
# profit related 
tab.profit <- cbind(
          c("Net Profit",
            "Gross Profits",
            "Gross Losses",
            "Profit Factor"),
          c(tstats[,c("Net.Trading.PL",
                      "Gross.Profits",
                      "Gross.Losses", 
                      "Profit.Factor")]))
# averages 
tab.wins <- cbind(
          c("Avg Trade",
            "Avg Win",
            "Avg Loss",
            "Avg W/L Ratio"),
          c(tstats[,c("Avg.Trade.PL",
                      "Avg.Win.Trade",
                      "Avg.Losing.Trade", 
                      "Avg.WinLoss.Ratio")]))
trade.stats.tab <- data.table(tab.trades,tab.profit,tab.wins)
################################################################################
## Step 04.09: Generate Performance Analytics  https://tinyurl.com/us96c8p   ###
################################################################################
rets       <- PortfReturns(Account=goldenX_EMA_strategy)
rownames(rets) <- NULL
# Compute performance statistics -----------------------------------------------
tab.perf <- table.Arbitrary(rets, 
  metrics=c("Return.cumulative", 
            "Return.annualized",
            "SharpeRatio.annualized",
            "CalmarRatio"),
  metricsNames=c(
            "Cumulative Return",
            "Annualized Return",
            "Annualized Sharpe Ratio",
            "Calmar Ratio"))
# Compute risk statistics ------------------------------------------------------
tab.risk <- table.Arbitrary(rets,
  metrics=c("StdDev.annualized",
            "maxDrawdown",
            "VaR",
            "ES"),
  metricsNames=c(
            "Annualized StdDev",
            "Max DrawDown",
            "Value-at-Risk",
            "Conditional VaR"))
performance.stats.tab <- data.table(
  rownames(tab.perf),tab.perf[,1],
  rownames(tab.risk),tab.risk[,1])
################################################################################
## Step 04.99: VERSION HISTORY                                               ###
################################################################################
a04.version = "1.0.0"
a04.ModDate = as.Date("2019-12-01")
################################################################################
# 2019.12.01 - v.1.0.0
#  1st release
################################################################################
