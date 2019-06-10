#install.packages('quantmod')
# Loads tidyquant, tidyverse, lubridate, quantmod, TTR, and xts
library(tidyquant)
library(caTools)
library(ggplot2) 
library(plotly)
library(TTR)

# Setup dates for zoom window
#end <- ymd("2017-10-30")
end <-  today()
from <- today() - years(10)
start <- end - weeks(52)
days <- length(SPL$date)

# Get SPL Stock Prices
SPL <- tq_get("SPL.AX")
#SPL <- tq_get("SPL.AX", get = "stock.prices", from = from)
#SPL <- tq_get("SPL.AX", get = "stock.prices", from = "2010-05-19", to = "2017-10-30")

SPL
#Just the closing price
#SPL$close

#'
# SMA
SPL %>%
   ggplot(aes(x = date, y = close)) +
   geom_line() +                         # Plot stock price
   geom_ma(ma_fun = SMA, n = 50) +                 # Plot 50-day SMA
   geom_ma(ma_fun = SMA, n = 200, color = "red") + # Plot 200-day SMA
   coord_x_date(xlim = c(today() - weeks(12), today()),
              ylim = c(0.1, 2.0))                     # Zoom in
 
# EVWMA
SPL %>%
   ggplot(aes(x = date, y = adjusted)) +
   geom_line() +                                                   # Plot stock price
   geom_ma(aes(volume = volume), ma_fun = EVWMA, n = 50) +         # Plot 50-day EVWMA
   coord_x_date(xlim = c(today() - weeks(12), today()),
                ylim = c(0.50, 2.0))                               # Zoom in

# ZLEMA 10 day-SMA
SPL %>%
ggplot(aes(x = date, y = adjusted)) +
  geom_line() +                                                   # Plot stock price
  geom_ma(ma_fun = ZLEMA, n = 10, ratio = NULL) +                 # Plot 10-day ZLEMA
# geom_ma(ma_fun = ZLEMA, n = 200, color = "red") +               # Plot 200-day ZLEMA
  coord_x_date(xlim = c(today() - weeks(12), today()),
               ylim = c(0.3, 2.0))                                # Zoom in

from <- today() - years(10)
SPL <- tq_get("SPL.AX", get = "stock.prices", from = from)
SPL

SPL %>%
  ggplot(aes(x = date, y = close)) +
  geom_line() +
  labs(title = "SPL Line Chart", y = "Closing Price", x = "") + 
  theme_tq()

# Charting the 50-day and 200-day simple moving average
SPL %>%
  ggplot(aes(x = date, y = close)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
  geom_ma(ma_fun = SMA, n = 50, linetype = 5, size = 1.25) +
  geom_ma(ma_fun = SMA, n = 200, color = "red", size = 1.25) + 
  labs(title = "SPL Candlestick Chart", 
       subtitle = "50 and 200-Day SMA", 
       y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(end - weeks(24), end),
               ylim = c(0.100, 2.0)) + 
  theme_tq()

#Bollinger Bands / ZLEMA
SPL %>%
  ggplot(aes(x = date, y = close, open = open,
             high = high, low = low, close = close)) +
# geom_candlestick() +
  geom_line() +  
  geom_ma(ma_fun = ZLEMA, n = 10, ratio = NULL) +                 # Plot 10-day ZLEMA
  geom_bbands(ma_fun = SMA, sd = 2, n = 20, 
              linetype = 4, size = 1, alpha = 0.2, 
              fill        = palette_light()[[1]], 
              color_bands = palette_light()[[1]], 
              color_ma    = palette_light()[[2]]) +
  labs(title = "SPL Candlestick Chart", 
       subtitle = "BBands with SMA Applied, Experimenting with Formatting", 
       y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(end - weeks(24), end),
               ylim = c(0.100, 2.0)) + 
# theme_tq()                                                                              #Theme:Default
# theme_tq() + scale_color_tq() + scale_fill_tq()                                         #Theme:Light
# theme_tq_dark() + scale_color_tq(theme = "dark") + scale_fill_tq(theme = "dark")        #Theme:Dark 
  theme_tq_green() + scale_color_tq(theme = "green") + scale_fill_tq(theme = "green")     #Theme:Green


##### Basic Functionality

SPL<- tq_get("SPL.AX", get  = "stock.prices", from = "2012-01-01", to   = "2017-01-31")

# Example 1: Annual Returns
#SPL %>%
SPL_annual_returns <- SPL %>%
  tq_transmute(select     = close, 
               mutate_fun = periodReturn, 
               period     = "yearly", 
               type       = "arithmetic") 
SPL_annual_returns

#Annual Return Chart Method 1
SPL_annual_returns %>%
ggplot(aes(x = year(date), y = yearly.returns)) + 
  geom_hline(yintercept = 0, color = palette_light()[[1]]) +
  geom_point(size = 2, color = palette_light()[[3]]) +
  geom_line(size = 1, color = palette_light()[[3]]) + 
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "SPL: Visualizing Trends in Annual Returns",
       x = "", y = "Annual Returns", color = "") +
  theme_tq()
