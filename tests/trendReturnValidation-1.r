setkey(dtSPL, "date")
setkey(trend, "startDate")
trend <- data.table(trend[dtSPL, nomatch=0][, c(1:8)])
setkey(trend, "endDate")
trend<-trend[dtSPL, nomatch=0][, c(1:8,12)]