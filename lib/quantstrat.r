################################################################################
# 1.0 Setup
################################################################################
x0100_setup <- function(trendName) {
# ------------------------------------------------------------------------------
#   browser()
# ------------------------------------------------------------------------------
# Stock Symbol Initialization                               https://is.gd/RShki5
# ------------------------------------------------------------------------------
# symbols <- basic_symbols()
# ------------------------------------------------------------------------------
# options(getSymbols.warning4.0 = FALSE)               # Suppresses warnings ###
# getSymbols(Symbols = symbols,
#           src = "yahoo",
#           index.class = "POSIXct",
#           from = start_date,
#           to = end_date,
#           adjust = adjustment)
# ------------------------------------------------------------------------------
# FinancialInstrument::stock(symbols,
#      currency = "USD",
#      multiplier = 1)
# ------------------------------------------------------------------------------
  strategy.st <<- portfolio.st <<- account.st <<- trendName
# ------------------------------------------------------------------------------
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
# ------------------------------------------------------------------------------
#    browser()
# ------------------------------------------------------------------------------
      add.indicator(strategy.st,
        name                 = name,
        arguments            = list(
        x                    = quote(mktdata[,4]),
        n                    = n),
        label                = label)
}
ApplyIndicators <- function(trendName) {
    Apply_Indicators <<- g[[paste(trendName, "mktdata", "ind", sep = "_")]] <<-
        applyIndicators(              # apply indicators
            strategy                = strategy.st,
            mktdata                 = SPL.AX)
# ------------------------------------------------------------------------------
    paste0("str(", getStrategy(trendName),"$indicators)")
# ------------------------------------------------------------------------------
}
################################################################################
# 4.0	Signals
################################################################################
# ------------------------------------------------------------------------------
#    browser()
# ------------------------------------------------------------------------------
    AddSignals <- function(name, columns, formula, label, cross, trendName, Label) {
        add.signal(strategy.st,
            name                    = name,
            arguments               = list(
                columns             = columns,
                formula             = formula,
                label               = label,
                cross               = cross),
            label                   = paste(trendName, Label, sep = "_"))
# ------------------------------------------------------------------------------
    }
# ------------------------------------------------------------------------------
    ApplySignals <- function(trendName) {

# ------------------------------------------------------------------------------
    }
################################################################################
# 5.0	Rules                                       https://tinyurl.com/y93kc22r
################################################################################
# red.plot <- function(x, y, ...)  {
# rules <- function(sigcol, sigval, orderqty, orderside, ordertype, prefer, pricemethod, TxnFees, type)
# , ...) {
rules <- function(sigcol, sigval, orderqty, orderside, ordertype, prefer, pricemethod, TxnFees, type, ...) {
# ------------------------------------------------------------------------------
   browser()
# ------------------------------------------------------------------------------    
    add.rule(strategy.st,
        name                    = "ruleSignal",
        arguments               = list(
            sigcol              = sigcol,
            sigval              = sigval,
            orderqty            = orderqty,
            orderside           = orderside,
            ordertype           = ordertype,
            prefer              = prefer,
            pricemethod         = pricemethod,
            TxnFees             = TxnFees),
     #      osFUN               = dummy()),
        type                    = type,
        path.dep                = TRUE)
 }
