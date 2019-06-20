################################################################################
## Step 1: Get Prices ###
################################################################################
SPL <- tq_get("SPL.AX")                                                         # Get TidyQuant Stock Prices
SPL<-SPL[complete.cases(SPL),]                                                  # Delete NA
################################################################################https://tinyurl.com/yy2mkklj
## Step 1a: xts Prices ###                                                      https://tinyurl.com/yyyf4qqw
################################################################################
xtsPrices <- 
  getSymbols(symbols, src = 'yahoo', 
             auto.assign = TRUE, 
             warnings = FALSE) %>% 
  map(~Ad(get(.))) %>% 
  reduce(merge) %>%
  `colnames<-`(symbols)
SPL.AX <- 
    SPL.AX %>%
    na.omit()                                                                   # Replace missing values (NA)                               https://tinyurl.com/y5etxh8x

################################################################################
## xts EMA / SMA ###                                                            https://tinyurl.com/yy8ozaa2
################################################################################

ema005<-EMA( Cl( SPL.AX ), 5 )
ema010<-EMA( Cl( SPL.AX ), 10 )
ema020<-EMA( Cl( SPL.AX ), 20 )
ema050<-EMA( Cl( SPL.AX ), 50 )
ema100<-EMA( Cl( SPL.AX ), 100 )
ema200<-EMA( Cl( SPL.AX ), 200 )

sma005<-SMA( Cl( SPL.AX ), 5 )
sma010<-SMA( Cl( SPL.AX ), 10 )
sma020<-SMA( Cl( SPL.AX ), 20 )
sma050<-SMA( Cl( SPL.AX ), 50 )
sma100<-SMA( Cl( SPL.AX ), 100 )
sma200<-SMA( Cl( SPL.AX ), 200 )

xtsEMA<-merge(merge(merge(merge(merge(ema005,ema010, join='inner'),ema020, join='inner'),ema050, join='inner'),ema100, join='inner'),ema200, join='inner')

################################################################################
## rename columns ###                                                           https://tinyurl.com/y6fwyvwk
################################################################################
names(xtsEMA) <- c("ema005", "ema010", "ema020", "ema050", "ema100", "ema200")  # Renaming the First n Columns Using Base R
xtsEMA_Months<- nmonths(xtsEMA)

dtEMA<-as.data.table(xtsEMA)


dtEMA  <- dtEMA %>%
    mutate(
        event = case_when(
            ema020 > ema050 & ema050 > ema100 & ema100 > ema200 ~ "GoldenX", 
            ema200 > ema100 & ema100 > ema050  & ema050 > ema020 ~ "DeathX",
            TRUE                      ~ "n"
        )
    )
dtEMA<-data.table(dtEMA)
################################################################################
## prefix with 'grp' perform a group by with elements that are contiguous ###   https://tinyurl.com/yytlybll
################################################################################
dtEMA$subgroup <-rleid(dtEMA$event)
dtEMA<-data.table(dtEMA)
dtEMA[order(event), group := rleid(event)]  
dtEMA<-data.table(dtEMA)