# theme_tq_green() + scale_color_tq(theme = "green") + scale_fill_tq(theme = "green")     #Theme:Green

#Annual Return Chart Method 2
SPL_annual_returns %>%
  ggplot(aes(x = date, y = yearly.returns, fill = "SPL")) +
  geom_bar(stat = "identity") +
  geom_hline(yintercept = 0, color = palette_light()[[1]]) +
  scale_y_continuous(labels = scales::percent) +
  labs(title = "SPL: Annual Returns",
       subtitle = "SPL: Visualizing Trends in Annual Returns",
       y = "Annual Returns", x = "") + 
  theme_tq() + 
  scale_fill_tq()

# Example 2: Return logarithmic daily returns using periodReturn()

SPL<- tq_get("SPL.AX", get  = "stock.prices", from = "2012-01-01", to   = "2017-01-30")

SPL %>%
  
  tq_mutate(select = close, mutate_fun = periodReturn,
            period = "daily", type = "log")

# Example 2: Use tq_mutate_xy to use functions with two columns required
SPL %>%
  tq_mutate_xy(x = close, y = volume, mutate_fun = EVWMA,
               col_rename = "EVWMA")

#Example 2B: Getting Daily Log Returns
SPL_daily_log_returns <- SPL %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = periodReturn, 
               period     = "daily", 
               type       = "log",
               col_rename = "daily.returns")
SPL_daily_log_returns

SPL_daily_log_returns %>%
  ggplot(aes(x = daily.returns, fill = "SPL")) +
  geom_density(alpha = 0.5) +
  labs(title = "SPL: Charting the Daily Log Returns",
       x = "Monthly Returns", y = "Density") +
  theme_tq() +
  scale_fill_tq()

#Example 3: MACD to Visualize Moving Average Convergence Divergence
SPL_MACD <- SPL %>%
  tq_mutate(select     = close, 
            mutate_fun = MACD, 
            nFast      = 12, 
            nSlow      = 26, 
            nSig       = 9, 
            maType     = SMA) %>%
  mutate(diff = macd - signal) %>%
  select(-(open:volume))
SPL_MACD

SPL_MACD %>%
  filter(date >= as_date("2016-06-01")) %>%
  ggplot(aes(x = date)) + 
  geom_hline(yintercept = 0, color = palette_light()[[1]]) +
  geom_line(aes(y = macd, col = "SPL")) +
  geom_line(aes(y = signal), color = "blue", linetype = 2) +
  geom_bar(aes(y = diff), stat = "identity", color = palette_light()[[1]]) +
  labs(title = "SPL: Moving Average Convergence Divergence",
       y = "MACD", x = "", color = "") +
#  theme_tq() +
  theme_tq_green() + scale_color_tq(theme = "green") + scale_fill_tq(theme = "green")     #Theme:Green  
  scale_color_tq()
  
  #Example 3c: MACD to Visualize Moving Average Convergence Divergence
  SPL_SMA <- SPL %>%
  tq_mutate_xy(x = close, mutate_fun = SMA, n = 15) %>%
    rename(SMA.15 = SMA) %>%
    tq_mutate_xy(x = close, mutate_fun = SMA, n = 50) %>%
    rename(SMA.50 = SMA)
  
  
  my_palette <- c("black", "blue", "red")
  SPL %>%
    select(date, close, SMA.15, SMA.50) %>%
    gather(key = type, value = price, close:SMA.50) %>%
    ggplot(aes(x = date, y = price, col = type)) +
    geom_line() +
    scale_colour_manual(values = my_palette) + 
    theme(legend.position="bottom") +
    ggtitle("Simple Moving Averages are a Breeze with tidyquant") +
    xlab("") + 
    ylab("Stock Price")  

