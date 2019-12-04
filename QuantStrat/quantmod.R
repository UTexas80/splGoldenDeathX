
## ----echo=FALSE----------------------------------------------------------
#########################################################################
# Copyright (C) 2011-2014 Guy Yollin                                    #
# License: http://www.gnu.org/licenses/gpl.html GPL version 2 or higher #
#########################################################################

## ----include=FALSE-------------------------------------------------------
library(knitr)
opts_chunk$set(tidy=FALSE,cache=FALSE,size='scriptsize',
  fig.path='figures/',fig.show='hide',fig.keep='last',
  fig.align='center',	fig.width=7,	fig.height=5,
  message=FALSE,warning=FALSE)

## ----echo=FALSE,cache=FALSE----------------------------------------------
options(width=81,continue=" ",digits=8)


## ----eval=FALSE----------------------------------------------------------
## #
## # install these packages from CRAN (or r-forge)
## #
## install.packages("xts", dependencies=TRUE)
## install.packages("PerformanceAnalytics", dependencies=TRUE)
## #
## # Install these package from r-forge
## #
## install.packages("quantmod", repos = "http://R-Forge.R-project.org")
## install.packages("TTR", repos = "http://R-Forge.R-project.org")
## install.packages("FinancialInstrument", repos = "http://R-Forge.R-project.org")
## install.packages("blotter", repos = "http://R-Forge.R-project.org")
## install.packages("quantstrat", repos = "http://R-Forge.R-project.org")


## ----eval=FALSE----------------------------------------------------------
## getSymbols(Symbols = NULL, env = parent.frame(), src = "yahoo",
##   auto.assign = getOption('getSymbols.auto.assign',TRUE), ...)


## ----eval=FALSE----------------------------------------------------------
## getSymbols.yahoo(Symbols, env, return.class = 'xts', index.class  = 'Date',
##   from = "2007-01-01", to = Sys.Date(), ...)


## ----cache=FALSE---------------------------------------------------------
library(quantmod)


## ----results='hide'------------------------------------------------------
getSymbols("^GSPC")


## ------------------------------------------------------------------------
ls()
class(GSPC)
class(index(GSPC))
dim(GSPC)


## ----echo=FALSE----------------------------------------------------------
options(width=120)

## ----size='tiny'---------------------------------------------------------
tail(GSPC,4)
tail(Cl(GSPC),4)
tail(Ad(GSPC),4)

## ----echo=FALSE----------------------------------------------------------
options(width=81)


## ----eval=FALSE----------------------------------------------------------
## getSymbols(Symbols = NULL, env = parent.frame(), src = "yahoo",
##   auto.assign = getOption('getSymbols.auto.assign',TRUE), ...)


## ----GSPC1,cache=FALSE---------------------------------------------------
chartSeries(GSPC,subset="2014",theme="white")


## ----GSPC0,cache=FALSE,size='tiny'---------------------------------------
whiteTheme <- chartTheme("white")
names(whiteTheme)
whiteTheme$bg.col <- "white"
whiteTheme$dn.col <- "pink"
whiteTheme$up.col <- "lightgreen"
whiteTheme$border <- "lightgray"
x <- chartSeries(GSPC,subset="last 3 months",theme=whiteTheme,TA=NULL)
class(x)


## ----size='tiny'---------------------------------------------------------
myStr <- "2013-07-04"
class(myStr)
myDate <- as.Date(myStr)
class(myDate)
as.numeric(myDate)
format(myDate,"%m/%d/%y")
as.Date("110704",format="%y%m%d")


## ----size='tiny'---------------------------------------------------------
d <- Sys.time()
class(d)
unclass(d)
sapply(unclass(as.POSIXlt(d)), function(x) x)


## ----GSPC2,cache=FALSE---------------------------------------------------
chartSeries(GSPC["2014"],theme=whiteTheme,name="S&P 500")


## ----GSPC3,cache=FALSE---------------------------------------------------
chartSeries(GSPC["2013/2014"],theme=whiteTheme,name="S&P 500")


## ----GSPC4,cache=FALSE---------------------------------------------------
chartSeries(GSPC["2014-06::2014-07"],theme=whiteTheme,name="S&P 500")


## ----GSPC5,cache=FALSE---------------------------------------------------
chartSeries(GSPC["201406::"],theme=whiteTheme,name="S&P 500")


## ----size='tiny',results='hide'------------------------------------------
getSymbols("SPY",from="2000-01-01")


## ----size='tiny'---------------------------------------------------------
class(SPY)
head(SPY)
head(index(SPY))
class(index(SPY))


## ----results='hide',size='tiny'------------------------------------------
getSymbols("SBUX",index.class="POSIXct",from="2000-01-01")


## ----SBUX1,cache=FALSE,size='tiny'---------------------------------------
class(SBUX)
head(SBUX)
head(index(SBUX))
class(index(SBUX))
chartSeries(SBUX,theme=whiteTheme,minor.ticks=FALSE)


## ------------------------------------------------------------------------
(spl <- getSplits("SBUX"))
class(spl)


## ----size='tiny'---------------------------------------------------------
(div <- getDividends("SBUX"))
class(div)


## ----eval=FALSE----------------------------------------------------------
## adjustOHLC(x, adjust = c("split","dividend"), use.Adjusted = FALSE,
##  ratio = NULL, symbol.name=deparse(substitute(x)))


