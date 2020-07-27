
# helper functions
pastePerc <- function(x) {return(paste0(comma(x),"%"))}
rowGsub <- function(x) {x <- gsub("NA%", "NA", x);x}

calendarReturnTable <- function(rets, digits = 3, percent = FALSE) {

  # get maximum drawdown using daily returns
  dds <- apply.yearly(rets, maxDrawdown)

  # get monthly returns
  rets <- apply.monthly(rets, Return.cumulative)

  # convert to data frame with year, month, and monthly return value
  dfRets <- cbind(year(index(rets)), month(index(rets)), coredata(rets))

  # convert to data table and reshape into year x month table
  dfRets <- data.frame(dfRets)
  colnames(dfRets) <- c("Year", "Month", "Value")
  monthNames <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
  for(i in 1:length(monthNames)) {
    dfRets$Month[dfRets$Month==i] <- monthNames[i]
  }
  dfRets <- data.table(dfRets)
  dfRets <- data.table::dcast(dfRets, Year~Month)

  # create row names and rearrange table in month order
  dfRets <- data.frame(dfRets)
  yearNames <- dfRets$Year
  rownames(dfRets) <- yearNames; dfRets$Year <- NULL
  dfRets <- dfRets[,monthNames]

  # append yearly returns and drawdowns
  yearlyRets <- apply.yearly(rets, Return.cumulative)
  dfRets$Annual <- yearlyRets
  dfRets$DD <- dds

  # convert to percentage
  if(percent) {
    dfRets <- dfRets * 100
  }

  # round for formatting
  dfRets <- apply(dfRets, 2, round, digits)

  # paste the percentage sign
  if(percent) {
    dfRets <- apply(dfRets, 2, pastePerc)
    dfRets <- apply(dfRets, 2, rowGsub)
    dfRets <- data.frame(dfRets)
    rownames(dfRets) <- yearNames
  }
  return(dfRets)
}
