# Add any project specific configuration here.
add.config(
  apply.override = FALSE,
  currentYr      = as.numeric(format(Sys.Date(), format = "%y")),
  currentYr4     = as.numeric(format(Sys.Date(), format = "%Y")),
  lastYr         = as.numeric(format(Sys.Date(), format = "%y")) - 1,
  LastYr4        = as.numeric(format(Sys.Date(), format = "%Y")) - 1,
  header         = "SPL GoldenDeathX" # header in reports
)
################################################################################
## 0000Globals                                                               ###
################################################################################
## rm(list = ls(.blotter), envir = .blotter)           # Do some house cleaning#
.blotter <- new.env()                  # Guy Yollin's QuantStrat I lecture issue
.strategy <- new.env()                 # https://is.gd/eaFrdm
Sys.setenv(TZ = "UTC")                                 # Set the timezone    ###
Sys.setenv(TZ = 'America/New_York')
# ------------------------------------------------------------------------------
# ascertain global environment to dynamically name data frames 
# ------------------------------------------------------------------------------
g <- globalenv()                             # https://tinyurl.com/r3yrspv   ###
################################################################################
## 0100Setup getSymbols                                                      ###
################################################################################
adjustment    <- TRUE                     # Adjust for Dividends, Stock Splits #
# ------------------------------------------------------------------------------
from          <- "2002-01-01"
to            <- Sys.Date()
# ------------------------------------------------------------------------------
end_date      <- Sys.Date()
start_date    <- "2002-01-01"
# ------------------------------------------------------------------------------
options(getSymbols.warning4.0 = FALSE)                 # Suppresses warnings ###
# ------------------------------------------------------------------------------
src           <- "yahoo"
################################################################################
## 0200Initialization                                                        ###
################################################################################
symbols       <- c("CSL.AX", "SPL.AX")
symbols       <- "SPL.AX"
# ------------------------------------------------------------------------------
initDate      <- "1990-01-01"
initEq        <- 1e6                                              # $1,000,000 #
################################################################################
## 0300Indicators                                                            ###
################################################################################
EMA           <- "EMA"
SMA           <- "SMA"
# ------------------------------------------------------------------------------
xA            <- "020"
xB            <- "050"
xC            <- "100"
xD            <- "200"
# ------------------------------------------------------------------------------
xcross        <- c(xA,xB,xC,xD)
sig_ema_col   <- paste(EMA, xcross, sep = ".")
sig_sma_col   <- paste(SMA, xcross, sep = ".")
# ------------------------------------------------------------------------------
# Pass arguments to a function from each row of a matrix    https://is.gd/NEjTM3
# ------------------------------------------------------------------------------
crossEMA      <- data.table(cbind(rep("EMA",length(xcross)),xcross))
names(crossEMA)[1] <- "MA" # rename column name by index
crossEMA[ , crossMA := do.call(paste, c(.SD, sep = "."))]
signalEMA     <- data.table(t(crossEMA[,3]))
# names(signalEMA)[1:4] <- cross
# ------------------------------------------------------------------------------
crossSMA      <- data.table(cbind(rep(SMA,length(xcross)),xcross))
names(crossSMA)[1] <- "MA" # rename column name by index
crossSMA[ , crossMA := do.call(paste, c(.SD, sep = "."))]
signalSMA     <- data.table(t(crossSMA[,3]))
################################################################################
## 0400Signals                                                               ###
################################################################################
sigFormula    <- "sigFormula"
# ------------------------------------------------------------------------------
trigger       <- "trigger"
cross         <- TRUE
# ------------------------------------------------------------------------------
# 4.0	Signals - Formulas
# ------------------------------------------------------------------------------
ema_long      <- "(EMA.020 > EMA.050 & EMA.050 > EMA.100 & EMA.100 > EMA.200)"
ema_short     <- "(EMA.020 < EMA.050 & EMA.050 < EMA.100 & EMA.100 < EMA.200)"
# ------------------------------------------------------------------------------
sma_long      <- "(SMA.020 > SMA.050 & SMA.050 > SMA.100 & SMA.100 > SMA.200)"
sma_short     <- "(SMA.020 < SMA.050 & SMA.050 < SMA.100 & SMA.100 < SMA.200)"
# ------------------------------------------------------------------------------
dXema_open    <- ema_short
dXema_close   <- str_replace_all(ema_long, "&", "|")
# ------------------------------------------------------------------------------
dXsma_open    <- sma_short
dXsma_close   <- str_replace_all(sma_long, "&", "|")
# ------------------------------------------------------------------------------
gXema_open    <- ema_long
gXema_close   <- str_replace_all(ema_short, "&", "|")
# ------------------------------------------------------------------------------
gXsma_open    <- sma_long
gXsma_close   <- str_replace_all(sma_short, "&", "|")
# ------------------------------------------------------------------------------
nXema_open    <- paste0("!", ema_short, "& !", ema_long)
nXema_close   <- paste0(ema_short, " | ", ema_long)
# ------------------------------------------------------------------------------
nXsma_open    <- paste0("!", sma_short, "& !", sma_long)
nXsma_close   <- paste0(sma_short, " | ", sma_long)
################################################################################
## 0500Rules                                                                 ###
################################################################################
ruleSignal    <- "ruleSignal"
market        <- "market"
orderqty      <- as.integer(1e4)                                       # $10,000
orderqty_long <- as.integer(1e4)                                       # $10,000
orderqty_short<- -as.integer(1e4)                                      # $10,000
all           <- "all"
long          <- "long"
short         <- "short"
# ------------------------------------------------------------------------------
TxnFees       <- 0                          # Transaction Fees
################################################################################
## Dates needed for .xts lookup           https://tinyurl.com/y3h3jbt7       ###
################################################################################
start.date    <- "2002-01-01"
end.date      <- Sys.Date()
################################################################################
## Date Parameters                                                           ###
################################################################################
init_date     <- "1990-01-01"
################################################################################
## Equity Values                                                             ###
################################################################################
init_equity   <- as.integer(1e4)            # $10,000                          #
tradeSize     <- 10000
# ------------------------------------------------------------------------------
maxpos        <- 100
minpos        <- 0
################################################################################
## Financial Instruments Package setup    # https://is.gd/3K7mRp ##
## Initialize Currency And Instruments    # https://financetrain.com/?p=26386
################################################################################
FinancialInstrument::currency(c("AUD"))                # Set the currency    ###
stock(c("SPL.AX"), currency = "AUD")                   # Define the stocks   ###
# ------------------------------------------------------------------------------
# FinancialInstrument::exchange_rate('AUDUSD')         # define an exchange rate
# ------------------------------------------------------------------------------
usd_aud       <- Cl(getSymbols(
                  "AUD=X",
                  src = "yahoo",
                  from = init_date,
                  auto.assign = FALSE))