## ----size='tiny'---------------------------------------------------------
head(SBUX)
adj.exact <- adjustOHLC(SBUX)
head(adj.exact)


## ----SBUX2,cache=FALSE---------------------------------------------------
head(adj.exact)
adj.approx <- adjustOHLC(SBUX, use.Adjusted=TRUE)
head(adj.approx)
chartSeries(adj.exact,theme=whiteTheme,name="SBUX",minor.ticks=FALSE)


## ----size='tiny'---------------------------------------------------------
getSymbols("SBUX",index.class="POSIXct",from="2000-01-01",adjust=T)
head(SBUX)
head(adj.exact)


## ----results='hide'------------------------------------------------------
getSymbols('DTB3',src='FRED')


## ----RRF,cache=FALSE-----------------------------------------------------
first(DTB3,'1 week')
last(DTB3,'1 week')
chartSeries(DTB3,theme="white",minor.ticks=FALSE)


## ----eval=FALSE----------------------------------------------------------
## Quandl(code, type = c("raw", "ts", "zoo", "xts"), start_date, end_date,
##  transformation = c("", "diff", "rdiff", "normalize", "cumul", "rdiff_from"),
##  collapse = c("", "weekly", "monthly", "quarterly", "annual"),
##  sort = c("desc", "asc"), meta = FALSE, authcode = Quandl.auth(), ...)


## ----cache=FALSE---------------------------------------------------------
library(Quandl)


## ------------------------------------------------------------------------
cl1 = Quandl("OFDP/FUTURE_CL1",type="xts")
class(cl1)
class(index(cl1))
first(cl1)
last(cl1)


## ----CSCL1,cache=FALSE---------------------------------------------------
cl1 <- cl1[,c("Open","High","Low","Settle","Volume")]
colnames(cl1) <-  c("Open","High","Low","Close","Volume")
sum(is.na(coredata(cl1)))
sum(coredata(cl1)<0.01)
cl1[cl1 < 0.1] <- NA
cl1 <- na.approx(cl1)
chartSeries(cl1,name="Nymex Crude (front contract)",theme=chartTheme("white"))


## ----SBUX3,cache=FALSE---------------------------------------------------
b <- BBands(HLC=HLC(SBUX["2014"]), n=20, sd=2)
tail(b,10)
chartSeries(SBUX,TA='addBBands();addBBands(draw="p");addVo()',
  subset='2014',theme="white")


## ----SBUX5,cache=FALSE---------------------------------------------------
macd  <- MACD( Cl(SBUX), 12, 26, 9, maType="EMA" )
tail(macd)
chartSeries(SBUX, TA = "addMACD()",subset="2014",theme=whiteTheme)


## ----SBUX6,cache=FALSE---------------------------------------------------
rsi  <- RSI( Cl(SBUX), n = 14 )
tail(rsi)
chartSeries(SBUX, TA = "addRSI()",subset="2013",theme=whiteTheme)


## ----SBUX4,cache=FALSE---------------------------------------------------
myTheme<-chart_theme()
myTheme$col$up.col<-'lightgreen'
myTheme$col$dn.col<-'pink'
#
chart_Series(SBUX["2013"],TA='add_BBands(lwd=2)',theme=myTheme,name="SBUX")


## ----eval=FALSE----------------------------------------------------------
## strptime(x, format, tz = "")


## ----eval=FALSE----------------------------------------------------------
## xts(x = NULL, order.by = index(x), frequency = NULL,
##  unique = TRUE, tzone = Sys.getenv("TZ"), ...)


## ----size='tiny'---------------------------------------------------------
fn1 <- "GBPUSD.txt"
dat <- read.table(file=fn1,sep=",",header=T,as.is=T)
head(dat)
tm <- strptime(
  paste(dat[,"Date"], sprintf("%04d",dat[,"Time"])),
  format="%m/%d/%Y %H%M")
class(tm)
head(tm)


## ----GBPUSD1,cache=FALSE-------------------------------------------------
GBP <- xts(x=dat[,c("Open","High","Low","Close")],order.by=tm)
GBP <- GBP['2007']
first(GBP,'4 hours')
barChart(GBP,TA='addSMA(n = 7, col = "red");addSMA(n = 44, col = "blue")',
  subset='2007-12-24/2007-12-26',theme="white",name="GBPUSD")


## ----XCROSS1,cache=FALSE-------------------------------------------------
# make candle stick plot with moving averages
#
chart_Series(GBP,subset='2007-12-24/2007-12-26',theme=myTheme,name="GBPUSD",
  TA='add_SMA(n=7,col="red",lwd=2);add_SMA(n=44,col="blue",lwd=2)')
#
# find cross-over bar
#
fastMA <- SMA(Cl(GBP),n=7)
slowMA <- SMA(Cl(GBP),n=44)
co <- fastMA > slowMA
x <- which(co['2007-12-24/2007-12-26'])[1]
#
# identify cross-over bar
#
ss <- GBP['2007-12-24/2007-12-26']
add_TA(ss[x,"Low"]-0.0005,pch=17,type="p",col="red", on=1,cex=2)
#
text(x=x,y=ss[x,"Low"]-0.0005,"Crossover\nbar",pos=1)


