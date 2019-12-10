# R Algo Trading Course
# Introduction to R packages for Algorithmic trading
# https://is.gd/KXB2qi

install_packages("devtools")
install_github("braverock/FinancialInstrument")
install_github("braverock/blotter")
install_github("braverock/quantstrat")
install_github("braverock/PerformanceAnalytics")

library(quantstrat)
library(plotly)
################################################################################
## 01 - Import Financial Date
################################################################################
# 1.1 Importing the dataset for Automated traded algorithms
################################################################################
# Sys.setenv(TZ = "Asia/Kolkata")
symbols      <- basic_symbols()
FinancialInstrument::currency(c("AUD","USD"))          # Set the currency    ###
stock(symbols, currency="AUD")                         # Define the stocks   ###
exchange_rate("AUDUSD")
init_date <- "2011-12-31" #the date on which we want to intialize the portfolio and account
start_date <- "2012-01-01" #the date from which we want to collect the data
end_date <- "2017-12-31" #the date untill when we want to collect the data
init_equity <- 100000 #initial account equity value
adjustment <- TRUE #TRUE when we want to adjust prices otherwise FALSE
getSymbols(symbols, src = "yahoo", from = start_date, to = end_date, adjust = adjustment)

df <- data.frame(Date=index(symbols),coredata(symbols))
plot_ly(x = df$Date, type="candlestick",
          open = df$SPL.AX.Open, close = df$SPL.AX.Close,
          high = df$SPL.AX.High, low = df$SPL.AX.Low)
################################################################################
## 02 - Environment Setup and Technical Indicators                           ###
################################################################################
library(quantstrat)
Sys.setenv(TZ='America/New_York')
FinancialInstrument::currency(c("AUD","USD"))          # Set the currency    ###
init_date <- "2011-12-31"
start_date <- "2012-01-01"
end_date <- "2017-12-31"
init_equity <- 100000
adjustment <- TRUE
getSymbols(Symbols = symbols, 
           src = "yahoo", 
           from = start_date, 
           to = end_date, 
           adjust = adjustment)

stock("SPL.AX",currency="AUD",multiplier = 1)
################################################################################
# 2.1 Setting up Algorithmic trading strategy
################################################################################
# Assign names to the portfolio, account and strategy as follows:
strategy.st<-"basic_strat"
portfolio.st<-"basic_portfolio"
account.st<-"basic_account"
# ------------------------------------------------------------------------------
# If there are any other portfolios or account book with these names 
# remove them using rm.strat function
# ------------------------------------------------------------------------------
rm.strat(portfolio.st)
rm.strat(account.st)
# ------------------------------------------------------------------------------
# To start, we initialize account and portfolio where:                       ###
initPortf(name = portfolio.st,symbols = symbols,initDate = init_date)
initAcct(name = account.st,portfolios = portfolio.st,initDate = init_date,initEq = init_equity)
initOrders(portfolio = portfolio.st,symbols = symbols, initDate = init_date)
# ------------------------------------------------------------------------------
# Store the strategy st using strategy function
strategy(strategy.st, store = TRUE)
################################################################################
# 2.2 Algorithmic trading indicators
################################################################################
# ------------------------------------------------------------------------------
# plot the closing prices of NSE and add SMA of 40 days period to it using addSMA 
# function as Technical indicator.
# ------------------------------------------------------------------------------
color="red"
chartSeries(SPL.AX[,4],TA="addSMA(n=40,col=color)")
chartSeries(SPL.AX[,4], TA="addMACD(fast = 12, slow = 26, signal = 9, histogram = TRUE)")
# ------------------------------------------------------------------------------
# RSI stands for Relative Strength Index. It is used to compare the magnitude of 
# recent gains and losses over a specified time period to measure speed and change 
# of price movements. RSI value varies between 0 and 100.
chartSeries(SPL.AX[,4], TA="addRSI(n=14)")
# ------------------------------------------------------------------------------
# Bollinger Bands
# Bollinger Bands consists of upper and lower bands which are plotted 2 
# standard deviations away from a simple moving average.
sma="SMA"
bands="bands"
color="blue"
chartSeries(NSEI$NSEI.Close, TA="addBBands(n=20,maType=sma,draw=bands)")
################################################################################
# 2.3 Adding an indicator to the strategy
# add.indicator function is used to add indicators to the strategy. 
# This function takes the strategy to which the indicator is to be added, name
# of the function used as indicator in this case it is “SMA”, arguments contains 
# reuired parameters of the function used, here as we are using SMA parameters 
# will be closing price and the period “n” which is used to calculate SMA.
# ------------------------------------------------------------------------------
# mktdata is dataset containing symbols coredata, indicators and signals. 
# This object will be created in environment when strategy is executed.
################################################################################
add.indicator(strategy.st, name = "SMA", 
                  arguments = list(x=quote(Cl(mktdata)),n=40),
                  label='SMA_40' )
