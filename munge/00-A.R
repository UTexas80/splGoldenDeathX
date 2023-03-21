# How Do I in R?                                https://tinyurl.com/y9j67lfk ###
################################################################################
## Step 00.00 Processing Start Time - start the timer                        ###
################################################################################
start.time <- Sys.time()
log_threshold(DEBUG)
log_info('Script starting up...')
# ------------------------------------------------------------------------------
cross(20,50,100,200)
################################################################################
## Step 00.01 set data.table keys                                            ###
################################################################################
setkey(dT.entry, id)
setkey(dT.formula, id)
setkey(dT.ind, trend_id)
setkey(dT.indMetrics, trend_id)
setkey(dT.point, id)
setkey(dT.position, id)
setkey(dT.sig, id)
setkey(dT.strategy, trend_id)
setkey(dT.trade, id)
setkey(dT.trend, id)
# ------------------------------------------------------------------------------
dT.test <-  dT.trend[
            dT.strategy][
            dT.ind, allow.cartesian = T]
setkey(dT.test, i.id.1)
# ------------------------------------------------------------------------------
dT.test1 <- dT.test[
            dT.indMetrics, allow.cartesian = T]
dT.test2 <- dT.test[
            dT.sig, allow.cartesian = T]
dT.test3 <- dT.indMetrics[
            dT.ind, allow.cartesian = T][
            i.id==1,c(7,3:5)]
# ------------------------------------------------------------------------------
dt_ma_ema <- setDT(dT.test3,FALSE)
# ------------------------------------------------------------------------------
trend_name <<-
  setorder(
    dT.strategy[                                   # https://tinyurl.com/vajvn48
      dT.ind, allow.cartesian = T][
              ,c(2,5,9)][
              , tname:= paste0(abbv,tolower(i.name))], tname)[
              , id:=  .I[]]                                     # add row number
setcolorder(trend_name, c(5, 1:4))                              # column order
# ------------------------------------------------------------------------------
setkey(dT.indMetrics, "trend_id")
setkey(trend_name, "trend_id")
# ------------------------------------------------------------------------------
trend_ind <<-
  setorder(
    trend_name[
      dT.indMetrics, allow.cartesian = T][
        ,c(1:2,5,4,7:9)][
      , id:=  .I[]]
  ,tname)
trend_ind[, strategy_ind_id := rleid(tname)]         # group contiguous elements
# ------------------------------------------------------------------------------
dt_ma <- setkey(
  data.table::dcast(
    dT.ind[
      dT.indMetrics,
      allow.cartesian = T
    ], name ~ label,
    drop = FALSE
  ),
  name
)
dt_ma <- cbind(
  dt_ma,
  mapply(function(x, y) {shQuote(
    paste(x, y, sep = "."))
  }, dt_ma[, 1], dt_ma[, c(2:5)])
)
names(dt_ma)[6:length(dt_ma)] <-  colnames(dt_ma[, 2:5])
dt_ma$sig <- as.character(interaction(dt_ma[,6:9],sep=", "))
dt_ma$id <- as.numeric(row.names.data.frame(dt_ma))
dt_ma$trend_id = 1
setcolorder(dt_ma, c(length(dt_ma), 2:length(dt_ma)-1))             # column order
setkey(dt_ma,trend_id)
# ------------------------------------------------------------------------------
trend_signal <<-
    dT.sig[dt_ma][trend_name, on = "i.name"][
      , c(1:4, 14:15,19)]
trend_signal$id         <- as.numeric(row.names(trend_signal))
setkey(trend_signal, id)
names(trend_signal)[6]  <- c("ma_id")
trend_signal            <- trend_signal[dT.formula, on = "id==strategy_id"][, c(8:10,1:2,5,12,3:4,11)]
names(trend_signal)[10] <- c("strategy_name")
# ------------------------------------------------------------------------------
trend_rules             <- setkey(setDT(dT.rules),id)
# ------------------------------------------------------------------------------
class(trend_name)       <- "setup"                    # add class to trend_name
class(trend_ind)        <- "setup"                    # add class to trend_ind
# class(trend_ind)      <- "ind"                      # add class to trend_ind
class(trend_rules)      <- "rules"                    # add class to trend_rules
class(trend_signal)     <- "signal"                   # add class to trend_signal
# get_Strategy(trend_name, trend_ind, trend_signal)
# get_Strategy.setup(trend_name)
# get_Strategy.ind(trend_ind)
# get_Strategy.signal(trend_signal)
# get_Strategy.rules(trend_rules)
# ------------------------------------------------------------------------------
dt_strategy <<-
    setorder(
        dT.strategy[dT.ind, allow.cartesian = T][
#        , i.name := tolower(i.name)][
        , strategy_name:= paste0(abbv,tolower(i.name))],
        strategy_name)[
        , id:=  .I[]][
        , formula:= paste0(abbv, i.name, sep = "_")
        ]
names(dt_strategy)[8:9]  <- c("ind_id", "strategy_ind")
setkey(dt_strategy, id)
# ------------------------------------------------------------------------------
# function accept a dataframe as an argument                https://is.gd/YK6wAa
# ------------------------------------------------------------------------------
# a1 <- a2 <- a3 <- a4 <- dt_strategy
# ------------------------------------------------------------------------------
# strategy_name <- dt_strategy$strategy_name
# class(dt_strategy) <- "x0000_main"
# class(dt_strategy) <- "x0100_setup"
# class(dt_strategy) <- "x0200_init"
# class(dt_strategy) <- "x0300_ind"
# class(a4) <- "x0400_signals"
# ------------------------------------------------------------------------------
 stocks <- data.frame(
  time = as.Date('2009-01-01') + 0:9,
  X = rnorm(10, 0, 1),
  Y = rnorm(10, 0, 2),
  Z = rnorm(10, 0, 4)
)
# ------------------------------------------------------------------------------
# add class to stock
class(stocks) <- "stock"
# ------------------------------------------------------------------------------
# this has no class
# or could be a class not named stock
not_stocks <- data.frame(
    time = as.Date('2009-01-01') + 0:9,
    X = rnorm(10, 0, 1),
    Y = rnorm(10, 0, 2),
    Z = rnorm(10, 0, 4)
)
# ------------------------------------------------------------------------------
# this is like an abstract base method
getStockPlot <- function(stocks_df) {
    UseMethod("getStockPlot")
}
# ------------------------------------------------------------------------------
# this is the implementation for "stock" objects,
# you could have more for other "class" objects
getStockPlot.stock <- function(stocks_df){
    print("Plot Stocks")
}
# ------------------------------------------------------------------------------
# this captures unsupported objects
getStockPlot.default <- function(stocks_df) {
    stop("class not supported")
}
# ------------------------------------------------------------------------------
# this calls getStockPlot.stock
getStockPlot(stocks)
#> [1] "Plot Stocks"
#this calls getStockPlot.default
# getStockPlot(not_stocks)
#> Error in getStockPlot.default(not_stocks): class not supported
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
# 1st release
