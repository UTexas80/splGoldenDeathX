################################################################################
# Nuts and Bolts of Quantstrat, Part V         ###  https://wp.me/p4tAbQ-9r  ###
################################################################################
## 1.0 –  pre-processing custom indicators in quantstrat                    ###
################################################################################
## Step 1.00 Setup                                                           ###
################################################################################
initDate="1990-01-01"
from="2003-01-01"
to=Sys.Date()
# ------------------------------------------------------------------------------
options("getSymbols.warning4.0"=FALSE)
FinancialInstrument::currency(c("USD"))                # Set the currency    ###
currency('USD')
Sys.setenv(TZ="UTC")
# ------------------------------------------------------------------------------
symbols <- 'ENPH'
suppressMessages(getSymbols(symbols, from=from, to=to, src="yahoo", adjust=TRUE))
stock(symbols, currency="USD", multiplier=1)
## -----------------------------------------------------------------------------
## 1.02 Algorithmic Trading Strategy Setup                                   ###
## -----------------------------------------------------------------------------
strategy.st <- portfolio.st <- account.st <- "nonDerivedData"
# ------------------------------------------------------------------------------
#  1.02.01 
# If there are any other portfolios or account book with these names
# remove them using rm.strat function
rm.strat(strategy.st)
# ------------------------------------------------------------------------------
#  1.02.02
# Due to the dependencies between the portfolio, account, and orders, the    ###
# portfolio must be initialized before the account, and it also must be      ###
# initialized before the orders.                                             ###
# ------------------------------------------------------------------------------
initPortf(portfolio.st, symbols=symbols, initDate=initDate, currency='USD')
initAcct(account.st, portfolios=portfolio.st, initDate=initDate, currency='USD')
initOrders(portfolio.st, initDate=initDate)
# 1.02.03 Strategy Initialization                                            ###
# ------------------------------------------------------------------------------
strategy(strategy.st, store=TRUE)
################################################################################
## Step 1.03: Add Indicators to the Strategy    # https://is.gd/SBHCc        ###
################################################################################
nonDerivedIndicator <- as.numeric(as.character(substr(index(ENPH), 1, 4)))%%2 == 1
nonDerivedIndicator <- xts(nonDerivedIndicator, order.by=index(ENPH))
# ------------------------------------------------------------------------------
ENPH <- cbind(ENPH, nonDerivedIndicator)
colnames(ENPH)[7] = "nonDerivedIndicator"
################################################################################
## 1.4 apply indicator                                                       ###
## This allows a user to see how the indicators will be appended to the      ###
## mktdata object.                                                           ###
################################################################################
ENPH_mktdata_ind <- applyIndicators(strategy = strategy.st,mktdata = ENPH)
ENPH_mktdata_ind[is.na(mktdata_ind)] = 0
################################################################################
## 1.05: add signals to the strategy                                         ###
## signals describe the interaction of indicators with each other            ###
################################################################################
add.signal(strategy.st, name = sigThreshold, 
           arguments = list(column = "nonDerivedIndicator", threshold = 0.5, relationship = "gte", cross = TRUE),
           label = "longEntry")

add.signal(strategy.st, name = sigThreshold, 
           arguments = list(column = "nonDerivedIndicator", threshold = 0.5, relationship = "lte", cross = TRUE),
           label = "longExit")

################################################################################
## 1.06 apply signals
################################################################################
tmp <- applySignals(strategy = strategy.st, mktdata=ENPH)
ENPH_mktdata_sig <- applySignals(
                strategy = strategy.st,
                mktdata = ENPH_mktdata_ind)
ENPH_mktdata_sig[is.na(ENPH_mktdata_sig)] = 0
knitr::kable(tail(ENPH_mktdata_sig)) 
################################################################################
## 1.07 – Adding Rules and applying trading strategy                         ###
################################################################################ 
add.rule(strategy.st, name="ruleSignal", 
         arguments=list(sigcol="longEntry", sigval=TRUE, ordertype="market", 
                        orderside="long", replace=FALSE, prefer="Open", orderqty = 1), 
         type="enter", path.dep=TRUE)
 
add.rule(strategy.st, name="ruleSignal", 
         arguments=list(sigcol="longExit", sigval=TRUE, orderqty="all", 
                        ordertype="market", orderside="long", 
                        replace=FALSE, prefer="Open"), 
         type="exit", path.dep=TRUE)
################################################################################
## 1.09  apply and save strategy                                             ###
################################################################################
t1 <- Sys.time()
ENPH_Strategy <- applyStrategy(strategy=strategy.st,portfolios=portfolio.st)
t2 <- Sys.time()
print(t2-t1)
################################################################################
## 1.10 update portfolio and account                                         ###
################################################################################
updatePortf(portfolio.st)
ENPH_dateRange <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(portfolio.st,ENPH_dateRange)
updateEndEq(account.st)
save.strategy(strategy.st)
################################################################################
## 1.11 Chart Trades
################################################################################
chart.Posn(portfolio.st, 'ENPH')
# ------------------------------------------------------------------------------
blotter::dailyEqPL(portfolio.st, "ENPH")
blotter::dailyStats(portfolio.st)
blotter::getPortfolio(portfolio.st)
ptsGoldenXema <-blotter::perTradeStats(portfolio.st, symbol = symbols)
################################################################################
## Step 1.12: Save portfolio strategy to .rds                                ###
################################################################################
saveRDS(portfolio.st,
  file = here::here("SPL-Dashboard/rds/",
  paste0(portfolio.st, ".", "rds")))
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-12-01")
# ------------------------------------------------------------------------------
# 2019.12.09 - v.1.0.0
# 1st release


