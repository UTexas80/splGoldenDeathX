################################################################################
# 1.0 Setup
################################################################################
setup(nXema)
################################################################################
# 3.0	Indicators
################################################################################
indicators(EMA, 4, 20,  "020")
indicators(EMA, 4, 50,  "050")
indicators(EMA, 4, 100, "100")
indicators(EMA, 4, 200, "200")
# ------------------------------------------------------------------------------
nXema_mktdata_ind <-  applyIndicators(              # apply indicators
    strategy                = strategy.st,
    mktdata                 = SPL.AX)
################################################################################
# 4.0	Signals
################################################################################
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list(
        columns             = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
        formula             = "(EMA.020 < EMA.050 &
                                EMA.050 < EMA.100 &
                                EMA.100 < EMA.200)",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXema_shortEntry")
# ------------------------------------------------------------------------------
add.signal(strategy.st,
    name                    = "sigFormula",
    arguments               = list
        (columns            = c("EMA.020","EMA.050","EMA.100", "EMA.200"),
        formula             = "(EMA.020 > EMA.050  |
                                EMA.050 > EMA.100  |
                                EMA.100 > EMA.200) &
                               index.xts(mktdata)  > '2002-12-02'",
         label              = "trigger",
         cross              = TRUE),
    label                   = "dXema_shortExit")
# ------------------------------------------------------------------------------
signals(nXema)
################################################################################
# 5.0	Rules                                      https://tinyurl.com/y93kc22r
################################################################################
rules("dXema_shortEntry", TRUE)
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
add.rule(strategy.st,
    name                    = "ruleSignal",
    arguments               = list(
        sigcol              = "dXema_shortExit",
        sigval              = TRUE,
        orderqty            = "all",
        orderside           = "short",
        ordertype           = "market",
        prefer              = "Open",
        pricemethod         = "market",
        TxnFees             = 0),
    type                    = "exit",
    path.dep                = TRUE)
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
