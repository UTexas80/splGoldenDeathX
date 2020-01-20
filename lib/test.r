test <- function(name, indicator, symbols = symbols, initDate = initDate, initEq  = initEq) {
  
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