################################################################################
# 6.0	Position Limits
################################################################################
positionLimits <- function(maxpos, minpos) {
# ------------------------------------------------------------------------------
#    browser()
# ------------------------------------------------------------------------------    
    addPosLimit(portfolio.st, symbols,
        timestamp   <- from,
        maxpos      <- maxpos,
        minpos      <- minpos)
}
################################################################################
# 7.0	Strategy
################################################################################
Strategy <- function(strategy.st) {
# ------------------------------------------------------------------------------
    browser()
# ------------------------------------------------------------------------------
    print(paste("strategy.st before apply strategy ", strategy.st))
    print(strategy.st)
    print(class(strategy.st))
# ------------------------------------------------------------------------------
    t1      <- Sys.time()
    strat   <- g[[paste(strategy.st, "strategy", sep = "_")]] <-
        applyStrategy(strategy.st, portfolio.st,  mktdata , symbols)
    t2      <- Sys.time()
    print(t2 - t1)
# ------------------------------------------------------------------------------
    print(paste("strategy.st after apply strategy ", strategy.st))
    print(strategy.st)
    print(class(strategy.st))
# ------------------------------------------------------------------------------
}
################################################################################
# 8.0	Evaluation - update P&L and generate transactional history
################################################################################
evaluation <- function(trendName) {
# ------------------------------------------------------------------------------
    browser()
# ------------------------------------------------------------------------------
    updatePortf(portfolio.st, symbols)
#   dateRange  <- tail(time(getPortfolio(trendName)$summary)[-1], 0)
    dateRange  <- time(getPortfolio(portfolio.st)$summary)[-1]
# ------------------------------------------------------------------------------
    updateAcct(account.st, dateRange)
    updateEndEq(account.st, dateRange)
# ------------------------------------------------------------------------------
#    save.strategy(trendName)
    save.strategy(strategy.st)
}
################################################################################
# 9.0 Trend - create dynamic name dashboard dataset  https://tinyurl.com/r3yrspv
################################################################################
report <- function(trendName) {
#   browser()
    x  <- g[[paste(trendName, "pts", sep = "_")]] <-
        blotter::perTradeStats(portfolio.st, symbols)
# ------------------------------------------------------------------------------
    s <- g[[paste(trendName, "trade", "stats", sep = "_")]] <-
#        blotter::tradeStats(Portfolios = portfolio.st,
         tradeStats(Portfolios = portfolio.st,
                           use = "trades",
                  inclZeroDays = FALSE)
# ------------------------------------------------------------------------------
    t  <- g[[paste(trendName, "trend", sep = "_")]] <- data.table(x)
    t[, `:=`(tradeDays, lapply(paste0(x[, 1], "/", x[, 2]),
                               function(x) length(SPL.AX[, 6][x])+1))]
    t[, calendarDays := as.numeric(duration/86400)]
#   t[, c("catName","indicator"):=list("DeathX", "EMA")]
#    t[, catName      := dT.strategy[3,3]]
    t[, catName      := dt_strategy[strategy_name==trendName,3]]
    t[, indicator    := toupper(right(trendName,3))]
    t[, grp          := .GRP, by = Start]
    t[, subcatName   := paste0(catName,
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
    # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    m$index <- as.POSIXct(m$index, tz = "Australia/Sydney")
    setkey(m, "index")
# ------------------------------------------------------------------------------
    t <- setkey(t, "Start")
#   t <- na.omit(t[m][, c(1:26)])
    t <- na.omit(t[SPL, nomatch = 0][, -c(26,28:32)])
    t <- setkey(t, "End")
#   t <- na.omit(t[m][, c(1:27)])
    t <- na.omit(t[SPL, nomatch = 0][, -c(27,29:33)])
    g[[paste(trendName, "trend", sep = "_")]] <- data.table(t)
# ------------------------------------------------------------------------------
# [1] "Start"               "End"                 "Init.Qty"            "Init.Pos"            "Max.Pos"             "End.Pos
# [7] "Closing.Txn.Qty"     "Num.Txns"            "Max.Notional.Cost"   "Net.Trading.PL"      "MAE"                 "MFE"
# [13] "Pct.Net.Trading.PL"  "Pct.MAE"             "Pct.MFE"             "tick.Net.Trading.PL" "tick.MAE"            "tick.MFE"
# [19] "duration"            "tradeDays"           "calendarDays"        "catName"             "indicator"           "grp"
# [25] "subcatName"          "symbol"              "adjusted"            "volume"              "i.adjusted"
# ------------------------------------------------------------------------------
    p <- g[[paste(trendName, "profit", sep = "_")]] <- data.table(s)  %>%
    select(Net.Trading.PL, Gross.Profits, Gross.Losses, Profit.Factor)
    t(p)
# ------------------------------------------------------------------------------
    w <- g[[paste(trendName, "wins", sep = "_")]] <- data.table(s)  %>%
    select(Avg.Trade.PL, Avg.Win.Trade, Avg.Losing.Trade, Avg.WinLoss.Ratio)
    t(w)
# ------------------------------------------------------------------------------
    r <- g[[paste(trendName, "rets", sep = "_")]] <-
        PortfReturns(Account =  account.st)
    rownames(r) <- NULL
    # names(r)[1] <- strategy.st
    # g[[paste(trendName, "rets", sep = "_")]] <- data.table(r)
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
