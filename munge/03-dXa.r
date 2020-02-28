################################################################################
# 1.0 Setup
################################################################################
setup(nXema)
################################################################################
# 3.0	Indicators
################################################################################
browser()
# x <- list("EMA", 4, 20, "020")
# z<-paste("'",as.character(x),"'",collapse=", ",sep="")
# indicators(x)
# ------------------------------------------------------------------------------
# indicators(EMA, 4, 20,  "020")
# indicators(EMA, 4, 50,  "050")
# indicators(EMA, 4, 100, "100")
# indicators(EMA, 4, 200, "200")
# indEMA <- cbind(EMA,4,t(cross(20,50,100,200)),sprintf("%03d",t(cross(20,50,100,200))))
apply(crossEMA, 1, function(x)do.call(indicators, as.list(x)))
str(getStrategy(nXema)$indicators)
# ------------------------------------------------------------------------------
browser()
ApplyIndicators(nXema)                              # apply indicators
browser()
# nXema_mktdata_ind <-  applyIndicators(
#     strategy                = strategy.st,
#     mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
browser()
AddSignals("sigFormula",c("EMA.020","EMA.050","EMA.100","EMA.200"), deathX,   "trigger", TRUE , nXema, "shortEntry")
AddSignals("sigFormula",c("EMA.020","EMA.050","EMA.100","EMA.200"), deathXno, "trigger", TRUE , nXema, "shortExit")
# add.signal(strategy.st,
#     name                    = "sigFormula",
#     arguments               = list(
#         columns             = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
#         formula             = deathX,
#          label              = "trigger",
#          cross              = TRUE),
#     label                   = paste(nXema, "shortEntry", sep = "_"))
# ------------------------------------------------------------------------------
#add.signal(strategy.st,
#    name                    = "sigFormula",
#    arguments               = list
#        (columns            = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
#         formula            = deathXno,
#         label              = "trigger",
#         cross              = TRUE),
#    label                   =  paste(nXema, "shortExit", sep = "_"))
# ------------------------------------------------------------------------------
ApplySignals(nXema)
################################################################################
# 5.0	Rules                                      https://tinyurl.com/y93kc22r
################################################################################
rules(paste(nXema, "shortEntry", sep = "_"), TRUE, -1000, "short", "market", "Open", "market", 0, "enter")
rules(paste(nXema, "shortExit",  sep = "_"), TRUE,  1000, "short", "market", "Open", "market", 0, "exit")
# rules("dXema_shortEntry", 1:10, xlab="My x axis", ylab="My y axis")
# add.rule(strategy.st,
#     name                    = "ruleSignal",
#     arguments               = list(
#         sigcol              = "dXema_shortEntry",
#         sigval              = TRUE,
#         orderqty            = -1000,
#         orderside           = "short",
#         ordertype           = "market",
#         prefer              = "Open",
#         pricemethod         = "market",
#         TxnFees             = 0),
  #      osFUN               = osMaxPos),
#   type                    = "enter",
#    path.dep                = TRUE)
# ------------------------------------------------------------------------------
# add.rule(strategy.st,
#     name                    = "ruleSignal",
#     arguments               = list(
#         sigcol              = "dXema_shortExit",
#         sigval              = TRUE,
#         orderqty            = "all",
#         orderside           = "short",
#         ordertype           = "market",
#         prefer              = "Open",
#         pricemethod         = "market",
#         TxnFees             = 0),
#     type                    = "exit",
#     path.dep                = TRUE)
################################################################################
# 6.0	Position Limits
################################################################################
positionLimits(maxpos, minpos)
################################################################################
# 7.0	Strategy
################################################################################
Strategy(nXema)
################################################################################
# 8.0	Evaluation - update P&L and generate transactional history
################################################################################
evaluation()
################################################################################
# 9.0	Trend - create dashboard dataset
################################################################################
report(nXema)
# ------------------------------------------------------------------------------
