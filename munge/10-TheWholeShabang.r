# ------------------------------------------------------------------------------
# TTR Processing
# ------------------------------------------------------------------------------
ad              <- chaikinAD(SPL[,c("high","low","close")], SPL[,"volume"])     # Chaikin Accumulation / Distribution Index
adx             <- ADX(SPL[,c("high","low","close")])                           # Welles Wilder’s Directional Movement Index
aroon           <- aroon(SPL[,c("high","low")],n=20)                            # Aroon Indicator
atr             <- ATR(SPL[,c("high","low","close")],n=14)                      # Average True Range Indicator
# ------------------------------------------------------------------------------
# Bollinger Bands Start
# ------------------------------------------------------------------------------
bb.20           <- BBands(SPL$close,20,sd=2,maType=EMA)                         # BBands - 20 Day EMA
disp            <- Delt(bb.20[,"dn"],bb.20[,"up"])                              # Create Dispersion Column
dispDiff        <- Delt(disp)                                                   # Create Daily Dispersion Difference Pct Column
bb_20_disp_diff <- cbind(SPL.AX, bb.20,disp, dispDiff)[,c(7:12)]
dt_bb20_disp <- data.table(bb_20_disp_diff, keep.rownames = TRUE)
# ------------------------------------------------------------------------------
# Bollinger Bands End
# ------------------------------------------------------------------------------
cmf             <- CMF(SPL[,c("high","low","close")],SPL[,"volume"])            # Chaikan Money Flow
cVol            <- chaikinVolatility(SPL[,c("high","low")],20,maType=EMA)       # Chaikan Volatility
clv             <- CLV(SPL[,c("high","low","close")])                           # Close Location Value
dc              <- DonchianChannel(SPL[,c("high","low")])                       # Donchian Channel
dvi             <- DVI(SPL$close)                                               # DV Intermediate Oscillator - The DV Intermediate oscillator (DVI) is a very smooth momentum oscillator that can also be used as a trend indicator.
# emv           <- EMV(SPL[,c("high","low")],SPL[,"volume"])                    # Arms’ Ease of Movement Value
gmma            <-GMMA(SPL[,c("close")])                                        # Guppy Multiple Moving Averages
macd            <-MACD(SPL[,c("close")], 12, 26, 9, maType="EMA")               # Moving Average Convergence/Divergence (MACD)
mfi             <- MFI(SPL[,c("high","low","close")],SPL[,"volume"])            # Money Flow Index
# ------------------------------------------------------------------------------
# Momentum Function
# ------------------------------------------------------------------------------
cci             <- CCI(SPL[,c("high","low","close")])                           # Commodity Channel Index
cmo             <- CMO(SPL[,c("close")])                                        # Chande Momentum Oscillator
mom             <- momentum(SPL[,c("close")])                                   # Momentum Indicator
momDPOprice     <- DPO(SPL$close)                                               # De-Trended Price Oscillator Momentum Indicator
momDPOvolume    <- DPO(SPL$volume)                                              # De-Trended Volume Oscillator Momentum Indicator
roc             <- ROC(SPL[,c("close")])                                        # Rate of Change Indicator
rsi             <- RSI(SPL[,c("close")], 14, maType="WMA",SPL[,"volume"])       # Relative Strength Indicator - 14 days Weighted Moving Average
stoch           <- stoch(SPL[,c("high","low","close")])                         # Stochastic Oscillator / Stochastic Momentum Index
wpr             <- WPR(SPL[,c("high","low","close")], 14)                       # William's %R Indicator
obv             <- OBV(SPL$close, SPL$volume )                                  # On Balance Volume
pbands          <- PBands(SPL[,c("close")])                                     # PBands
rpr             <- runPercentRank(SPL[,c("close")], 260, FALSE, 0.5)            # Run Percent Rank
runsd           <- runSD(SPL[,c("close")], 10, TRUE, FALSE)                     # Running Standard Deviation
runWilderSum    <- wilderSum(SPL[,c("close")], 10)                              # retuns a Welles Wilder style weighted sum over a n-period moving window
tdi             <- TDI(SPL$close, n=30)                                         # Trend Detection Index
ult.osc         <- ultimateOscillator(SPL[,c("high","low","close")])            # Ultimate Oscillator
vhf.close       <- VHF(SPL$close)                                               # Vertical Horizontal Filter
vhf.hilow       <- VHF(SPL[,c("high","low","close")])                           # Vertical Horizontal Filter Hi / Low
# ------------------------------------------------------------------------------
# Volatility Tables
# ------------------------------------------------------------------------------
ohlc            <- SPL[,c("open", "high","low","close")]                        # Volatility OHLC parameter
volatilityClose <- volatility(ohlc, calc="close")                               # Volatility
# ------------------------------------------------------------------------------
# Williams Indicators
# ------------------------------------------------------------------------------
wad             <- williamsAD(SPL[,c("high","low","close")])                    # William's Williams Accumulation / Distribution 
# Moving Averages
alma.20         <- ALMA(SPL$close, 20)                                          # Arnaud Legoux moving average - ALMA inspired by Gaussian filters. Tends to put less weight on most recent observations, reducing tendency to overshoot.
dema.20         <- DEMA(SPL$close, 20)                                          # Double Exponential Moving Average
evwma.20        <- EVWMA(SPL$close, SPL$volume, 20)                             # Elastic Volume-weighted Moving Average
hma.20          <- HMA(SPL$close, 20)                                           # Hull moving average.
# ------------------------------------------------------------------------------# Volume moving average.
ma_vol_03day    <- zoo::rollmean(SPL.AX[,5], 3)
ma_vol_05day    <- zoo::rollmean(SPL.AX[,5], 5)
ma_vol_10day    <- zoo::rollmean(SPL.AX[,5], 10)
# ------------------------------------------------------------------------------
# ema.005 <-EMA(SPL$close, 5)                                                   # Exponential Moving Average - EMA calculates an exponentially-weighted mean, giving more weight to recent observations
# sma.005 <-SMA(SPL$close, 5)                                                   # Simple Moving Average - SMA calculates the arithmetic mean of the series over the past n observations.
# ema.020 <-EMA(SPL$close, 20)                                                  # Exponential Moving Average - EMA calculates an exponentially-weighted mean, giving more weight to recent observations
# sma.020 <-SMA(SPL$close, 20)                                                  # Simple Moving Average - SMA calculates the arithmetic mean of the series over the past n observations.
# ema.050 <-EMA(SPL$close, 50)                                                  # Exponential Moving Average - EMA calculates an exponentially-weighted mean, giving more weight to recent observations
# sma.050 <-SMA(SPL$close, 50)                                                  # Simple Moving Average - SMA calculates the arithmetic mean of the series over the past n observations.
# ema.100 <-EMA(SPL$close, 100)                                                 # Exponential Moving Average - EMA calculates an exponentially-weighted mean, giving more weight to recent observations
# sma.100 <-SMA(SPL$close, 100)                                                 # Simple Moving Average - SMA calculates the arithmetic mean of the series over the past n observations.
# ema.200 <-EMA(SPL$close, 200)                                                 # Exponential Moving Average - EMA calculates an exponentially-weighted mean, giving more weight to recent observations
# sma.200 <-SMA(SPL$close, 200)                                                 # Simple Moving Average - SMA calculates the arithmetic mean of the series over the past n observations.
# vma <- VMA(SPL$close, w, ratio = 1, ...)
# ------------------------------------------------------------------------------
# Forecast ARIMA
# Plotly                                                    https://is.gd/luhSgL
# Forecasting time series data                              https://is.gd/hsciok
# r prediction through r and shiny                          https://is.gd/qRjcCW
# ------------------------------------------------------------------------------
# etsPrice <- tk_xts(price())
plot(forecast(SPL.AX[,4]))
# ------------------------------------------------------------------------------
# time_srs<- SPL.AX[,4]
# arimodel<-auto.arima(time_srs) 
# arimodel
# predictionfplot_ly() %>%
#     add_trace(x = ~time(time_srs), y = ~time_srs, type = 'scatter', mode = 'markers',
#               line = list(color='rgb(0,100,80)'),
#               name = 'available_records')<-forecast(arimodel,h=24,level=c(80,95))
# ------------------------------------------------------------------------------
# p <-  
#     # add_lines(x = time(time_srs), y = time_srs,
#     #           color = I("blue"), name = "observed") %>%
#     add_ribbons(x = time(predictionf$mean), ymin = predictionf$lower[, 2], ymax = predictionf$upper[, 2],
#                 color = I('rgba(67,67,67,1)'), name = "95% confidence") %>%
#     add_ribbons(x = time(predictionf$mean), ymin = predictionf$lower[, 1], ymax = predictionf$upper[, 1],
#                 color = I('rgba(49,130,189, 1)'), name = "80% confidence") %>%
#     add_lines(x = time(predictionf$mean), y = predictionf$mean, color = I("blue"), name = "prediction",hoveron = "points") %>% 
# 
#     layout(title = "forcasting for delivery records through arima model",
#            paper_bgcolor='rgb(255,255,255)', plot_bgcolor='rgb(229,229,229)',
#            xaxis = list(title = "delivery-years",
#                         gridcolor = 'rgb(255,255,255)',
#                         showgrid = TRUE,
#                         showline = FALSE,
#                         showticklabels = TRUE,
#                         tickcolor = 'rgb(127,127,127)',
#                         ticks = 'outside',
#                         zeroline = FALSE),
#            yaxis = list(title = "delivery records (thousands)",
#                         gridcolor = 'rgb(255,255,255)',
#                         showgrid = TRUE,
#                         showline = FALSE,
#                         showticklabels = TRUE,
#                         tickcolor = 'rgb(127,127,127)',
#                         ticks = 'outside',
#                         zeroline = FALSE))
# ------------------------------------------------------------------------------
    # p
# ------------------------------------------------------------------------------
