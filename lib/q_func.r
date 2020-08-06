# ------------------------------------------------------------------------------
# function accept a dataframe as an argument?     https://tinyurl.com/vajvn48
# sapply with custom function (series of if statements)
# ------------------------------------------------------------------------------

# this is like an abstract base method
get_strategy               <- function(strategy_name, ...) {
    UseMethod("get_strategy")
}

get_strategy.x0000_main   <- function(strategy_name,test, ...) {

  browser()

  print("x0000_main")
  print(strategy_name)
  print(class(strategy_name))
  
  #> [1] "x0100_setup"

}

get_strategy.x0100_setup   <- function(strategy_name, test, ...) {

    print("x0100_setup")
    print(strategy_name)
    print( test)
    print(class(test))
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