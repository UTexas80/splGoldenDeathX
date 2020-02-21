
setup <- function(trendName) {
################################################################################
# 1.0 Setup
################################################################################
strategy.st <<- portfolio.st <<- account.st <<- trendName
rm.strat(strategy.st)
rm.strat(account.st)
rm.strat(portfolio.st)
################################################################################
# 2.0	Initialization
################################################################################
initPortf(name              = portfolio.st,         # Portfolio Initialization
          symbols           = symbols,
          currency          = curr,
          initDate          = initDate,
          initEq            = initEq)
# ------------------------------------------------------------------------------
initAcct(name               = account.st,           # Account Initialization
         portfolios         = portfolio.st,
         currency           = curr,
         initDate           = initDate,
         initEq             = initEq)
# ------------------------------------------------------------------------------
initOrders(portfolio        = portfolio.st,         # Order Initialization
           symbols          = symbols,
           initDate         = initDate)
# ------------------------------------------------------------------------------
strategy(strategy.st, store = TRUE)                 # Strategy initialization
}
################################################################################
# 3.0	Indicators
################################################################################
indicators <- function(name, x, n, label) {
      add.indicator(strategy.st,
        name                 = name,
        arguments            = list(
        x                    = quote(mktdata[,4]),
        n                    = n),
        label                = label)
}
################################################################################
# 4.0	Signals
################################################################################
signals <- function(trendName) {
    signal <- g[[paste(trendName, "signal", sep = "_")]] <-
             applySignals(
             strategy           = strategy.st,
             mktdata            = nXema_mktdata_ind)
}
################################################################################
# 6.0	Position Limits
################################################################################
positionLimits <- function(maxpos, minpos) {
    addPosLimit(portfolio.st, symbols,
        timestamp   <- from,
        maxpos      <- maxpos,
        minpos      <- minpos)
}
################################################################################
# 7.0	Strategy
################################################################################
Strategy <- function(trendName) {
    t1      <- Sys.time()
    strat   <- g[[paste(trendName, "_strategy", sep = "_")]] <-
        applyStrategy(strategy.st, portfolio.st, mktdata, symbols)
    t2      <- Sys.time()
    print(t2 - t1)
}
################################################################################
# 8.0	Evaluation - update P&L and generate transactional history
################################################################################
evaluation <- function() {
    updatePortf(portfolio.st)
    dateRange  <- time(getPortfolio(portfolio.st)$summary)[-1]
    updateAcct(account.st, dateRange)
# ------------------------------------------------------------------------------
    updateEndEq(account.st)
    save.strategy(strategy.st)
}
################################################################################
# 9.0 Trend - create dynamic name dashboard dataset  https://tinyurl.com/r3yrspv
################################################################################
report <- function(trendName) {
    x <- g[[paste(trendName, "pts", sep = "_")]] <-
        blotter::perTradeStats(portfolio.st, symbols)
    t <- g[[paste(trendName, "trend", sep = "_")]] <- data.table(x)
    t[, calendarDays := as.numeric(duration/86400)]
    t[, `:=`(tradeDays, lapply(paste0(x[, 1], "/", x[, 2]),
            function(x) length(SPL.AX[, 6][x])+1))]
    t[, c("catName","indicator"):=list("DeathX", EMA)]
    t[, grp := .GRP, by=Start]
    t[, subcatName := paste0(catName, 
                paste0(sprintf("%03d", grp),
                paste0(indicator)))]
# ------------------------------------------------------------------------------
# unlist a column in a data.table                           https://is.gd/ZuntI3
# ------------------------------------------------------------------------------
    t[rep(t[,.I], lengths(tradeDays))][
      , tradeDays := unlist(t$tradeDays)][]
    t$tradeDays <- unlist(t$tradeDays)
# ------------------------------------------------------------------------------
# add Start / End open price                                                 ***
# ------------------------------------------------------------------------------
    m <-  data.table(mktdata, keep.rownames = T)
    m$index <- as.POSIXct(m$index, tz = "NewYork")
    setkey(m, "index")
# ------------------------------------------------------------------------------    
    t <- setkey(t, "Start")
    t <- na.omit(t[m][, c(1:26)])
#   t <- na.omit(t[SPL][, -c(27:31)])
    t <- setkey(t, "End")
    t <- na.omit(t[m][, c(1:27)])    
#   t <- na.omit(t[SPL][, -c(28:32)])
    g[[paste(trendName, "trend", sep = "_")]] <- data.table(t)
# ------------------------------------------------------------------------------
    s <- g[[paste(trendName, "stats", sep = "_")]] <-
         blotter::tradeStats(Portfolios = portfolio.st, 
                             use="trades", 
                             inclZeroDays=FALSE)
# ------------------------------------------------------------------------------
    p <- g[[paste(trendName, "profit", sep = "_")]] <- data.table(s)  %>%
    select(Net.Trading.PL, Gross.Profits, Gross.Losses, Profit.Factor)
    t(p)
# ------------------------------------------------------------------------------
    w <- g[[paste(trendName, "wins", sep = "_")]] <- data.table(s)  %>%
    select(Avg.Trade.PL, Avg.Win.Trade, Avg.Losing.Trade, Avg.WinLoss.Ratio)
    t(w)
# ------------------------------------------------------------------------------
    r <- g[[paste(trendName, "returns", sep = "_")]] <-  
        PortfReturns(Account =  account.st)
    rownames(r) <- NULL
# ------------------------------------------------------------------------------
    perf <- g[[paste(trendName, "perf", sep = "_")]] <- 
            table.Arbitrary(r, metrics = c(
                               "Return.cumulative",
                               "Return.annualized",
                               "SharpeRatio.annualized",
                               "CalmarRatio"),
                             metricsNames = c(
                               "Cumulative Return",
                               "Annualized Return",
                               "Annualized Sharpe Ratio",
                               "Calmar Ratio"))
################################################################################
# 10.0	# Performance and Risk Metrics 
################################################################################
    s<- data.table(s[, 4:ncol(s)] <- round(s[, 4:ncol(s)], 2), keep.rownames = T)
    g[[paste(trendName, "stats", sep = "_")]] <- s[, t(.SD)]
# ------------------------------------------------------------------------------
# Risk Statistics
# ------------------------------------------------------------------------------ 
    risk <- g[[paste(trendName, "risk", sep = "_")]] <-
            table.Arbitrary(r, metrics = c(
                               "StdDev.annualized",
                               "maxDrawdown"),
                             metricsNames = c(
                               "Annualized StdDev",
                               "Max DrawDown"))

}
