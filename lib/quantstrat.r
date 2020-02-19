
setup <- function(trendName) {
################################################################################
# 1.0 Setup
################################################################################
strategy.st <<- portfolio.st <<- account.st <<- dXema
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
}

report <- function(trendName) {
################################################################################
# 9.0	Trend - create dynamic name dashboard dataset
################################################################################
# g[[paste0("my", "Var", 1)]] <- "value"        https://tinyurl.com/r3yrspv  ###
# ------------------------------------------------------------------------------
x <- g[[paste(trendName, "pts", sep = "_")]] <-
    blotter::perTradeStats(portfolio.st, symbols)
y <- g[[paste(trendName, "trend", sep = "_")]] <- data.table(x)
}
