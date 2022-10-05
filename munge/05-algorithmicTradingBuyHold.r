################################################################################
# Introduction to R packages for Algorithmic trading    https://is.gd/KXB2qi ###
################################################################################
################################################################################
## 1.0 – Adding Indicators and Signals to a trading strategy                 ###
################################################################################

################################################################################
## Step 1.01 Import Data                                                     ###
################################################################################
# getSymbols(Symbols = symbols,
#            src     = "yahoo",
#            from    = start_date,
#            to      = end_date,
#            adjust  = adjustment)
# ------------Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###
# SPL.AX <-
#         SPL.AX %>%
#         na.omit()
# ## -----------------------------------------------------------------------------
## -- use FinancialInstrument::stock() to define the meta-data for the symbols.-
# stock(symbols ,currency = "AUD",multiplier = 1)
################################################################################
##  1.02 Algorithmic Trading Strategy Setup
## -----------------------------------------------------------------------------
## Assign names to the portfolio, account and strategy as follows:
## -----------------------------------------------------------------------------
strategy.st  <- "buyhold_strat"
portfolio.st <- "buyhold_portfolio"
account.st   <- "buyhold_account"
# ------------------------------------------------------------------------------
# If there are any other portfolios or account book with these names
# remove them using rm.strat function
# ------------------------------------------------------------------------------
rm.strat(strategy.st)
rm.strat(account.st)
rm.strat(portfolio.st)
# ------------------------------------------------------------------------------
# To start, we initialize account and portfolio where:                       ###
# Porfolio: stores which stocks to be traded                                 ###
# Account: stores money transactions                                         ###
# ------------------------------------------------------------------------------
initPortf(name       = portfolio.st,            # Portfolio Initialization   ###
          symbols    = symbols,
          currency   = 'AUD',
          initDate   = initDate,
          initEq     = initEq)
# ------------------------------------------------------------------------------
initAcct(name        = account.st,              # Account Initialization     ###
        portfolios   = portfolio.st,
        currency     = 'AUD',
        initDate     = initDate,
        initEq       = initEq)
# ------------------------------------------------------------------------------
initOrders(portfolio = portfolio.st,            # Order Initialization       ###
           symbols   = symbols,
           initDate  = initDate)
# ------------------------------------------------------------------------------
strategy(strategy.st, store = TRUE)             # Strategy Initialization    ###
# stock(symbols ,currency = "AUD",multiplier = 1)
################################################################################
## Step 01.03a: place an entry order                                         ###
################################################################################
TxnDate              <- first(time(SPL.AX))
TxnPrice             <- as.numeric(Cl(SPL.AX[1,4]))
equity               <- getEndEq(account.st, TxnDate) 
TxnQty               <- as.numeric(trunc(equity/TxnPrice))
# ------------------------------------------------------------------------------
addTxn(portfolio.st,                            # buy transaction            ###
      Symbol         <- symbols,
      TxnDate        <- TxnDate,
      TxnPrice       <- TxnPrice,
      TxnQty         <- TxnQty,
      TxnFees        <- TxnFees)
################################################################################
## Step 01.03b place an exit order                                           ###
################################################################################
TxnDate              <- last(time(SPL.AX))
TxnPrice             <- as.numeric(Cl(SPL.AX[TxnDate,]))[[1]]
# ------------------------------------------------------------------------------
addTxn(portfolio.st,                             # sell transaction          ### 
       Symbol        <- Symbol,
       TxnDate       <- TxnDate,
       TxnPrice      <- TxnPrice,
       TxnQty        <- -TxnQty,
       TxnFees       <- TxnFees)
################################################################################
## Step 01.08: set the position limits                                       ###
################################################################################
addPosLimit(portfolio.st, 
            Symbol, 
            timestamp    <- start_date,
            maxpos       <- 100,
            minpos       <- 0)
################################################################################
## Step 01.09:  apply and save strategy                                      ###
################################################################################
applyStrategy(strategy = strategy.st,portfolios = portfolio.st)
save.strategy( strategy.st)
################################################################################
## Step 01.10: update portfolio and account                                  ###
################################################################################
updatePortf(portfolio.st)
updateAcct(account.st)
updateEndEq(account.st)
addPosLimit(portfolio.st, "SPL.AX", timestamp=start_date, maxpos=100, minpos=0)
################################################################################
## Step 01.11: Chart Trades                                                  ###
################################################################################
chart.Posn(portfolio.st,"SPL.AX")
# ------------------------------------------------------------------------------
blotter::dailyEqPL(portfolio.st, "SPL.AX")
blotter::dailyStats(portfolio.st)
blotter::getPortfolio(portfolio.st)
# le <- as.data.frame(mktdata["2008-02-25::2008-03-07", c(1:4, 7:10)])
################################################################################
## Step 04.12: sSave portfolio strategy to .rds                              ###
################################################################################
saveRDS(portfolio.st,
  file = here::here("SPL-Dashboard/rds/",
  paste0(portfolio.st, ".", "rds")))
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-12-09")
# ------------------------------------------------------------------------------
# 2019.12.09 - v.1.0.0
# 1st release
