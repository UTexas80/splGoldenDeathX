# Get Prices
symbols <- c("SPY","EFA", "IJS", "EEM","AGG")

prices <- 
  getSymbols(symbols, src = 'yahoo', 
             from = "2012-12-31", 
             to = "2017-12-31",
             auto.assign = TRUE, 
             warnings = FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`(symbols)

# To Monthly Returns in the xts World

prices_monthly <- to.monthly(prices, indexAt = "lastof", OHLC = FALSE)

asset_returns_xts <- na.omit(Return.calculate(prices_monthly, method = "log"))


# Portfolio Returns in the xts World

w <- c(0.25, 
       0.25, 
       0.20, 
       0.20, 
       0.10)

portfolio_returns_xts_rebalanced_monthly <- 
  Return.portfolio(asset_returns_xts, weights = w, rebalance_on = "months") %>%
  `colnames<-`("returns")

# Skewness in the xts world

skew_xts <-  
  skewness(portfolio_returns_xts_rebalanced_monthly$returns)


# Kurtosis in the xts World

kurt_xts <-  
 kurtosis(portfolio_returns_xts_rebalanced_monthly$returns)

# Sharpe Ratio

rfr <- .0003

sharpe_xts <- 
  SharpeRatio(portfolio_returns_xts_rebalanced_monthly, 
              Rf = rfr,
              FUN = "StdDev") %>% 
  `colnames<-`("sharpe_xts")

  
# CAPM Beta

market_returns_xts <- 
    getSymbols("SPY", 
               src = 'yahoo', 
               from = "2012-12-31", 
               to = "2017-12-31",
             auto.assign = TRUE, 
             warnings = FALSE) %>% 
    map(~Ad(get(.))) %>% 
    reduce(merge) %>%
    `colnames<-`("SPY") %>% 
    to.monthly(indexAt = "lastof", 
               OHLC = FALSE) %>% 
  Return.calculate(., 
                   method = "log") %>% 
  na.omit()