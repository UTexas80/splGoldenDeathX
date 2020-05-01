# Example preprocessing script.
# How Do I in R?                                https://tinyurl.com/y9j67lfk ###
############################################### https://tinyurl.com/yddh54gn ###
## checkpoint ## or any date in YYYY-MM-DD format after 2014-09-17 
## checkpoint("2015-01-15") 
################################################################################
## Step 00.00 Processing Start Time - start the timer                        ###
################################################################################
start.time <- Sys.time()
cross(20,50,100,200)
################################################################################
## Step 00.01 set data.table keys                                            ###
################################################################################
setkey(dT.formula, id)
setkey(dT.ind, trend_id)
setkey(dT.indMetrics, trend_id)
setkey(dT.sig, id)
setkey(dT.strategy, trend_id)
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
              ,c(2,5,8)][
              , tname:= paste0(abbv,i.name)], tname)[
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
trend_ind[, strategy_ind_id := rleid(tname)]          # group contiguous elements
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
names(dt_ma)[6:len(dt_ma)] <-  colnames(dt_ma[, 2:5])
dt_ma$sig <- as.character(interaction(dt_ma[,6:9],sep=", "))
dt_ma$id <- as.numeric(row.names.data.frame(dt_ma))
dt_ma$trend_id = 1
setcolorder(dt_ma, c(len(dt_ma), 2:len(dt_ma)-1))                 # column order
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
class(trend_name)       <- "setup"                     # add class to trend_name
class(trend_ind)        <- "setup"                     # add class to trend_name
class(trend_rules)      <- "setup"                     # add class to trend_name
class(trend_signal)     <- "setup"                     # add class to trend_name
# get_Strategy(trend_name, trend_ind, trend_signal)
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
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
# 1st release
