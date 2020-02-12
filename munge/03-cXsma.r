# Stackoverflow https://is.gd/9x5VBU
library(quantstrat)
library(quantmod)

browser()

initdate = "1999-01-01"
from = "2003-01-01"
to = "2015-12-31"

symbols = "CSL.AX"
currency ("USD")
CSL.AX <- tidyquant::tq_get(symbols,
                  get = "stock.prices",
                  from = from,
                  to = to
)
# ------------Replace missing values (NA)       https://tinyurl.com/y5etxh8x ###

CSL.AX <- tk_xts(CSL.AX)

stock("CSL.AX", currency = "AUD")

Sys.setenv (TZ = "UTC")

# na.omit(getSymbols ("SPL.AX", from = from,
#             to = to, src = "yahoo",
#             adjust = TRUE,
#             index.class=c("POSIXt","POSIXct")))

tradesize <- 100000
initeq <- 100000

strategy.st <- portfolio.st <- account.st <- "firststrat"
rm.strat(strategy.st)
initPortf(portfolio.st,
          symbols = symbols,
          initDate = initdate,
          currency = "USD")
initAcct(account.st,
         portfolios = portfolio.st,
         initDate = initdate,
         currency = "USD",
         initEq = initeq)
initOrders(portfolio.st, initDate = initdate)
strategy(strategy.st, store = TRUE)

add.indicator(strategy = strategy.st,
              name = "SMA",
              arguments = list(x = quote(Cl(mktdata)), n = 200),
              label = "SMA200")

add.indicator(strategy = strategy.st,
              name = "SMA",
              arguments = list(x = quote(Cl(mktdata)), n = 50),
              label = "SMA50")

add.signal(strategy.st,
           name = "sigCrossover",
           arguments = list(columns = c("SMA50", "SMA200"),
                            relationship = "gt"),
           label = "longfilter")

add.signal(strategy.st,
           name = "sigComparison",
           arguments = list(columns = c("SMA50", "SMA200"),
                            relationship = "lt" ),
           label = "filterexit")

# Short signals
# add.signal(strategy.st,
#           name = "sigCrossover",
#           arguments = list(columns = c("Close", "namedLag.ind"),
#                           relationship = "gt"),
#           label = "coverOrBuy")
# 
# add.signal(strategy.st,
#            name = "sigCrossover",
#            arguments = list(columns = c("Close", "namedLag.ind"),
#                             relationship = "lt"),
#            label = "sellOrShort")

add.rule(strategy.st, name = "ruleSignal",
         arguments = list(sigcol = "filterexit", sigval = TRUE,
                          orderqty = "all", ordertype = "market",
                          orderside = "long", replace = FALSE,
                          prefer = "Open"),
         type = "exit")

add.rule(strategy.st, name = "ruleSignal",
         arguments = list(sigcol = "longfilter", sigval = TRUE,
                          orderqty = tradesize, ordertype = "market",
                          orderside = "long", replace = FALSE,
                          prefer = "Open"),
         type = "enter")

# Short rules
# add.rule(strategy.st, name = "ruleSignal",
#     arguments = list(sigcol = "sellOrShort",
#         sigval = TRUE, ordertype = "market",
#         orderside = "short" , replace = FALSE,
#         prefer = "Open", osFUN = osDollarATR,
#         tradeSize = -tradeSize, pctATR = pctATR,
#         atrMod = "X"),
#     type = "enter" , path.dep = TRUE)
# 
# add.rule(strategy.st, name = "ruleSignal",
#     arguments = list(sigcol = "coverOrBuy",
#         sigval = TRUE, orderqty = "all",
#         ordertype = "market", orderside = "short" ,
#         replace = FALSE, prefer = "Open"),
#     type = "exit" , path.dep = TRUE)

applyStrategy(strategy.st, portfolio.st)

updatePortf(portfolio.st)
daterange <- time(getPortfolio(portfolio.st)$summary)[-1]

updateAcct(account.st, daterange)
updateEndEq(account.st)

tradeStats(Portfolios = portfolio.st)