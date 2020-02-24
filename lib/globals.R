# Add any project specific configuration here.
add.config(
  apply.override = FALSE,
  currentYr = as.numeric(format(Sys.Date(), format="%y")),
  currentYr4 = as.numeric(format(Sys.Date(), format="%Y")),
  lastYr = as.numeric(format(Sys.Date(), format="%y")) - 1,
  LastYr4 = as.numeric(format(Sys.Date(), format="%Y"))-1,
  currentAY = as.numeric(paste(as.numeric(format(Sys.Date(), format="%y")) - 1, as.numeric(format(Sys.Date(), format="%y")), sep = "")),
  header = "SPL GoldenDeathX" # header in reports
)
################################################################################
# ascertain global environment to dynamically name data frames 
################################################################################
g<-globalenv()                               # https://tinyurl.com/r3yrspv   ###
################################################################################
# Repo Package: data management to build centralized metadata repository ------- https://github.com/franapoli/repo
## Check existence of directory and create if doesn't exist                     ### https://tinyurl.com/y3adrqwa
################################################################################
mainDir     <- (".")
subDir      <- ("repo")
rp_path     <- file.path(mainDir, subDir)
# ------------------------------------------------------------------------------
# Check this out ----- "enph"
symbols     <-c("CSL.AX", "SPL.AX")
symbols     <- "SPL.AX"
dateFrom    <-"2002-01-01"
################################################################################
## Dates needed for .xts lookup           https://tinyurl.com/y3h3jbt7       ###
################################################################################
start.date  <-"2002-01-01"
end.date    <-Sys.Date()
################################################################################
## Quantstrat setup                                                          ###
################################################################################
options(getSymbols.warning4.0 = FALSE)                 # Suppresses warnings ###
## rm(list = ls(.blotter), envir = .blotter)           # Do some house cleaning#
Sys.setenv(TZ = "UTC")                                 # Set the timezone    ###
################################################################################
## Date Parameters                                                           ###
################################################################################
init_date   <- "1990-01-01"
start_date  <- "2002-01-02"
end_date    <- Sys.Date()
# ------------------------------------------------------------------------------
initDate    <- "1990-01-01"
from        <- "2002-01-01"
to          <- Sys.Date()
deathX      <- "(EMA.020 < EMA.050 &
                 EMA.050 < EMA.100 &
                 EMA.100 < EMA.200)"
deathXno    <- "(EMA.020 > EMA.050 |
                 EMA.050 > EMA.100 |
                 EMA.100 > EMA.200)"
goldenX     <- "(EMA.020 > EMA.050 &
                 EMA.050 > EMA.100 &
                 EMA.100 > EMA.200)"
################################################################################
## Equity Values                                                             ###
################################################################################
adjustment  <- TRUE                       # Adjust for Dividends, Stock Splits #
init_equity <- 1e4                        # $10,000                            #
initEq      <- 1e6                        # $1,000,000                         #
tradeSize   <- 10000
# ------------------------------------------------------------------------------
maxpos      <- 100
minpos      <- 0
# ------------------------------------------------------------------------------
TxnFees     <- 0                          # Transaction Fees
################################################################################
## Financial Instruments Package setup    # https://is.gd/3K7mRp ##
## Initialize Currency And Instruments    # https://financetrain.com/?p=26386
################################################################################
FinancialInstrument::currency(c("AUD"))                # Set the currency    ###
stock(c("SPL.AX"), currency ="AUD")                    # Define the stocks   ###
Sys.setenv(TZ = 'America/New_York')
# FinancialInstrument::exchange_rate('AUDUSD')         # define an exchange rate

usd_aud     <- Cl(getSymbols(
              "AUD=X",
              src="yahoo",
              from = init_date,
              auto.assign = FALSE))
usd_aud     <- complete.cases(usd_aud)
################################################################################
## Parameters                                                                ###
################################################################################
pctATR      <- .02
period      <- 10
atrOrder    <- TRUE
# ------------------------------------------------------------------------------
nRSI        <- 2
buyThresh   <- 20
sellThresh  <- 80
# ------------------------------------------------------------------------------
curr        <- 'AUD'
# ------------------------------------------------------------------------------
dXema       <- "dXema"
dXsma       <- "dXsma"
# ------------------------------------------------------------------------------
gXema       <- "gXema"
gXsma       <- "gXsma"
# ------------------------------------------------------------------------------
gxEMA       <- "gxEMA"
gxSMA       <- "gxSMA"
# ------------------------------------------------------------------------------
nXema       <- "nXema"
nxEMA       <- "nxEMA"
# ------------------------------------------------------------------------------
EMA         <- "EMA"
SMA         <- "SMA"
# ------------------------------------------------------------------------------
xA        <- "020"
xB        <- "050"
xC        <- "100"
xD        <- "200"
# ------------------------------------------------------------------------------
cross     <- c(xA,xB,xC,xD)
# ------------------------------------------------------------------------------
crossEMA <- data.table(cbind(rep(EMA,length(cross)),cross))
names(crossEMA)[1] <- "MA" # rename column name by index
crossEMA[ , crossMA := do.call(paste, c(.SD, sep = "."))]
signalEMA<-data.table(t(crossEMA[,3]))
# names(signalEMA)[1:4] <- cross
# ------------------------------------------------------------------------------
crossSMA <- data.table(cbind(rep(SMA,length(cross)),cross))
names(crossSMA)[1] <- "MA" # rename column name by index
crossSMA[ , crossMA := do.call(paste, c(.SD, sep = "."))]
signalSMA<-data.table(t(crossSMA[,3]))
# ------------------------------------------------------------------------------
nSMA020     <- 20
nSMA050     <- 50
nSMA100     <- 100
nSMA200     <- 200
################################################################################
## Custom Theme                                                              ###
################################################################################
myTheme<-chart_theme()
myTheme$col$dn.col    <- 'lightblue'
myTheme$col$dn.border <- 'lightgray'
myTheme$col$up.border <- 'lightgray'
################################################################################
# Add project specific configuration that can be overridden from load.project()
add.config(
  apply.override = TRUE
)
################################################################################
