################################################################################
## Step 02.05.00 Processing Chaikan Money Flow using TTR Package             ###
## cmf is calculated by dividing the sum of the Chaikin                      ###
## Accumulation / Distribution line over ## the past n periods by the sum of ###
## the volume over the past n periods.                                       ###
# ------------------------------------------------------------------------------
## When CMF is above/below +/- 0.25 it is a bullish/bearish signal.          ###
## If Chaikin Money Flow remains below zero while the price is rising,       ###
## it indicates a probable reversal.                                         ###
################################################################################
cmf    <- CMF(SPL.AX[, c("SPL.AX.High", "SPL.AX.Low", "SPL.AX.Close")], 
           SPL.AX[, "SPL.AX.Volume"], n = 21)
cmfSPL <- merge(SPL.AX,cmf)
# -----------------------------------------------------------------------------
# chaikinAD: Chaikin A/D measure of the money flowing into or out of a security 
# https://is.gd/vJm0X4
# -----------------------------------------------------------------------------
cmfAD <- chaikinAD(SPL.AX[, c("SPL.AX.High", "SPL.AX.Low", "SPL.AX.Close")], 
                SPL.AX[, "SPL.AX.Volume"])
# -----------------------------------------------------------------------------
# chaikinVolatility measures the rate of change of the security's trading range 
# https://is.gd/sir6vg
# -----------------------------------------------------------------------------
cmfVolatility <- chaikinVolatility(SPL.AX[,c("SPL.AX.High","SPL.AX.Low")])
################################################################################
## Step 02.05.01 Charting Chaikan Money Flow using quantmod Package          ###
## Year 2016 To Present                                                      ###
################################################################################
chartSeries(SPL.AX, theme = 'black',subset='2017::', 
            TA = "addBBands();addVo();addCMF();addZLEMA()")  
################################################################################
## Step 02.05.031 My old school falkulations to rank the CMF                 ###
tblVolumeChaikinMF           <- data.table(SPL$date,cmf)
colnames(tblVolumeChaikinMF) <- c("date", "cmf")
cmfRank <-data.table(frank(tblVolumeChaikinMF, -cmf, date, ties.method = "max"))
################################################################################
## Step 02.05.99: VERSION HISTORY                                            ###
################################################################################
a02.05.version <- "1.0.0"
a02.05.ModDate <- as.Date("2019-11-11")
# ------------------------------------------------------------------------------
# 2019.11.11 - v.1.0.0
# 1st release