# ------------------------------------------------------------------------------
#  add RSI with 7 day period as indicator.
# ------------------------------------------------------------------------------
add.indicator(strategy.st, name = "RSI", 
                  arguments = list(x=quote(Cl(mktdata)),n=7),
                  label='RSI_7' )
################################################################################
## 03 – Adding Indicators and Signals to a trading strategy                  ###
################################################################################

################################################################################
## 3.1 Import Data
################################################################################
library(quantstrat)
Sys.setenv(TZ='America/New_York')
FinancialInstrument::currency(c("AUD","USD"))          # Set the currency    ###
init_date <- "2011-12-31"
start_date <- "2012-01-01"
end_date <- "2017-12-31"
init_equity <- 100000
adjustment <- TRUE
getSymbols(Symbols = symbols, 
           src = "yahoo", 
           from = start_date, 
           to = end_date, 
           adjust = adjustment)

stock(symbols ,currency="AUD",multiplier = 1)
################################################################################
##  3.2 Algorithmic Trading Strategy Setup
################################################################################
# ------------------------------------------------------------------------------
# Assign names to the portfolio, account and strategy as follows:
strategy.st<-"basic_strat"
portfolio.st<-"basic_portfolio"
account.st<-"basic_account"
# ------------------------------------------------------------------------------
# If there are any other portfolios or account book with these names 
# remove them using rm.strat function
# ------------------------------------------------------------------------------
rm.strat(portfolio.st)
rm.strat(account.st)
# ------------------------------------------------------------------------------
# To start, we initialize account and portfolio where:                       ###
initPortf(name = portfolio.st,symbols = symbols,initDate = init_date)
initAcct(name = account.st,portfolios = portfolio.st,initDate = init_date,initEq = init_equity)
initOrders(portfolio = portfolio.st,symbols = symbols, initDate = init_date)
# ------------------------------------------------------------------------------
# Store the strategy st using strategy function
strategy(strategy.st, store = TRUE)
################################################################################
## 3.3 Add Algorithmic Trading Indicators
# ------------------------------------------------------------------------------
## In this strategy the indicators to be used are RSI and MACD. Aadd these
## indicators to the strategy-
## add RSI for 7 day period as indicator to the strategy
## add.indicator function is used to add an indicator to the strategy, 
## it takes the following arguments:
##   strategy.st- strategy to which indicator is to be added, 
##   RSI- name of the function used as indicators, 
##   arguments of the function 
##       (RSI takes price(closing prices of SPL.AX in this case) 
##        and number of periods(7 here) as arguments) and 
##   RSI_7- label that will be used as name for the indicator output.
################################################################################
add.indicator(strategy = strategy.st,
              name = "RSI",
              arguments = list(price = quote(Cl(mktdata)), 
                               n = 7),
              label = "RSI_7")
# ------------------------------------------------------------------------------
## add macd as indicator to the strategy, macd takes fastMA = 12, slowMA = 26, signalMA = 9
fastMA = 12 
slowMA = 26 
signalMA = 9
maType="EMA"
add.indicator(strategy.st, name = "MACD", 
                  arguments = list(x=quote(Cl(mktdata)),
                                   nFast=fastMA, 
                                   nSlow=slowMA,histogram = TRUE),
                  label='MACD' 
)
################################################################################
## 3.4 apply indicator
################################################################################
mktdata_ind <- applyIndicators(strategy=strategy.st,mktdata=NSEI)
mktdata_ind[is.na(mktdata_ind)]=0
################################################################################
## 3.5  Algorithmic Trading Signals
################################################################################
# Signal is a sign that tells whether it is time to buy or sell security. Signals can be triggered either on the basis of technical indicators or time metrics or prices.
# add.signal in quantstrat helps to add a signal to the trading strategy. The arguments of this function are:
# strategy to which signal is to be added, name of the function used to generate signal, arguments of the function and label a text that will be used as name for the signal output.
# Functions to generate a signal:
# i. sigThreshold:
#   In trading strategies certain decisions are to be made when an indicator is
#   greater than or less than a specific threshold value. sigThreshold function
#   generates signal by returning true when an indicator crosses a threshold
#   value by given relationship.
#   relationship can be 
#       greater than(gt), 
#       less than(lt), 
#       eq(equal to), 
#       greater than or equal to(gte) and 
#        less than or equal to(lte).
# ii. sigCrossover:
#   Sometimes trading signals are to be generated by comparing 2 indicators, for example you might want to generate a signal when macd line crosses the signal line from below for the first time. sigCrossover function generates signal by returning true when an indicator crosses other indicator by a given relationship for the first time.
# iii. sigComparison:
#   sigComparison function is similar to sigCrossover except that it returns true everytime when the relationship between 2 indicators holds true.
# iv. sigFormula
#   In some situations you might want to generate a signal by comparing 2 or more columns. sigFormula function applies a formula on indicators and returns true whenever the formula returns true. Formula is the logical expression which you want to evaluate to generate a signal.
# There are some other functions like sigPeak, sigTimestamp.
# ------------------------------------------------------------------------------
# Let us add signals to our strategy:
################################################################################
# i. RSI_7 greater than 50
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name = "sigThreshold", 
            arguments = list(
                column = "rsi.RSI_7",
                threshold=50,
                relationship="gt"), 
            label = "RSI_gt_50")