dtEMA<-dtEMA[order(group, subgroup)][event ==  'n', eventGroup := rleid(subgroup)]
dtEMA<-dtEMA[order(group, subgroup)][event ==  'DeathX', eventGroup := rleid(subgroup)]
dtEMA<-dtEMA[order(group, subgroup)][event ==  'GoldenX', eventGroup := rleid(subgroup)]
################################################################################
# z<-dtEMA[order(date)][, .N, by=rleid(event)]
#dtEMA[, grp := .GRP, by=c("event","subgroup")] 
## This replaces the previous three statements ###                              https://tinyurl.com/y4g4jlzn
# dtEMA<-dtEMA[order(date)][, eventGroupX := rleid(subgroup, by=group, subgroup)]
# dtEMA<-dtEMA[order(group, subgroup)][, eventGroupX := rleid(subgroup, by=group, subgroup)]
# dtEMA<-dtEMA[order(group,subgroup)][, eventGroupX := rleid(subgroup, by= event)]
################################################################################
# dtEMA[,new:=paste0(event,eventGroup)]                                         # Concatenate two columns                                   https://tinyurl.com/y5b69lky
dtEMA[,eventGroupNum :=paste0(event,paste0(sprintf("%03d",eventGroup)))]        # Concatenate and zero fill two columns                     https://tinyurl.com/yxmv734u
################################################################################
## Exponential Moving Average - EMA calculates an exponentially-weighted mean, ## giving more weight to recent observations ###
# Simple Moving Average - SMA calculates the arithmetic mean of the series over the past n observations.
################################################################################
ema.005 <-EMA(SPL$close, 5)                                                     
sma.005 <-SMA(SPL$close, 5)                                                     
ema.010 <-EMA(SPL$close, 10)                                                    
sma.010 <-SMA(SPL$close, 10)                                                    
sma.015 <-SMA(SPL$close, 15)                                                    
ema.020 <-EMA(SPL$close, 20)                                                    
sma.020 <-SMA(SPL$close, 20)                                                    
ema.050 <-EMA(SPL$close, 50)                                                    
sma.050 <-SMA(SPL$close, 50)                                                    
ema.100 <-EMA(SPL$close, 100)                                                   
sma.100 <-SMA(SPL$close, 100)                                                   
ema.200 <-EMA(SPL$close, 200)                                                   
sma.200 <-SMA(SPL$close, 200)                                                   

goldenX<-ema020 > ema050 & ema050 > ema100 & ema100 > ema200
deathX<-ema200 > ema100 & ema100 > ema050 & ema050 > ema020


dtGoldenX<-as.data.table(goldenX)
dtGoldenX<- dtGoldenX[EMA==TRUE]
################################################################################
## rename columns ###                                                           https://tinyurl.com/y6fwyvwk
################################################################################
names(dtEMA)[1]<-"date"                                                         # rename column name by index
names(dtGoldenX)[1]<-"date"                                                     # rename column name by index
setkey(dtGoldenX,"date")

dtGoldenX %>% mutate_if(is.logical, as.character) -> dtGoldenX                  # convert column from logical to character; xts doesn't recognize TRUE/FALSE
goldenX.xts <- xts(dtGoldenX[,-1], order.by=dtGoldenX[,1])                      # converting data table to xts                              https://tinyurl.com/y66xbu3h
priceGoldenX.xts <-SPL.AX[index(goldenX.xts)]                                       
dtGoldenX<-data.table(dtGoldenX)
dtGoldenX[EMA == "TRUE", EMA := "goldenX"]
################################################################################
## xtsMonthly Returns in the xts World ###                                      https://tinyurl.com/yyyf4qqw
################################################################################
prices_monthly <- to.monthly(xtsPrices, indexAt = "lastof", OHLC = FALSE)    
asset_returns_xts <- na.omit(Return.calculate(prices_monthly, method = "log"))


#   SPL.AX<-SPL.AX[, colSums(is.na(SPL.AX)) < nrow(SPL.AX)]                     # Removing NA columns in xts                                https://tinyurl.com/y4j4ocqg

#   tsPrices <- getSymbols(symbols,src='yahoo',
#             auto.assign = TRUE,
#             return.class='ts',
#             warnings = FALSE) %>% 
#   map(~Ad(get(.))) %>% 
#   reduce(merge) %>%
#   `colnames<-`(symbols)

# tsPrices  <- getSymbols('SPL.AX',src='yahoo',return.class='ts')
# zooPrices <- getSymbols('SPL.AX',src='yahoo',return.class='zoo')

aud_usd <- getSymbols("AUD=X",src="yahoo", auto.assign = FALSE) 
aud_usd<-aud_usd[complete.cases(aud_usd),]
usd_aud <- 1/aud_usd

dtSPL<-as.data.table(SPL.AX, keep.rownames = TRUE)
names(dtSPL)[1]<-"date"
setkey(dtSPL,"date")
setkey(dtEMA,"date")
dtSPL<-dtSPL[dtEMA][,c(1:2,18)]

xtsPrice<-as.xts.data.table(dcast.data.table(dtSPL, formula = date~eventGroupNum, value.var = "SPL.AX.Open"))
cumReturn<-apply(X = xtsPrice, 2, FUN = function(Z) Return.cumulative(as.numeric(Z), geometric = TRUE))                                     # https://tinyurl.com/y2d2ve83
