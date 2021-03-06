################################################################################
## Create a table of returns
################################################################################
a<-t(data.table((as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), tail, 1))-as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))) / as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))))
colnames(a)<-dimnames(xtsPrice)[[2]]
rownames(a)<-1
################################################################################
## Save a table of returns .rds file
################################################################################
saveRDS(a, file="./rds/returnsByCategory.rds")
################################################################################
## Start / End Date
################################################################################
startDate<- data.table(
                  as.Date.IDate(
                        t(
                              lapply(
                                    lapply(
                                          lapply(xtsPrice,  na.omit, xtsPrice[1,]), 
                                    head, 1), 
                              index)
                        )
                  )
            )
endDate<-   data.table(
                  as.Date.IDate(
                        t(
                              lapply(
                                    lapply(
                                          lapply(xtsPrice,  na.omit, xtsPrice[1,]), 
                                    tail, 1), 
                              index)
                        )
                  )
            )

countDate <- data.table(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), nrow))
################################################################################
## transpose
aa<-t(a)
################################################################################
aa<-data.table(aa, keep.rownames = TRUE)
aa<-cbind(aa, startDate,endDate, countDate)
################################################################################
## Reorder Columns
# aa <- aa[, c(1,3:4,5,2)]
################################################################################
## Rename Columns
# names(aa)[1:5]<-c("catName", "startDate", "endDate", "count", "return")
names(aa)[1:5]<-c("catName", "return")

################################################################################
## Save a table of returns .rds file
################################################################################
saveRDS(aa, file="./rds/trend.rds")
################################################################################
## dtEMA rename columns
names(dtEMA)[3] <- c("ema010")
names(dtEMA)[8:12]<-c( "catName", "sequence", "catNum","subCatNum", "catKey")           # didn't like the column names and didn't want to go through lots of code to modify.    
#dtEMA[,key :=paste0(sequence,paste0(sprintf("%02d",catNum)))]                  # Concatenate and zero fill two columns                     https://tinyurl.com/yxmv734u
################################################################################
## Concatenate and zero fill three columns                                      https://tinyurl.com/yxmv734u
## Convert Category Number to letters                                           https://stackoverflow.com/questions/37239715/convert-letters-to-numbers
################################################################################
dtEMA<-dtEMA[,key :=paste0(sprintf("%03d",sequence),paste0(LETTERS[catNum]), paste0(sprintf("%03d",subCatNum)))]
saveRDS(dtEMA, file="./rds/dtEMA.rds")
################################################################################
## Performance Analytics Boxplot(s)
################################################################################
chart.Boxplot(data.table(a) %>% select(starts_with("Golden"), -ends_with("17")))
chart.Boxplot(data.table(a) %>% select(starts_with("Death")))
viz.BoxplotN <- chart.Boxplot(data.table(a) %>% select(starts_with("n")))

################################################################################
## Save a boxplot .rds file
################################################################################
saveRDS(viz.BoxplotN, file="./rds/viz.BoxplotN.rds")

retByMonth<-monthlyReturn(SPL.AX)                                               # https://tinyurl.com/yxs9km73
spl.max <- rollapply(data=SPL.AX, width=5, FUN=max, fill=NA, partial= TRUE, align="center")
( spl.max.month <- as.xts(hydroTSM::daily2monthly(SPL.AX, FUN=max) ))

spl.max.annual <- as.xts((daily2annual(spl.max, FUN=max, na.rm=TRUE)))
# m <- daily2monthly(SPL.AX, FUN=mean, na.rm=TRUE)                                # https://tinyurl.com/yxgrlx4l
# splByMonth<-monthlyfunction(m, FUN=median, na.rm=TRUE)                          # https://tinyurl.com/y4g8hzvr

monthlyMean<-monthlyfunction(retByMonth, mean, na.rm = TRUE)
monthlyMedian<-monthlyfunction(retByMonth, median, na.rm = TRUE)
monthlyMin<-monthlyfunction(retByMonth, min, na.rm = TRUE)
monthlyMax<-monthlyfunction(retByMonth, max, na.rm = TRUE)

x.subset <-index(SPL.AX [1:20])
SPL.AX[x.subset]

################################################################################
## .xts Dynamic Time-Series using a parameter                                   #https://tinyurl.com/y3h3jbt7
################################################################################
times = c(as.POSIXct("2012-11-03 09:45:00 IST"),
          as.POSIXct("2012-11-05 09:45:00 IST"))
#create an xts object:
xts.obj = xts(c(1,2),order.by = times)
#filter with these dates:
start.date = as.POSIXct("2012-11-03")
end.date = as.POSIXct("2012-11-04")
################################################################################
xts.obj[paste(start.date,end.date,sep="::")]
xts.obj[seq(start.date,end.date,by=60)][,1]
################################################################################
starting.quarter<-"200101"
ending.quarter<-"201702"
spl_price_by_qtr<-SPL.AX[paste(starting.quarter,ending.quarter,sep="/")]
################################################################################
# By using an index that is the logical AND of two vectors
xts.obj[start.date <= index(xts.obj) & index(xts.obj) <= end.date]

################################################################################ http://jkunst.com/highcharter/highstock.html#a-more-interesting-example
xSPL <- adjustOHLC(SPL.AX)
xSPL.SMA.10 <- SMA(Cl(xSPL), n = 5)
xSPL.SMA.200 <- SMA(Cl(xSPL), n = 100)
xSPL.RSI.14 <- RSI(Cl(xSPL))
xSPL.RSI.SellLevel <- xts(rep(70, NROW(xSPL)), index(xSPL))
xSPL.RSI.BuyLevel <- xts(rep(30, NROW(xSPL)), index(xSPL))

dailyRet<-periodReturn(SPL.AX[,6], period = 'daily') * 100  
gret <- 1 + dailyRet
fv <- cumprod(gret)

ar<-annualReturn(SPL.AX)