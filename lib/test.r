
# m <- mapply(function(x) {g[y[x,]][,c(9,11:13)]}, as.integer(rownames(y)), SIMPLIFY = FALSE)
# x <- unique(do.call(rbind, m))
# class(x) <- "ind"
# get_Strategy(x)
#  sapply(dT.trend[,3], function(x) x)

# ------------------------------------------------------------------------------
# function accept a dataframe as an argument?     https://tinyurl.com/vajvn48
# ------------------------------------------------------------------------------
# this is like an abstract base method
get_Strategy <- function(trendName, trendInd) {
  UseMethod("get_Strategy")
}

# this is the implementation for "trend" objects,
# you could have more for other "class" objects
get_Strategy.setup <- function(trendName, trendInd) {
  print("Setup Strategy")

  setupTrend <<- setDT(trendName)
  setupInd   <<- setDT(trendInd)

  print("SetDT data.tables")
# ------------------------------------------------------------------------------
  for (i in 1:length(setupTrend)) {
    print(i)
    apply(setupTrend[i,5], 1, function(x) setup(x))
# ------------------------------------------------------------------------------
    for (j in 1:nrow(setupInd[strategy_ind_id == i])) {
      print(j)
      apply(setupInd[strategy_ind_id == j, c(4:7)], 1, 
        function(x) testInd(setupInd))
#       indicators(x[1], as.integer(x[2]), as.integer(x[3]), x[4]))
      str(getStrategy(setupTrend[i,5])$indicators)
    }
# ------------------------------------------------------------------------------
    apply(setupTrend[i,5], 1, 
      function(x) ApplyIndicators(x))
  }
}

# this is the implementation for "indicator" objects,
# you could have more for other "class" objects
get_Strategy.ind <<- function(i, trendInd){
  print("setup Indicators")
}

# ------------------------------------------------------------------------------
# testInd <- function(name, x, n, label) {
#       add.indicator(strategy.st,
#         name                 = name,
#         arguments            = list(
#         x                    = quote(mktdata[,4]),
#         n                    = n),
#         label                = label)

#         print(name, x, n, label)
# }
# ------------------------------------------------------------------------------
testInd <- function(trendInd) {
     add.indicator(strategy.st,
       name                 = trendInd[,4],
       arguments            = list(
       x                    = quote(mktdata[,4]),
       n                    = trendInd[,6]),
       label                = paste0(trendInd[,4],trendInd[,7]))

       # print(name, x, n, label)
}

xtest <- function(name, indicator, symbols = symbols, initDate = initDate, initEq  = initEq) {

# 1.0 Setup
# ------------------------------------------------------------------------------
#   1.10 – assign names
    strategy.st <- portfolio.st <- account.st <- name
# ------------------------------------------------------------------------------
#   1.2 – remove prior strategy
    rm.strat(strategy.st)
    rm.strat(account.st)
    rm.strat(portfolio.st)
# ------------------------------------------------------------------------------
# 2.0 Initialization
# ------------------------------------------------------------------------------
#   2.1  initialize portfolio, account, orders and  strategy--------------------
# ------------------------------------------------------------------------------
    initPortf(name       = portfolio.st,            # Portfolio Initialization
        symbols    = symbols,
        currency   = 'AUD',
        initDate   = initDate,
        initEq     = initEq)
# ------------------------------------------------------------------------------
    initAcct(name        = account.st,              # Account Initialization
        portfolios   = portfolio.st,
        currency     = 'AUD',
        initDate     = initDate,
        initEq       = initEq)
# ------------------------------------------------------------------------------
    initOrders(portfolio = portfolio.st,            # Order Initialization
        symbols   = symbols,
        initDate  = initDate)
# ------------------------------------------------------------------------------
    strategy(strategy.st, store=TRUE)               # Strategy  Initialization
# ------------------------------------------------------------------------------
# 3.0 Indicators
#   3.1 20-day SMA indicator
##------------------------------------------------------------------------------
    add.indicator(strategy.st,
              name      = "EMA",
              arguments = list(
                x       = quote(mktdata[,4]),
                n       = 20),
              label     = "020")
##------------------------------------------------------------------------------
##  3.2 Add the 50-day SMA indicator
##------------------------------------------------------------------------------
    add.indicator(strategy.st,
              name      = "EMA",
              arguments = list(
                x       = quote(mktdata[,4]),
                n       = 50),
              label     = "050")
##------------------------------------------------------------------------------
##  3.3 Add the 100-day SMA indicator
##------------------------------------------------------------------------------
    add.indicator(strategy.st,
              name      = "EMA",
              arguments = list(
                x       = quote(mktdata[,4]),
                n       = 100),
              label     = "100")
##------------------------------------------------------------------------------
##  3.4 Add the 200-day SMA indicator
##------------------------------------------------------------------------------
    add.indicator(strategy.st,
              name      = "EMA",
              arguments = list(
                x       = quote(mktdata[,4]),
                n       = 200),
              label     = "200")
################################################################################
##  3.5 apply indicators
################################################################################
    paste(mktdata_ind, sep = "_", indicator ) <- applyIndicators(strategy = strategy.st,mktdata = symbols)
    mktdata_ind[is.na(mktdata_ind)] = 0
}


# this is like an abstract base method
getStockPlot <- function(stocks_df) {
  UseMethod("getStockPlot")
}

# this is the implementation for "stock" objects,
# you could have more for other "class" objects
getStockPlot.stock <- function(stocks_df){
  print("Plot Stocks")
}

# How to run multiple functions one after another?
`%@%` <- function(x, f) eval.parent(as.call(append(as.list(substitute(f)), list(x), 1))) # https://tinyurl.com/qo443mb
# f(trend_ind); f(dT.metrics); f(dT.rules) # https://tinyurl.com/rkmef5n



