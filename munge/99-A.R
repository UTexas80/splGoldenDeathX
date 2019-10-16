################################################################################
## Step 99.00 Create ma table of returns
################################################################################
a <- t(data.table((as.single(lapply(lapply(xtsPrice, na.omit, xtsPrice[1, ]), tail, 1)) - as.single(lapply(lapply(xtsPrice, na.omit, xtsPrice[1, ]), head, 1))) / as.single(lapply(lapply(xtsPrice, na.omit, xtsPrice[1, ]), head, 1))))
colnames(a) <- dimnames(xtsPrice)[[2]]
rownames(a) <- 1

smaReturns <- t(data.table((as.single(lapply(lapply(xtsPriceSMA, na.omit, xtsPrice[1, ]), tail, 1)) - as.single(lapply(lapply(xtsPrice, na.omit, xtsPrice[1, ]), head, 1))) / 
                            as.single(lapply(lapply(xtsPrice, na.omit, xtsPrice[1, ]), head, 1))))
colnames(smaReturns) <- dimnames(xtsPriceSMA)[[2]]
rownames(smaReturns) <- 1
################################################################################
## Step 99.01 EMA Start / End Date
################################################################################
startDate <- data.table(
  as.Date.IDate(
    t(
      lapply(
        lapply(
          lapply(xtsPrice, na.omit, xtsPrice[1, ]),
          head, 1
        ),
        index
      )
    )
  )
)
endDate <- data.table(
  as.Date.IDate(
    t(
      lapply(
        lapply(
          lapply(xtsPrice, na.omit, xtsPrice[1, ]),
          tail, 1
        ),
        index
      )
    )
  )
)

countDate <- data.table(lapply(lapply(xtsPrice, na.omit, xtsPrice[1, ]), nrow))
################################################################################
## Step 99.02 SMA Start / End Date
################################################################################
startDateSMA <- data.table(
  as.Date.IDate(
    t(
      lapply(
        lapply(
          lapply(xtsPriceSMA, na.omit, xtsPriceSMA[1, ]),
          head, 1
        ),
        index
      )
    )
  )
)
endDateSMA <- data.table(
  as.Date.IDate(
    t(
      lapply(
        lapply(
          lapply(xtsPriceSMA, na.omit, xtsPriceSMA[1, ]),
          tail, 1
        ),
        index
      )
    )
  )
)

countDateSMA <- data.table(lapply(lapply(xtsPriceSMA, na.omit, xtsPriceSMA[1, ]), nrow)) 
################################################################################
## Step 99.03 transpose EMA 
################################################################################
aa <- t(a)
################################################################################
aa <- data.table(aa, keep.rownames = TRUE)
aa <- cbind(aa, startDate, endDate, countDate)
################################################################################
## Reorder Columns
aa <- aa[, c(1, 3:4, 5, 2)]
################################################################################
# Rename Columns ---------------------------------------------------------------
names(aa)[1:5] <- c("subcatName", "startDate", "endDate", "tradeDays", "return")
trend <- aa[, tradeDays := as.integer(tradeDays)] ### rename dataframe and convert column from list to integer
trend <- trend[, catName := substr(aa$subcatName, 1, nchar(aa$subcatName) - 3)] ### add category name sans number(s)
trend[, indicator := "EMA"]
trend <- select(trend, catName, everything()) ### move last column to first
################################################################################
## Step 99.04 transpose SMA 
################################################################################
trendSMA <- t(smaReturns)
################################################################################
trendSMA <- data.table(trendSMA, keep.rownames = TRUE)
trendSMA <- cbind(trendSMA, startDate, endDate, countDate)
################################################################################
## Reorder Columns -------------------------------------------------------------
trendSMA <- trendSMA[, c(1, 3:4, 5, 2)]
################################################################################
# Rename Columns --------------------------------------------------------------
names(trendSMA)[1:5] <- c("subcatName", "startDate", "endDate", "tradeDays", "return")
trendSMA <- trendSMA[, tradeDays := as.integer(tradeDays)]                   ### rename dataframe and convert column from list to integer
trendSMA <- trendSMA[, catName := substr(trendSMA$subcatName, 1, 
    nchar(trendSMA$subcatName) - 3)]                                         ### add category name sans number(s)
trendSMA[, indicator := "SMA"]
trendSMA <- select(trendSMA, catName, everything())                          ### move last column to first
################################################################################
## Step 99.05  Performance Analytics Boxplot(s)
################################################################################
chart.Boxplot(data.table(a) %>% select(starts_with("Golden")))
chart.Boxplot(data.table(a) %>% select(starts_with("Death")))
chart.Boxplot(data.table(a) %>% select(starts_with("n")))
viz.BoxplotN <- chart.Boxplot(data.table(a) %>% select(starts_with("n")))
################################################################################
## Quantmod: Calculate Returns                                               ### https://tinyurl.com/yxs9km73
################################################################################
retByMonth <- monthlyReturn(SPL.AX) 
spl.max <- rollapply(data = SPL.AX, width = 5, FUN = max, fill = NA, partial = TRUE, align = "center")
(spl.max.month <- as.xts(hydroTSM::daily2monthly(SPL.AX, FUN = max)))
spl.max.annual <- as.xts((daily2annual(spl.max, FUN = max, na.rm = TRUE)))
# m                <- daily2monthly(SPL.AX, FUN=mean, na.rm=TRUE)              # https://tinyurl.com/yxgrlx4l
# splByMonth       <-monthlyfunction(m, FUN=median, na.rm=TRUE)                # https://tinyurl.com/y4g8hzvr

monthlyMean <- monthlyfunction(retByMonth, mean, na.rm = TRUE)
monthlyMedian <- monthlyfunction(retByMonth, median, na.rm = TRUE)
monthlyMin <- monthlyfunction(retByMonth, min, na.rm = TRUE)
monthlyMax <- monthlyfunction(retByMonth, max, na.rm = TRUE)
x.subset <- index(SPL.AX [1:20])
SPL.AX[x.subset]
################################################################################
## .xts Dynamic Time-Series using a parameter  https://tinyurl.com/y3h3jbt7  ###
################################################################################

################################################################################
## Step 99.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-06-19")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
#  1st release