SPL_RSI  <- SPL %>%

#Example 4: Max and Min Price for Each Quarter
SPL_max_by_qtr <- SPL %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = apply.quarterly, 
               FUN        = max, 
               col_rename = "max.close") %>%
  mutate(year.qtr = paste0(year(date), "-Q", quarter(date))) %>%
  select(-date)
SPL_max_by_qtr

SPL_min_by_qtr <- SPL %>%
  tq_transmute(select     = adjusted, 
               mutate_fun = apply.quarterly, 
               FUN        = min, 
               col_rename = "min.close") %>%
  mutate(year.qtr = paste0(year(date), "-Q", quarter(date))) %>%
  select(-date)
SPL_min_by_qtr

SPL_by_qtr <- left_join(SPL_max_by_qtr, SPL_min_by_qtr,
                         by = c("year.qtr" = "year.qtr"))
SPL_by_qtr

SPL_by_qtr %>%
  ggplot(aes(x = year.qtr, color = "SPL")) +
  geom_segment(aes(xend = year.qtr, y = min.close, yend = max.close),
               size = 1) +
  geom_point(aes(y = max.close), size = 2) +
  geom_point(aes(y = min.close), size = 2) +
  labs(title = "SPL: Min/Max Price By Quarter",
       y = "Stock Price", color = "") +
# theme_tq() +
  theme_tq_green() + scale_color_tq(theme = "green") + scale_fill_tq(theme = "green")     #Theme:Green    
  scale_color_tq() +
  scale_y_continuous(labels = scales::dollar) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.title.x = element_blank())
  
# Get list of tq_mutate() options
tq_mutate_fun_options() %>% 
    str() # str() to minimize output. Remove str() to see full output.

#Moving Averages
ema.20 <-   EMA(SPL[,"close"], 20)
ema.20
sma.15 <-   SMA(SPL[,"close"], 15)
sma.15
sma.20 <-   SMA(SPL[,"close"], 20)
sma.20
sma.50 <-   SMA(SPL[,"close"], 50)
sma.50
vwap.10  <-  VWAP(SPL[,c("close")],SPL[,"volume"],10)
vwap.10
zlema.20 <- ZLEMA(SPL[,"close"], 10)
zlema.20
#Chaikan Money Flow
cmf <- CMF(SPL[,c("high","low","close")],SPL[,"volume"])
cmf
#Bollinger Bands
bb20 = BBands(SPL[,"close"], sd=2.0)
#MACD
macd = MACD(SPL[,"close"], nFast=12, nSlow=26, nSig=9, maType=SMA)
macd
#Relative Strength Indicator'
rsi14 = RSI(SPL[,"close"], n=14)
rsi14










# Example 7: Chaikan AD
#SPL %>%
SPL_chaikan_AD <- SPL %>%
  tq_transmute(
               mutate_fun = chaikinAD, 
               HLC = high:low:close,
               volume = volume
               )
SPL_chaikan_AD

#Chaikan AD Chart Method 1
SPL_chaikan_AD %>%
  ggplot(aes(x = date, y = close)) +
  geom_line() +                         # Plot stock price
  geom_line(aes(y = chaikinAD(high:low:close,volume), col = "SPL")) +
  coord_x_date(xlim = c(today() - weeks(12), today()),
               ylim = c(0.1, 2.0))                     # Zoom in

SPL$adjusted
SPL$close

splClose <- SPL$close[!is.na(SPL$close)]
splHigh <- SPL$high[!is.na(SPL$high)]
splLow <- SPL$low[!is.na(SPL$low)]
mean(splClose)
mean(splHigh)
mean(splLow)



bb20 = BBands(SPL[c('close')],sd=2.0)
head(bb20, n=2000)


SPL
?BBands

BBands(splClose,20,sd=2)
BBands(splHigh,splLow,splClose,20,sd=2)

bbands.HLC <- BBands( SPL[,c("high","low","close")] )
bbands.HLC <- BBands( SPL[,c(SPL$high[!is.na(SPL$high)],SPL$low[!is.na(SPL$low)],SPL$close[!is.na(SPL$close)])])
head(bbands.HLC)
bbands
bbands.HLC <- BBands( SPL[,c("high","low","close")] )

# BBands <-  function(HLC, n=20, maType, sd=2, ...) 