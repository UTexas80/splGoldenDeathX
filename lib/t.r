################################################################################
# 0000 Main
################################################################################
x0000_main   <- function(id, ...) {
# ------------------------------------------------------------------------------
#   browser()
# ------------------------------------------------------------------------------
    z0100_setup(id, ...)                        %>%
      x0200_init(id, i, ...)                    %>%
        x0300_ind(id, i, ...)                   %>%
          x0400_signals(id, i, ...)             %>%
            x0500_rules(id, i, ...)             %>%
              x0600_limits(id, i, ...)          %>%
                x0700_strategy(id, i, ...)      %>%
                  x0800_evaluation(id, i, ...)  %>%
                    x0900_report(id, i, ...)
# ------------------------------------------------------------------------------
}
################################################################################
# 0100 Setup
################################################################################
z0100_setup   <- function(id, ...) {
# ------------------------------------------------------------------------------
#   browser()
# ------------------------------------------------------------------------------
    print("z0100_setup")
# ------------------------------------------------------------------------------
    dt_key <<- id
#   z0100_setup( dt_key[,2])
    strategy.st <<- portfolio.st <<- account.st <<- as.character(dt_key[,2])
# ------------------------------------------------------------------------------
    rm.strat(strategy.st)
    rm.strat(account.st)
    rm.strat(portfolio.st)
# ------------------------------------------------------------------------------
    #> [1] "x0100_Setup"
# ------------------------------------------------------------------------------
}
################################################################################
# 0200	Initialization
################################################################################
x0200_init    <- function(id, ...) {
# ------------------------------------------------------------------------------
#  browser()
# ------------------------------------------------------------------------------
  print("x0200_initialization")
# ------------------------------------------------------------------------------
    print(paste("strategy.st before initialization ", strategy.st))
    print(strategy.st)
    print(class(strategy.st))
# ------------------------------------------------------------------------------
  initPortf(name              = portfolio.st,         # Portfolio Initialization
            symbols           = symbols,
            currency          = curr,
            initDate          = initDate,
            initEq            = initEq)
# ------------------------------------------------------------------------------
  initAcct(name               = account.st,           # Account Initialization
           portfolios         = portfolio.st,
           currency           = curr,
           initDate           = initDate,
           initEq             = initEq)
# ------------------------------------------------------------------------------
  initOrders(portfolio        = portfolio.st,         # Order Initialization
             symbols          = symbols,
             initDate         = initDate)
# ------------------------------------------------------------------------------
  strategy(strategy.st, store = TRUE)                # Strategy initialization
# ------------------------------------------------------------------------------
    print(paste("strategy.st after initialization ", strategy.st))
    print(strategy.st)
    print(class(strategy.st))
# ------------------------------------------------------------------------------
}
################################################################################
# 0300	Indicators
################################################################################
x0300_ind     <- function(id, ...) {
# ------------------------------------------------------------------------------
#   browser()
# ------------------------------------------------------------------------------
    print("x0300_ind")
# ------------------------------------------------------------------------------
    print(strategy.st)
    print(class(strategy.st))
# ------------------------------------------------------------------------------
    apply(g[[paste0("cross", dt_key[,3])]],
          1,                                                            # by row
          function(x)
            indicators(
              x[1],
              as.integer(x[2]),
              as.integer(x[3]),
              x[4])
         )
# ------------------------------------------------------------------------------
    apply_indicators <<-
      g[[paste(dt_key[,2], "$ind", sep = "_")]] <<- 
        paste0("str(", getStrategy(dt_key[,2]),"$indicators)")
# ------------------------------------------------------------------------------
    ApplyIndicators(as.character(dt_key[,2]))            # apply indicators with strategy name
# ------------------------------------------------------------------------------
}
################################################################################
# 0400	Signals
################################################################################
x0400_signals <- function(id, ...) {
# ------------------------------------------------------------------------------
#    browser()
# ------------------------------------------------------------------------------
    print("x0400_signals")
#   print(dt_key)
#   print(class(dt_key))
# ------------------------------------------------------------------------------
#   print(id)
#   print(class(id))
# ------------------------------------------------------------------------------
    print(strategy.st)
    print(class(strategy.st))
# ------------------------------------------------------------------------------
  #> [1] "x0400_Signals"
# ------------------------------------------------------------------------------
# (name, columns, formula, label, cross, trendName, Label)
# ------------------------------------------------------------------------------
    setkey(dt_key, position)
# ------------------------------------------------------------------------------
    apply(dT.point, 1, function(x)                                               # dT.point = 'entry/exit'
      AddSignals(
        sigFormula,                                                              # name
        as.character(paste("sig", tolower(dt_key[,3]),"col", sep = "_")),                      # sig_ema_col e.g., "SMA.020"
        g[[paste(dt_key[,2], dT.trade[as.integer(x[1]),2], sep = "_")]],         # formula e.g., dXema_open...close
        trigger,                                                                 # label
        TRUE,                                                                    # cross
        as.character(dt_key[,2]),                                                              # trendName e.g., dXema
        as.character(paste0(dT.position[dt_key][, 2], x[2]))                                   # short/Entry...Exit
        )
      )
# ------------------------------------------------------------------------------
    Apply_Signals <<- g[[paste(dt_key[,2], "mktdata", "sig", sep = "_")]] <<-
      applySignals(
        strategy  = strategy.st,
        mktdata   = mktdata)
# ------------------------------------------------------------------------------
      g[[paste(dt_key[,2], "$sig", sep = "_")]] <<-
        paste0("str(", getStrategy(dt_key[,2]),"$signals)")
# ------------------------------------------------------------------------------
}
################################################################################
# 0500	Rules
################################################################################
x0500_rules <- function(id, ...) {
# ------------------------------------------------------------------------------
    browser()
# ------------------------------------------------------------------------------
    print("x0500_rules")
# ------------------------------------------------------------------------------
    print(dt_key)
    print(class(dt_key))
# ------------------------------------------------------------------------------
    print(strategy.st)
    print(class(strategy.st))
# ------------------------------------------------------------------------------
#   print(id)
#   print(class(id))

  #> [1] "x0500_Rules"
# ------------------------------------------------------------------------------
#    rules(paste(dXema, "shortenter", sep = "_"), TRUE, orderqty, "long", "market", "Open", "market", 0, "enter")
# ------------------------------------------------------------------------------    
    rules(as.character(paste0(dt_key[,2], "_", dT.position[dt_key][, 2], dT.point[1,2])),  
          TRUE, 
          orderqty, 
          as.character(dT.position[dt_key][,2]),
          "market", 
          as.character(stri_trans_general(dT.trade[1,2], id = "Title")),  
          "market", 
          0, 
          as.character(dT.point[1,2]))
  # ------------------------------------------------------------------------------    
    rules(paste(dXema, "shortexit",  sep = "_"), TRUE,  "all",   "long", "market", "Open", "market", 0, "exit")
# # ------------------------------------------------------------------------------
#    apply(dT.point, 1, function(x)                                                # dT.point    = 'entry/exit'
#      rules(                                                                      # dT.position = 'long/short'
#       as.character(paste0(dt_key[,2], "_", dT.position[dt_key][, 2], x[2])),                  # sigcol: dXema_short...entry/exit
#       TRUE,                                                                     # sigval
# #     orderqty,                                                                 # order qty
#       g[[paste("orderqty", dT.position[dt_key][,2], sep = "_")]],               # order qty
#       as.character(dT.position[dt_key][,2]),                                    # order side: long/short
#       "market",                                                                 # order type
#       as.character(stri_trans_general(dT.trade[1,2], id = "Title")),                          # prefer: Open (proper case)
#       "market",                                                                 # price method
#       0,                                                                        # transaction fees
# #     "enter"
#       as.character(x[2])                                                                      # type: enter/exit
#     )
#   )
# ------------------------------------------------------------------------------
    paste0("str(", getStrategy(dt_key[,2]),"$rules)")
# ------------------------------------------------------------------------------
}
################################################################################
# 0600 Position Limits
################################################################################
x0600_limits <- function(id, ...) {
# ------------------------------------------------------------------------------
#   browser()
# ------------------------------------------------------------------------------
    print("x0600_limits")
# ------------------------------------------------------------------------------
    print(dt_key)
    print(class(dt_key))
# ------------------------------------------------------------------------------
#   print(id)
#   print(class(id))
# ------------------------------------------------------------------------------

  #> [6] "x0600_Limits"
# ------------------------------------------------------------------------------
    positionLimits(maxpos, minpos)
# ------------------------------------------------------------------------------
}
################################################################################
# 0700	Strategy
################################################################################
x0700_strategy <- function(id, ...) {
# ------------------------------------------------------------------------------
    browser()
# ------------------------------------------------------------------------------
    print("x0700_strategy")
# ------------------------------------------------------------------------------
# Here is where the strategy is created-----------------------------------------
# ------------------------------------------------------------------------------
    Strategy(strategy.st)

#    mktdata <<- tail(mktdata,-200) # select all but first n rows: https://is.gd/atVOj2

    #> [7] "x0700_strategy"
}
################################################################################
# 0800	Evaluation - update P&L and generate transactional history
################################################################################
x0800_evaluation <- function(id, ...) {
# ------------------------------------------------------------------------------
    browser()
# ------------------------------------------------------------------------------
    evaluation(strategy.st)
    #> [1] "x0800_evaluation"
}
################################################################################
# 0900	Report - create dashboard report
################################################################################
x0900_report <- function(id, ...) {
# ------------------------------------------------------------------------------  
    browser()
# ------------------------------------------------------------------------------  
   report(dt_key[,2])
# ------------------------------------------------------------------------------
}
