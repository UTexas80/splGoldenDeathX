################################################################################
# 1.0 Setup
################################################################################
strategy.st <- portfolio.st <- account.st <- gxSMA
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
mktdata_ind_gxSMA <-  applyIndicators(               # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
# mktdata_ind_gxSMA[is.na(
#    mktdata_ind_gxSMA)]     = 0
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
         columns            = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
         formula            = "(SMA.020 > SMA.050 & 
                                SMA.050 > SMA.100 & 
                                SMA.100 > SMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "goldenX_SMA_open")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
         (columns           = c("SMA.020","SMA.050","SMA.100", "SMA.200"),
         formula            = "(SMA.020 <= SMA.050 & 
                                SMA.050 <= SMA.100 & 
                                SMA.100 <= SMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "goldenX_SMA_close")
# ------------------------------------------------------------------------------
# applySignals(strategy.st, mktdata)
# applySignals(strategy.st, mktdata_ind_gxSMA)
# applySignals(
#    strategy                = strategy.st,
#    mktdata                 = SPL.AX)
mktdata_sig_gxSMA <- applySignals(
    strategy                = strategy.st,
    mktdata                 = mktdata_ind_gxSMA)
# mktdata_sig_gxSMA[is.na(
#    mktdata_sig_gxSMA)]     = 0
################################################################################
# 5.0	Rules
################################################################################
 add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "goldenX_SMA_open",
        sigval              = TRUE,
        orderqty            = 1000,
        ordertype           = "market",
        orderside           = "long",
        pricemethod         = "market",
        TxnFees             = 0,
        osFUN               = osMaxPos),
        type                = "enter",
        path.dep            = TRUE)
# ------------------------------------------------------------------------------
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "goldenX_SMA_close",
        sigval              = TRUE,
        orderqty            = "all",
        ordertype           = "market",
        orderside           = "long",
        pricemethod         = "market",
        TxnFees             = 0),
        type                = "exit",
        path.dep            = TRUE)
################################################################################
# 6.0	Position Limits
################################################################################
browser()
addPosLimit(portfolio.st, symbols, 
    timestamp               <- initDate, 
    maxpos                  <- 100,
    minpos                  <- 0)
################################################################################
# 7.0	Strategy
################################################################################
strategy_gxSMA <- applyStrategy(
    strategy                = strategy.st,
    portfolios              = portfolio.st)
updatePortf(portfolio.st)
updateAcct(account.st)
updateEndEq(account.st)

# if(checkBlotterUpdate(portfolio.st, account.st, verbose = TRUE))  {
    save(
        list                = "strategy_gxSMA", 
        file                = here::here("dashboard/rds/", paste( gxSMA, ".", "RData"))    
    )
    strategy_gxSMA_save <- save.strategy(strategy.st)
#  }
# 	7.2	updatePortf
# 	7.3	updateAcct
#   7.4	updateEndEq
# 	7.5	checkBlotterUpdate
# 	7.6	save.strategy
################################################################################
# 8.0	Evaluation	
################################################################################
