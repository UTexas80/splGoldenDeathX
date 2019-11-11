setkey(dtSPL, "date")
setkey(trend, "startDate")
trend <- data.table(trend[dtSPL, nomatch=0][, c(1:8)])
setkey(trend, "endDate")
trend<-trend[dtSPL, nomatch=0][, c(1:8,12)]


apply(X = xtsPrice, 2, FUN = function(Z) Delt(na.omit(as.numeric(Z))))
apply(X = xtsPrice, 2, FUN = function(Z) 

dtReturns <-data.table(apply(X = xtsPrice, 2, FUN = function(Z) na.omit(Delt(na.omit(as.numeric(Z)),k=length(na.omit(Z))-1))))


dfReturns <- data.frame(matrix(unlist(apply(X = xtsPrice, 2, 
  FUN = function(Z) na.omit(Delt(na.omit(as.numeric(Z)), k = length(na.omit(Z)) - 
    1)))), nrow = length(apply(X = xtsPrice, 2, FUN = function(Z) na.omit(Delt(na.omit(as.numeric(Z)), 
  k = length(na.omit(Z)) - 1))))), byrow = T)


dtReturns <- data.table(dfReturns)[,1]


head(trendSummaryGroup[indicator=='EMA'][,c(4:5)],-1)
tail(trendSummaryGroup[indicator=='EMA'][,c(4:5)],1)
colSums(na.omit(trendSummaryGroup)[indicator=='EMA'][,c(4:5)])
na.omit(trendSummaryGroup)[indicator=='EMA'][,c(4:5)])/colSums(na.omit(trendSummaryGroup)[indicator=='EMA'][,c(4:5)]

# Percentages per value using a data;.table
# https://tinyurl.com/y52o5car
# How to sum a variable by group 
# https://tinyurl.com/yyfsfdgt
# Aggregate using data.table     
#  https://tinyurl.com/y2mlquvh
# https://stackoverflow.com/questions/38530512/barplot-frequency-percentages-per-group

dt[ , per := prop.table(`sum(count)`) , by = "x"]