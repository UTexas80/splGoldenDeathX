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
           src = "yahoo", 
           from = start_date, 
           to = end_date, 
           adjust = adjustment)
# ------------Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###
SPL.AX <-
        SPL.AX %>%
        na.omit()
# ------------------------------------------------------------------------------
stock(symbols ,currency = "AUD",multiplier = 1)
################################################################################
##  1.02 Algorithmic Trading Strategy Setup
################################################################################
# ------------------------------------------------------------------------------
# Assign names to the portfolio, account and strategy as follows:
# ------------------------------------------------------------------------------
strategy.st  <- "basic_strat"
portfolio.st <- "basic_portfolio"
account.st   <- "basic_account"
# ------------------------------------------------------------------------------
# If there are any other portfolios or account book with these names
# remove them using rm.strat function
# ------------------------------------------------------------------------------
rm.strat(portfolio.st)
rm.strat(account.st)
# ------------------------------------------------------------------------------
# To start, we initialize account and portfolio where:                       ###
# Porfolio: stores which stocks to be traded                                 ###
# Account: stores money transactions                                         ###
# ------------------------------------------------------------------------------
initPortf(name = portfolio.st,                  # Portfolio Initialization   ###
          symbols = symbols,
          initDate = init_date)
# ------------------------------------------------------------------------------
initAcct(name = account.st,                     # Account Initialization     ###
        portfolios = portfolio.st,
        initDate = init_date,
        initEq = init_equity)
# ------------------------------------------------------------------------------
initOrders(portfolio = portfolio.st,            # Order Initialization       ###
           symbols = symbols,
           initDate = init_date)
# ------------------------------------------------------------------------------
strategy(strategy.st, store = TRUE)             # Strategy Initialization    ###
################################################################################
## Step 1.03: Add Indicators to the Strategy            https://is.gd/SBHCc  ###
################################################################################
# ------------------------------------------------------------------------------
# 1.03.1 Add the RSI indicator
# ------------------------------------------------------------------------------
add.indicator(strategy = strategy.st,
              name = "RSI",
              arguments = list(
                price = quote(Cl(mktdata)),
                n = 7),
              label = "RSI_7")
# ------------------------------------------------------------------------------
## 1.03.2 add macd as indicator to the strategy,
## macd takes fastMA = 12, slowMA = 26, signalMA = 9
# ------------------------------------------------------------------------------
fastMA   = 12 
slowMA   = 26 
signalMA = 9
maType   = "EMA"
# ------------------------------------------------------------------------------
add.indicator(strategy.st, 
              name        = "MACD", 
              arguments   = list(
                x = quote(Cl(mktdata)),
                nFast = fastMA, 
                nSlow = slowMA,
                histogram = TRUE),
              label = 'MACD' 
)
##------------------------------------------------------------------------------
## 1.03.3.0 add GoldenX as indicators to the strategy
##------------------------------------------------------------------------------
## 1.03.3.1 Add the 20-day SMA indicator
##------------------------------------------------------------------------------
add.indicator(strategy.st,
              name="EMA", 
              arguments =list(
                x=quote(mktdata[,4]), 
                n=20), 
              label="020")
##------------------------------------------------------------------------------
## 1.03.3.2 Add the 50-day SMA indicator
##------------------------------------------------------------------------------
add.indicator(strategy.st,
              name="EMA", 
              arguments =list(
                x=quote(mktdata[,4]), 
                n=50), 
              label="050")
##------------------------------------------------------------------------------
## 1.03.3.3 Add the 100-day SMA indicator
##------------------------------------------------------------------------------
add.indicator(strategy.st,
              name="EMA", 
              arguments = list(
                x=quote(mktdata[,4]), 
                n=100), 
              label="100")
##------------------------------------------------------------------------------
## 1.03.3.4 Add the 200-day SMA indicator
##------------------------------------------------------------------------------
add.indicator(strategy.st,
              name="EMA", 
              arguments = list(
                x=quote(mktdata[,4]), 
                n=200), 
              label="200")
################################################################################
## 1.4 apply indicator
################################################################################
mktdata_ind <- applyIndicators(strategy = strategy.st,mktdata=SPL.AX)
mktdata_ind[is.na(mktdata_ind)] = 0
################################################################################
## 1.05: add signals to the strategy                                         ###
################################################################################
# ------------------------------------------------------------------------------
# i. RSI_7 greater than 50
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name             = "sigThreshold", 
            arguments        = list(
                column       = "rsi.RSI_7",
                threshold    = 50,
                relationship = "gt"), 
            label            = "RSI_gt_50")
# ------------------------------------------------------------------------------
# ii. macd histogram crosses zero line from below
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name             = "sigCrossover", 
            arguments        = list(
                columns      = c("macd.MACD","signal.MACD"),
                relationship = "gt"), 
                label        = "macd_gt_0")
# ------------------------------------------------------------------------------
# iii. Generate a long signal
# Using add.signal function add a signal Long to the strategy which returns TRUE
# when RSI_gt_50 & macd_gt_0 are True. To generate the signal use sigFormula
# function as we are evaluating a logical expression to generate a signal.
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name             = "sigFormula",
            arguments        = list(
                formula      = "RSI_gt_50 & macd_gt_0",
                cross        = FALSE), 
            label            = "Long")
