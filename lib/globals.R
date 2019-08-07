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

symbols<-c("CSL.AX", "SPL.AX")
dateFrom<-"2002-01-01"

################################################################################
## Dates needed for .xts lookup        ###                                      https://tinyurl.com/y3h3jbt7
################################################################################
start.date<-"2002-01-01"
end.date<-Sys.Date()

# Add project specific configuration that can be overridden from load.project()
add.config(
  apply.override = TRUE
)
