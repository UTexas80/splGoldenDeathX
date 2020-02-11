# Stackoverflow https://is.gd/9x5VBU
library(quantstrat)
library(quantmod)
initdate = "1999-01-01"
from = "2003-01-01"
to = "2015-12-31"

currency ("USD")
stock("SPL.AX", currency = "AUD")

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



applyStrategy(strategy.st, portfolio.st)

updatePortf(portfolio.st)
daterange <- time(getPortfolio(portfolio.st)$summary)[-1]

updateAcct(account.st, daterange)
updateEndEq(account.st)

tradeStats(Portfolios = portfolio.st)