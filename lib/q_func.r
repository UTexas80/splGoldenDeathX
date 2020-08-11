# ------------------------------------------------------------------------------
# function accept a dataframe as an argument?     https://tinyurl.com/vajvn48
# sapply with custom function (series of if statements)
# ------------------------------------------------------------------------------
# this is like an abstract base method
get_strategy              <- function(strategyName, ...) {
    UseMethod("get_strategy")
}
################################################################################
# 0000 Main
################################################################################
get_strategy.x0000_main   <- function(strategyName, ...) {
# ------------------------------------------------------------------------------
    browser()
    print("x0000_main")
    print(strategyName[,1])
    print(strategyName[,2])
    print(class(strategyName))
    #> [0] "x0000_main"
# ------------------------------------------------------------------------------
    get_strategy.x0100_setup(strategyName[,1])         %>%
      get_strategy.x0200_init(strategyName[,1])        %>%
        get_strategy.x0300_ind(strategyName[,2])       %>%
          get_strategy.x0400_signals(dt_strategy[, 1])
# ------------------------------------------------------------------------------
}
################################################################################
# 0100 Setup
################################################################################
get_strategy.x0100_setup   <- function(strategyName, ...) {
# ------------------------------------------------------------------------------
    browser()
    print("x0100_setup")
    print(strategyName)
    print(class(strategyName))
    #> [1] "x0100_setup"
# ------------------------------------------------------------------------------
    strategy.st <<- portfolio.st <<- account.st <<- strategyName[,1]
# ------------------------------------------------------------------------------
#     rm.strat(strategy.st)
#     rm.strat(account.st)
#     rm.strat(portfolio.st)
# ------------------------------------------------------------------------------
}
################################################################################
# 0200	Initialization
################################################################################
get_strategy.x0200_init    <- function(strategyName, ...) {
# ------------------------------------------------------------------------------
  browser()
  print("x0200_init")
  print(strategyName)
  print(class(strategyName))
  #> [2] "x0200_initialization"
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
  initOrders(portfolio        = unlist(portfolio.st), # Order Initialization
             symbols          = symbols,
             initDate         = initDate)
# ------------------------------------------------------------------------------
  strategy(unlist(strategy.st), store = TRUE)         # Strategy initialization
# ------------------------------------------------------------------------------
}
################################################################################
# 3.0	Indicators
################################################################################
get_strategy.x0300_ind     <- function(ind_name, ...) {
# ------------------------------------------------------------------------------
  browser()
  print("x0300_ind")
  print(ind_name)
  print(class(ind_name))
  #> [1] "x0300_Indicators"

}

get_strategy.x0400_signals <- function(strategy_name, ...) {
  print("x0400_signals")
  #> [1] "x0400_Signals"
}

stocks <- data.frame(
    time = as.Date('2009-01-01') + 0:9,
    X = rnorm(10, 0, 1),
    Y = rnorm(10, 0, 2),
    Z = rnorm(10, 0, 4)
)
# add class to stock
class(stocks) <- "stock"

# this is like an abstract base method
getStockPlot <- function(stocks_df) {
    UseMethod("getStockPlot")
}

# this is the implementation for "stock" objects,
# you could have more for other "class" objects
getStockPlot.stock <- function(stocks_df){
    print("Plot Stocks")
}

getStockPlot(stocks)


# ------------------------------------------------------------------------------
# Nested loops with mapply                  https://www.r-bloggers.com/?p=64565
# ------------------------------------------------------------------------------
a = c("A", "B")
b = c("L", "M")
c = c("X", "Y")
# ------------------------------------------------------------------------------
var1 = rep(a, length(b))
var1 = var1[order(var1)]
var2 = rep(b, length(a))
df = data.frame(a = var1, b = var2)
# ------------------------------------------------------------------------------
CartProduct = function(CurrentMatrix, NewElement)
{
  
  if (length(dim(NewElement)) != 0 )
  {
    warning("New vector has more than one dimension.")
    return (NULL)
  }
  
  if (length(dim(CurrentMatrix)) == 0)
  {
    CurrentRows = length(CurrentMatrix)
    CurrentMatrix = as.matrix(CurrentMatrix, nrow = CurrentRows, ncol = 1)
  } else {
    CurrentRows = nrow(CurrentMatrix)
  }
  
  var1 = replicate(length(NewElement), CurrentMatrix, simplify=F)
  var1 = do.call("rbind", var1)
  
  var2 = rep(NewElement, CurrentRows)
  var2 = matrix(var2[order(var2)], nrow = length(var2), ncol = 1)
  
  CartProduct = cbind(var1, var2)
  return (CartProduct)
}
# ------------------------------------------------------------------------------
someFunction = function(a, b, c)
{
  aList = list(a = toupper(a), b = tolower(b), c = c)
  return (aList)
}
mojo = CartProduct(a, b)
mojo = CartProduct(mojo,c)