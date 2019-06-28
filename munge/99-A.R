# reprex
if(!require(data.table)) {
install.packages("data.table"); require(data.table)}
if(!require(lubridate)) {
install.packages("lubridate"); require(lubridate)}
if(!require(quantmod)) {
install.packages("quantmod"); require(quantmod)}
if(!require(xts)) {
install.packages("xts"); require(xts)}


x<-data.table::data.table(
        date = c("2009-01-01", "2009-01-04", "2009-01-05", "2009-01-06",
                 "2009-01-07", "2009-01-08", "2009-01-11", "2009-01-12",
                 "2009-01-13", "2009-01-14", "2009-01-15", "2009-01-18", "2009-01-19",
                 "2009-01-20", "2009-01-21", "2009-01-22", "2009-01-26",
                 "2009-01-27", "2009-01-28", "2009-01-29", "2009-02-01", "2009-02-02",
                 "2009-02-03", "2009-02-04", "2009-02-05", "2009-02-08",
                 "2009-02-09", "2009-02-10", "2009-02-11", "2009-02-12", "2009-02-15",
                 "2009-02-16", "2009-02-17", "2009-02-18", "2009-02-19",
                 "2009-02-22", "2009-02-23", "2009-02-24", "2009-02-25", "2009-02-26",
                 "2009-03-01", "2009-03-02", "2009-03-03", "2009-03-04", "2009-03-05",
                 "2009-03-08", "2009-03-09", "2009-03-10", "2009-03-11",
                 "2009-03-12", "2009-03-15", "2009-03-16", "2009-03-17", "2009-03-18",
                 "2009-03-19", "2009-03-22", "2009-03-23", "2009-03-24",
                 "2009-03-25", "2009-03-26", "2009-03-29", "2009-03-30", "2009-03-31",
                 "2009-04-01", "2009-04-02"),
           A = c(0.195, 0.195, 0.19, 0.185, 0.185, 0.19, 0.2, NA, NA, NA, NA,
                 NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                 NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                 NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                 NA, NA, NA, NA, NA, NA, NA),
           B = c(NA, NA, NA, NA, NA, NA, NA, 0.2, 0.21, 0.22, 0.23, 0.24,
                 0.185, 0.185, 0.2, 0.2, 0.18, NA, NA, NA, NA, NA, NA, NA, NA,
                 NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                 NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                 NA, NA, NA, NA, NA, NA, NA, NA),
           C = c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,
                 NA, NA, 0.18, 0.165, 0.17, 0.18, 0.175, 0.21, 0.2, 0.19, 0.19,
                 0.2, 0.2, 0.2, 0.185, 0.19, 0.195, 0.19, 0.185, 0.16, 0.17,
                 0.17, 0.175, 0.19, 0.19, 0.185, 0.19, 0.18, 0.185, 0.18, 0.18,
                 0.165, 0.18, 0.185, 0.185, 0.185, 0.17, 0.165, 0.17, 0.19, 0.19,
                 0.19, 0.22, 0.25, 0.25, 0.285, 0.265, 0.29, 0.29, 0.3)
)


setkey(x,"date")
x$date<-as_date(x$date)
x<-as.xts(x)
ReturnsA<-allReturns(x[,"A"])
ReturnsB<-allReturns(x[,"B"])
ReturnsC<-allReturns(x[,"C"])


ReturnsTot <- data.table(returnsTotA = 2.5641, returnsTotA = -10.0,returnsTotA = 66.6667)
na.omit(x$B)[1,]
head(na.omit(x$B),1)
tail(na.omit(x$B),1)
(as.single(tail(na.omit(x$C),1))-as.single(na.omit(x$C)[1,])) / as.single(na.omit(x$C)[1,])

lapply(lapply(x,  na.omit, x[1,]), head, 1)
lapply(lapply(x,  na.omit, x[1,]), tail, 1)
# lapply(lapply(x,  na.omit, x[1,]), nrow)

startDateX<- data.table(
                  as.Date.IDate(
                        t(
                              lapply(
                                    lapply(
                                          lapply(x,  na.omit, x[1,]), 
                                    head, 1), 
                              index)
                        )
                  )
            )
endDateX<-   data.table(
                  as.Date.IDate(
                        t(
                              lapply(
                                    lapply(
                                          lapply(x,  na.omit, x[1,]), 
                                    tail, 1), 
                              index)
                        )
                  )
            )


z<-t(data.table((as.single(lapply(lapply(x,  na.omit, x[1,]), tail, 1))-as.single(lapply(lapply(x,  na.omit, x[1,]), head, 1))) / as.single(lapply(lapply(x,  na.omit, x[1,]), head, 1))))
colnames(z)<-dimnames(x)[[2]]
rownames(z)<-1

zz<-t(z)
# zz<-rownames(zz)<-dimnames(x)[[2]]
zz<-data.table(zz, keep.rownames = TRUE)
zz<-cbind(zz, startDateX,endDateX)
################################################################################
## Reorder Columns
zz <- zz[, c(1,3:4,2)]                                                          
################################################################################
## Rename Columns
names(zz)[1:4]<-c("catName", "startDate", "endDate", "return")

################################################################################
## Create a table of returns
################################################################################
a<-t(data.table((as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), tail, 1))-as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))) / as.single(lapply(lapply(xtsPrice,  na.omit, xtsPrice[1,]), head, 1))))
colnames(a)<-dimnames(xtsPrice)[[2]]
rownames(a)<-1

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
aa <- aa[, c(1,3:4,5,2)]                                                          
################################################################################
## Rename Columns
names(aa)[1:5]<-c("catName", "startDate", "endDate", "count", "return")  


################################################################################
## dtEMA rename columns
names(dtEMA)[8:12]<-c("catName", "sequence", "catNum","subCatNum", "catKey")    # didn't like the column names and didn't want to go through lots of code to modify.    
#dtEMA[,key :=paste0(sequence,paste0(sprintf("%02d",catNum)))]                  # Concatenate and zero fill two columns                     https://tinyurl.com/yxmv734u
################################################################################
## Concatenate and zero fill three columns                                      https://tinyurl.com/yxmv734u
## Convert Category Number to letters                                           https://stackoverflow.com/questions/37239715/convert-letters-to-numbers
################################################################################
dtEMA<-dtEMA[,key :=paste0(sprintf("%03d",sequence),paste0(LETTERS[catNum]), paste0(sprintf("%03d",subCatNum)))]

################################################################################
## Performance Analytics Boxplot(s)
################################################################################
chart.Boxplot(data.table(a) %>% select(starts_with("Golden"), -ends_with("17")))
chart.Boxplot(data.table(a) %>% select(starts_with("Death")))
chart.Boxplot(data.table(a) %>% select(starts_with("n")))


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