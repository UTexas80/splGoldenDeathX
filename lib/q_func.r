# ------------------------------------------------------------------------------
# function accept a dataframe as an argument?     https://tinyurl.com/vajvn48
# sapply with custom function (series of if statements)
# ------------------------------------------------------------------------------

browser()

# this is like an abstract base method
get_strategy               <- function(strategy_name, ...) {
    UseMethod("get_strategy")
}

get_strategy.x0000_main   <- function(strategy_name, ...) {
    print("x0000_main")
    print(strategy_name)
    #> [1] "x0100_setup"
    get_strategy.x0100_setup(strategy_name)
    get_strategy.x0200_init(strategy_name)
    get_strategy.x0300_ind(strategy_name)
    get_strategy.x0400_signals(strategy_name)
}

get_strategy.x0100_setup   <- function(strategy_name, ...) {
    print("x0100_setup")
    print(strategy_name)
    print(class(strategy_name))
    #> [1] "x0100_setup"
    # setupTrend <<- setDT(strategy_name)
    # get_Strategy.x0200_init(strategy_name)
}

get_strategy.x0200_init    <- function(strategy_name, ...) {
  print("x0200_init")
  #> [1] "x0200_initialization"
}

get_strategy.x0300_ind     <- function(strategy_name, ...) {
  print("x0300_ind")
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