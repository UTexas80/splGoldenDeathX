################################################################################
# Introduction to R packages for Algorithmic trading    https://is.gd/KXB2qi ###
################################################################################

################################################################################
## 1.0 – Adding Indicators and Signals to a trading strategy                 ###
################################################################################

################################################################################
## 1.01 Import Data
################################################################################
getSymbols(Symbols = symbols, 
           src     = "yahoo", 
           from    = start_date, 
           to      = end_date, 
           adjust  = adjustment)
# ------------Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###
SPL.AX <-
        SPL.AX %>%
        na.omit()
## -----------------------------------------------------------------------------
## -- use FinancialInstrument::stock() to define the meta-data for the symbols.-
stock(symbols ,currency = "AUD",multiplier = 1)
################################################################################
##  1.02 Algorithmic Trading Strategy Setup
## -----------------------------------------------------------------------------
## Assign names to the portfolio, account and strategy as follows:
## -----------------------------------------------------------------------------
################################################################################
strategy.st  <- "buyhold_strat"
portfolio.st <- "buyhold_portfolio"
account.st   <- "buyhold_account"
# ------------------------------------------------------------------------------
################################################################################
# If there are any other portfolios or account book with these names
# remove them using rm.strat function
# ------------------------------------------------------------------------------
rm.strat(strategy.st)
rm.strat(portfolio.st)
rm.strat(account.st)
# ------------------------------------------------------------------------------
# To start, we initialize account and portfolio where:                       ###
# Porfolio: stores which stocks to be traded                                 ###
# Account: stores money transactions                                         ###
# ------------------------------------------------------------------------------
initPortf(name       = portfolio.st,            # Portfolio Initialization   ###
          symbols    = symbols,
          initDate   = init_date)
# ------------------------------------------------------------------------------
initAcct(name        = account.st,              # Account Initialization     ###
        portfolios   = portfolio.st,
        initDate     = init_date,
        initEq       = init_equity)
# ------------------------------------------------------------------------------
initOrders(portfolio = portfolio.st,            # Order Initialization       ###
           symbols   = symbols,
           initDate  = init_date)
# ------------------------------------------------------------------------------
strategy(strategy.st, store = TRUE)             # Strategy Initialization    ###
addPosLimit(portfolio.st, "SPL.AX", timestamp=initDate, maxpos=100, minpos=0)
# stock(symbols ,currency = "AUD",multiplier = 1)
################################################################################
## Step 04.9.02: place an entry order                                        ###
################################################################################
equity               <- getEndEq(account.st, start_date)
TxnDate              <- start_date
TxnPrice             <- as.numeric(Cl(SPL.AX[1,4]))
TxnQty               <- as.numeric(trunc(equity/TxnPrice))
# ------------------------------------------------------------------------------
addTxn(portfolio.st,
      Symbol         <- symbols,
      TxnDate        <- TxnDate,
      TxnPrice       <- TxnPrice,
      TxnQty         <- TxnQty,,
      TxnFees        <- TxnFees)
################################################################################
## Step 04.9.03: place an exit order                                         ###
################################################################################
TxnDate              <- last(time(SPL.AX))
TxnPrice             <- as.numeric(Cl(SPL.AX[LastDate,]))
# ------------------------------------------------------------------------------
addTxn(portfolio.st, 
       Symbol        <- Symbol,
       TxnDate       <- TxnDate,
       TxnPrice      <- TxnPrice,
       TxnQty        <- - TxnQty,
       TxnFees       <- TxnFees)
################################################################################
## Step 04.9.04: update portfolio and account                                ###
################################################################################
addPosLimit(portfolio.st, 
            Symbol, 
            timestamp    <- start_Date,
            maxpos       <- 100,
            minpos       <- 0)
applyStrategy(strategy = strategy.st,portfolios = portfolio.st)
# ------------------------------------------------------------------------------
updatePortf(portfolio.st)
updateAcct(account.st)
updateEndEq(account.st)
################################################################################
## 04.05 Chart Trades
################################################################################
chart.Posn(portfolio.st,"SPL.AX")
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-12-09")
# ------------------------------------------------------------------------------
# 2019.12.09 - v.1.0.0
# 1st release