# ------------------------------------------------------------------------------
# ii. macd histogram crosses zero line from below
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name = "sigCrossover", 
            arguments = list(
                columns = c("macd.MACD","signal.MACD"),
                relationship="gt"), 
                label = "macd_gt_0")
# ------------------------------------------------------------------------------
# iii. Generate a long signal
# Using add.signal function add a signal Long to the strategy which returns TRUE
# when RSI_gt_50 & macd_gt_0 are True. To generate the signal use sigFormula
# function as we are evaluating a logical expression to generate a signal.
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name = "sigFormula",
            arguments = list(
                formula="RSI_gt_50 & macd_gt_0",
                cross = FALSE), 
            label = "Long")
# ------------------------------------------------------------------------------            
# iv. RSI_7 less than 50 
# Using add.signal function add a signal RSI_lt_50 to the strategy which returns
# TRUE when rsi.RSI_7 is less than 50. To generate the signal use sigThreshold 
# function as we are comparing indicator to a threshold value.
# ------------------------------------------------------------------------------
add.signal(strategy.st, 
            name = "sigThreshold", 
            arguments = list(
               column = "rsi.RSI_7",
               threshold=50,
               relationship="lt"), 
            label = "RSI_lt_50")
# ------------------------------------------------------------------------------
# v. macd histogram crosses zero line from above
add.signal(strategy.st,
            name = "sigCrossover", 
            arguments = list(
                columns = c("macd.MACD","signal.MACD"),
                relationship="lt"),
                cross=TRUE, 
            label = "macd_lt_0")
# ------------------------------------------------------------------------------
# vi.apply signals
mktdata_sig <- applySignals(strategy=strategy.st,mktdata=mktdata_ind)
mktdata_sig[is.na(mktdata_sig)]=0
knitr::kable(tail(mktdata_sig))
# ------------------------------------------------------------------------------

################################################################################
## 04 – Adding Rules and applying trading strategy                           ###
## Algorithmic Trading Rules                                                 ###
################################################################################
# 04.10 Enter Long --------------------------------------------------------------
add.rule(strategy = strategy.st, 
        name="ruleSignal", 
        arguments = list(
            sigcol = "Long", 
            sigval = TRUE, 
            orderqty = 100, 
            ordertype = "market",
            TxnFees = -75,
            orderside = "long",
            prefer="Open", 
            replace = FALSE), 
        type = "enter",
        label='enter long'
        )
# 04.20 Exit Long -------------------------------------------------------------- 
add.rule(strategy.st,
        name='ruleSignal', 
        arguments = list(
            sigcol="macd_lt_0",
            sigval=TRUE, 
            orderqty='all', 
            ordertype='market', 
            orderside='long', 
            prefer="Open",
            TxnFees = -75,
            replace=TRUE),
        type='exit',
        label='long exit1'
        )
# 04.21 Exit Long 2-------------------------------------------------------------
add.rule(strategy.st,
        name='ruleSignal', 
        arguments = list(
            sigcol="RSI_lt_50",
            sigval=TRUE, 
            orderqty='all', 
            ordertype='market', 
            orderside='long', 
            prefer="Open",
            TxnFees = -75,orderset='ocolong',
            replace=TRUE),
            type='exit',
            label='long exit2'
)
# Now all the 3 rules are added to the strategy.
# ------------------------------------------------------------------------------
# 04.30 Apply Trading Strategy--------------------------------------------------
applyStrategy(strategy = strategy.st,portfolios = portfolio.st)
# 04.40 updatePortf function calculates the PL for each period prices that r available.
updatePortf(portfolio.st)
# 04.50 updateAcct function is used to perform equity account calculations from
# the portfolio data and corresponding close prices.
updateAcct(account.st)
# 04.60 updateEndEq function is used to calculate End.Eq and Net.Performance.
# updateEndEq function is used to calculate End.Eq and Net.Performance.
# 04.70 Chart Trades
chart.Posn(portfolio.st,"NSEI")



