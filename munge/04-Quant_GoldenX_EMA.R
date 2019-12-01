################################################################################
# How Do I in R?                                https://tinyurl.com/y9j67lfk ###
################################################################################
## Step 00.00 Processing Start Time - start the timer                        ###
################################################################################
start.time = Sys.time()
################################################################################
## Step 00.01 get stock symbols                 https://tinyurl.com/y3adrqwa ###
## Check existence of directory and create if doesn't exist                  ###
################################################################################
symbols      <- basic_symbols()
getSymbols(Symbols = symbols,
           src = "yahoo",
           index.class = "POSIXct",
           from = start_date,
           to = end_date,
           adjust = adjustment)
# ------------Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###
SPL.AX <-
  SPL.AX %>%
  na.omit()
## -- use FinancialInstrument::stock() to define the meta-data for the symbols.-
stock(symbols,
      currency = "USD",
      multiplier = 1)
################################################################################
## Step 00.02: Portfolio, Account, Strategy Setup                            ###
################################################################################
# Delete portfolio, account, and order book if they already exist------------###
suppressWarnings(rm("account.GoldenX","portfolio.GoldenX",pos=.blotter))
suppressWarnings(rm("order_book.GoldenX",pos=.strategy))
## -- remove residuals from previous runs. ----------------------------------###
rm.strat("GoldenX")
rm.strat("GoldenX")
# ------------------------------------------------------------------------------
## portfolio, account and orders initialization. ----------------------------###
initPortf(name = "GoldenX",                    # Portfolio Initialization    ###
          symbols = symbols,
          initDate = init_date)
# ------------------------------------------------------------------------------
initAcct(name = "GoldenX",                     # Account Initialization      ###
         portfolios="GoldenX",
         initDate=init_date,
         initEq=init_equity)
# ------------------------------------------------------------------------------
initOrders(portfolio="GoldenX",                # Order Initialization        ###
           symbols = symbols,
           initDate=init_date)
# ------------------------------------------------------------------------------
stratGoldenX <- strategy("GoldenX")            # Strategy Initialization     ###
################################################################################
## Step 00.03: Add Indicators to the Strategy                                ###
################################################################################

####INDICATORS####---------------------------------------https://is.gd/SBHCcH---
# Add the 20-day SMA indicator
stratGoldenX <- add.indicator(strategy=stratGoldenX, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=20), label="020")

# Add the 50-day SMA indicator
stratGoldenX <- add.indicator(strategy=stratGoldenX, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=50), label="050")

# Add the 100-day SMA indicator
stratGoldenX <- add.indicator(strategy=stratGoldenX, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=100), label="100")

# Add the 200-day SMA indicator
stratGoldenX <- add.indicator(strategy=stratGoldenX, name="EMA", arguments =
list(x=quote(mktdata[,4]), n=200), label="200")
# ------------------------------------------------------------------------------
# Add the RSI indicator
# stratGoldenX <- add.indicator(strategy=stratGoldenX, name="RSI", arguments =
# list(price = quote(getPrice(mktdata)), n=4), label="RSI")
################################################################################
## Step 00.04: Pass Signals to the Strategy                                  ###
################################################################################

####SIGNALS####------------------------------------------https://is.gd/SBHCcH---
# The first is when a Golden Cross occurs, i.e.,
# EMA020 > EMA050 & EMA050 > EMA100 & EMA100 > EMA200
stratGoldenX <- add.signal(stratGoldenX,
                name="sigFormula",
                arguments = list
                    (columns=c("EMA.020","EMA.050","EMA.100", "EMA.200"),
                  formula = "(EMA.020 > EMA.050 & EMA.050 > EMA.100 & EMA.100 > EMA.200)",
                  label="trigger",
                  cross=TRUE),
                label="goldenX_EMA_open")

# The second is when a Golden Cross criteria is no longer met
stratGoldenX <- add.signal(stratGoldenX,
                name="sigFormula",
                arguments = list
                  (columns=c("EMA.020","EMA.050","EMA.100", "EMA.200"),
                formula = "(EMA.020 <= EMA.050 | EMA.050 <= EMA.100 | EMA.100 <= EMA.200)",
                label="trigger",
                cross=TRUE),
                label="goldenX_EMA_close")
# ------------------------------------------------------------------------------
# stratRSI4 <- add.signal(stratGoldenX,
#                 name="sigThreshold",
#                 arguments=list(
#                   threshold=55,
#                   column="RSI",
#                   relationship="lt",
#                   cross=TRUE),
#                 label="Cl.lt.RSI")
################################################################################
## Step 00.05: Add Rules to the Strategy                                     ###
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
stratGoldenX <- add.rule(stratGoldenX,           # Open Long Position        ###
                name="ruleSignal",
                arguments=list(sigcol="goldenX_EMA_open",
                               sigval=TRUE,
                               orderqty=1000,
                               ordertype="market",
                               orderside="long",
                               pricemethod="market",
                               TxnFees=-5,
                               osFUN=osMaxPos),
                               type="enter",
                               path.dep=TRUE)
####RULES####--------------------------------------------https://is.gd/SBHCcH---
# The second is to sell when the Golden Crossing criteria is breached
stratGoldenX <- add.rule(stratGoldenX,
                name="ruleSignal",
                arguments=list(sigcol="goldenX_EMA_close",
                               sigval=TRUE,
                               orderqty="all",
                               ordertype="market",
                               orderside="long",
                               pricemethod="market",
                               TxnFees=-5),
                               type="exit",
                               path.dep=TRUE)
################################################################################
## Step 00.06: Set Position Limits                                           ###
################################################################################
addPosLimit("GoldenX", "SPL.AX", timestamp=initDate, maxpos=1000, minpos=0)
################################################################################
## Step 00.07: Apply and Save Strategy                                       ###
################################################################################
# ------------------------------------------------------------------------------
goldenX_EMA <- here::here("dashboard/rds/", "goldenX_EMA.RData")
if( file.exists(goldenX_EMA)) {
  load(goldenX_EMA)
} else {
  results  <- applyStrategy(stratGoldenX, portfolios = "GoldenX")
  updatePortf("GoldenX")
  updateAcct("GoldenX")
  updateEndEq("GoldenX")
  if(checkBlotterUpdate("GoldenX", "GoldenX", verbose = TRUE)) {
    save(list = "results", file = here::here("dashboard/rds/", "goldenX_EMA"))
    save.strategy(stratGoldenX)
  }
}
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version = "1.0.0"
a00.ModDate = as.Date("2019-12-01")
################################################################################
# 2019.12.01 - v.1.0.0
#  1st release
################################################################################