# ------------------------------------------------------------------------------            
# iv. RSI_7 less than 50 
# Using add.signal function add a signal RSI_lt_50 to the strategy which returns
# TRUE when rsi.RSI_7 is less than 50. To generate the signal use sigThreshold 
# function as we are comparing indicator to a threshold value.
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name             = "sigThreshold", 
            arguments        = list(
               column        = "rsi.RSI_7",
               threshold     = 50,
               relationship  = "lt"), 
            label            = "RSI_lt_50")
# ------------------------------------------------------------------------------
# v. macd histogram crosses zero line from above
# ------------------------------------------------------------------------------
add.signal(strategy.st,
            name             = "sigCrossover", 
            arguments        = list(
                columns      = c("macd.MACD","signal.MACD"),
                relationship = "lt"),
                cross        = TRUE, 
            label            = "macd_lt_0")

# ------------------------------------------------------------------------------
# vi. Golden Cross occurs; [EMA020 > EMA050 & EMA050 > EMA100 & EMA100 > EMA200]
# ------------------------------------------------------------------------------
add.signal(strategy.st,
           name              = "sigFormula",
           arguments         = list(
                columns      = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
                formula      = "(EMA.020 > EMA.050 & EMA.050 > EMA.100 & EMA.100 > EMA.200)",
                label        = "trigger",
                cross        = TRUE),
           label             = "goldenX_EMA_open")
# ------------------------------------------------------------------------------
# Golden Cross criteria is no longer active
# ------------------------------------------------------------------------------
add.signal(strategy.st,
           name              = "sigFormula",
           arguments         = list
                (columns     = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
                formula      = "(EMA.020 <= EMA.050 | EMA.050 <= EMA.100 | EMA.100 <= EMA.200)",
                label        = "trigger",
                cross        = TRUE),
           label             = "goldenX_EMA_close")
# ------------------------------------------------------------------------------
# vi.apply signals
# ------------------------------------------------------------------------------
mktdata_sig <- applySignals(
                strategy = strategy.st,
                mktdata = mktdata_ind)
mktdata_sig[is.na(mktdata_sig)] = 0
knitr::kable(tail(mktdata_sig))
# ------------------------------------------------------------------------------

################################################################################
## 1.06 – Adding Rules and applying trading strategy                         ###
## Algorithmic Trading Rules                                                 ###
################################################################################
# 1.06.1 Enter Long ------------------------------------------------------------
add.rule(strategy      = strategy.st, 
        name           = "ruleSignal", 
        arguments      = list(
            sigcol     = "Long", 
            sigval     = TRUE, 
            orderqty   = 100, 
            ordertype  = "market",
            TxnFees    = -75,
            orderside  = "long",
            prefer     = "Open", 
            replace    = FALSE), 
        type           = "enter",
        label          = 'enter long'
        )
# 1.06.2 Exit Long -------------------------------------------------------------
add.rule(strategy.st,
        name           = 'ruleSignal', 
        arguments      = list(
            sigcol     = "macd_lt_0",
            sigval     = TRUE, 
            orderqty   = 'all', 
            ordertype  = 'market', 
            orderside  = 'long', 
            prefer     = "Open",
            TxnFees    = -75,
            replace    = TRUE),
        type           = 'exit',
        label          = 'long exit1'
        )
# 1.06.3 Exit Long 2------------------------------------------------------------
add.rule(strategy.st,
        name           = 'ruleSignal', 
        arguments      = list(
            sigcol     = "RSI_lt_50",
            sigval     = TRUE, 
            orderqty   = 'all', 
            ordertype  = 'market', 
            orderside  = 'long', 
            prefer     = "Open",
            TxnFees    = -75,
            orderset   = 'ocolong',
            replace    = TRUE),
            type       = 'exit',
            label      = 'long exit2'
)
# 1.06.4 Open Long GoldenX------------------------------------------------------
 add.rule(goldenX_EMA_strategy,
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
# 1.06.5 Sell when the Golden Crossing criteria is breached---------------------
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
# ------------------------------------------------------------------------------
# Now all the 3 rules are added to the strategy.
# ------------------------------------------------------------------------------
# 1.07  Apply Trading Strategy--------------------------------------------------
applyStrategy(strategy = strategy.st,portfolios = portfolio.st)
# ------------------------------------------------------------------------------
# 1.08 updatePortf function calculates the PL for each period prices that r available.
# ------------------------------------------------------------------------------
updatePortf(portfolio.st)
# ------------------------------------------------------------------------------
# 1.09 updateAcct function is used to perform equity account calculations from
# the portfolio data and corresponding close prices.
# ------------------------------------------------------------------------------
updateAcct(account.st)
# ------------------------------------------------------------------------------
# 1.11 updateEndEq function is used to calculate End.Eq and Net.Performance.
# ------------------------------------------------------------------------------
updateEndEq(account.st)
# ------------------------------------------------------------------------------
# 1.12 Chart Trades
# ------------------------------------------------------------------------------
chart.Posn(portfolio.st,"SPL.AX")
