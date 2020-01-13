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
 currency('USD')
Sys.setenv(TZ="UTC")
# ------------------------------------------------------------------------------
symbols <- 'ENPH'
suppressMessages(getSymbols(symbols, from=from, to=to, src="yahoo", adjust=TRUE))
stock(symbols, currency="USD", multiplier=1)
################################################################################
## Step 2.00 Setup non-derived indicator, i.e. odd / even years              ###
################################################################################
nonDerivedIndicator <- as.numeric(as.character(substr(index(ENPH), 1, 4)))%%2 == 1
nonDerivedIndicator <- xts(nonDerivedIndicator, order.by=index(ENPH))
# ------------------------------------------------------------------------------
ENPH <- cbind(ENPH, nonDerivedIndicator)
colnames(ENPH)[7] = "nonDerivedIndicator"
################################################################################
## Step 3.00 Create strategy                                                 ###
################################################################################
strategy.st <- portfolio.st <- account.st <- "nonDerivedData"
rm.strat(strategy.st)
initPortf(portfolio.st, symbols=symbols, initDate=initDate, currency='USD')
initAcct(account.st, portfolios=portfolio.st, initDate=initDate, currency='USD')
initOrders(portfolio.st, initDate=initDate)
strategy(strategy.st, store=TRUE)
 
add.signal(strategy.st, name = sigThreshold, 
           arguments = list(column = "nonDerivedIndicator", threshold = 0.5, relationship = "gte", cross = TRUE),
           label = "longEntry")
 
add.signal(strategy.st, name = sigThreshold, 
           arguments = list(column = "nonDerivedIndicator", threshold = 0.5, relationship = "lte", cross = TRUE),
           label = "longExit")
 
 
tmp <- applySignals(strategy = strategy.st, mktdata=ENPH)
 
 
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
## Step 4.00 Apply strategy                                                  ###
################################################################################
t1 <- Sys.time()
out <- applyStrategy(strategy=strategy.st,portfolios=portfolio.st)
t2 <- Sys.time()
print(t2-t1)
################################################################################
## Step 5.00 set up analytics                                                ###
################################################################################
updatePortf(portfolio.st)
dateRange <- time(getPortfolio(portfolio.st)$summary)[-1]
updateAcct(portfolio.st,dateRange)
updateEndEq(account.st)
################################################################################
## Step 6.00 display results                                                 ###
################################################################################
chart.Posn(portfolio.st, 'ENPH')