# ------------------------------------------------------------------------------
usd_aud       <- complete.cases(usd_aud)
################################################################################
## Parameters                                                                ###
################################################################################
pctATR        <- .02
period        <- 10
atrOrder      <- TRUE
# ------------------------------------------------------------------------------
nRSI          <- 2
buyThresh     <- 20
sellThresh    <- 80
# ------------------------------------------------------------------------------
curr          <- 'AUD'
# ------------------------------------------------------------------------------
dXema         <- "dXema"
dXsma         <- "dXsma"
# ------------------------------------------------------------------------------
gXema         <- "gXema"
gXsma         <- "gXsma"
# ------------------------------------------------------------------------------
gxEMA         <- "gxEMA"
gxSMA         <- "gxSMA"
# ------------------------------------------------------------------------------
nXema         <- "nXema"
nxEMA         <- "nxEMA"
# ------------------------------------------------------------------------------
nXsma         <- "nXsma"
nxSMA         <- "nxSMA"
################################################################################
## Custom Theme                                                              ###
################################################################################
myTheme               <- chart_theme()
myTheme$col$dn.col    <- 'lightblue'
myTheme$col$dn.border <- 'lightgray'
myTheme$col$up.border <- 'lightgray'
# ------------------------------------------------------------------------------
# * Setup a ggplot theme ----
clrs <- colorRampPalette(c("#00ff9f", "#00b8ff", "#001eff", "#bd00ff", "#d600ff"))(7)
# ------------------------------------------------------------------------------
clr_bg   <- "black"
clr_bg2  <- "gray10"
clr_grid <- "gray30"
clr_text <- "#d600ff"
# ------------------------------------------------------------------------------
# scales::show_col(clrs)
# ------------------------------------------------------------------------------
theme_cyberpunk <- function() {
    theme(
        # Plot / Panel
        plot.background = element_rect(fill = clr_bg, colour = clr_bg),
        # plot.margin = margin(1.5, 2, 1.5, 1.5, "cm"),
        panel.background = element_rect(fill = clr_bg, color = clr_bg),
        # Grid
        panel.grid = element_line(colour = clr_grid, size = 1),
        panel.grid.major = element_line(colour = clr_grid, size = 1),
        panel.grid.minor = element_line(colour = clr_grid, size = 1),
        axis.ticks.x = element_line(colour = clr_grid, size = 1),
        axis.line.y = element_line(colour = clr_grid, size = 0.5),
        axis.line.x = element_line(colour = clr_grid, size = 0.5),
        # Text
        plot.title = element_text(colour = clr_text),
        plot.subtitle = element_text(colour = clr_text),
        axis.text = element_text(colour = clr_text),
        axis.title = element_text(colour = clr_text),
        # Legend
        legend.background = element_blank(),
        legend.key = element_blank(),
        legend.title = element_text(colour = clr_text),
        legend.text = element_text(colour = "gray80", size = 12, face = "bold"),
        # Strip
        strip.background = element_rect(fill = clr_bg2, color = clr_bg2)
    )
}
################################################################################
# Add project specific configuration that can be overridden from load.project()
################################################################################
add.config(apply.override = TRUE)
################################################################################
