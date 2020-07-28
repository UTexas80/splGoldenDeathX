apply(z, 1, function(x)
    indicators(
        x[1], 
        as.integer(x[2]),
        as.integer(x[3]),
        x[4]))
str(getStrategy(nXema)$indicators)


t(
sapply(dT.indMetrics, function(a) {
    sapply(dT.ind, function(b) {
        sapply(dT.strategy, function(c) { 
            sapply(dT.name, function(d) {a})
            })
        })
    })
)


t(
    sapply(z$id, function(a) {
        sapply(z$i.id, function(b) {
            sapply(z$i.id.1,    function(c) { 
                sapply(dT.indMetrics, function(d) {d[2]==b && d[3]=c})
            })
        })
    })
)

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
aList = mapply(someFunction, mojo[,1], mojo[,2], mojo[,3], SIMPLIFY = F)

# Compare this with the following:
  
  for (a in 1:length(a))
  {
    for (b in 1:length(b))
    {
      for (c in 1:length(c))
      {
        aListElement = someFunction(a, b, c)
      }
    }
  }
# ------------------------------------------------------------------------------
unique(dT.test1[,c(1,3,8)])
mapply(function(x){x},c(unique(dT.test1[,c(1,3,8)])))

z<- unique(dT.test1[,c(1,3,8)])

#  set several columns as the key in data.table 
# https://tinyurl.com/w2ng9pj
setkeyv(z, c("id","i.id","i.id.1"))

g <- dT.test1
keycols = c("id","i.id","i.id.1")
setkeyv(g, keycols)
setkeyv(dT.test1, keycols)

y<-unique(dT.test1[,c(1,3,8)])
setkeyv(y, keycols)

g[y[1,]]
g[y[3,]][,c(9,11:13)]


sapply(z$id, function(a) {
    sapply(z$i.id, function(b) {
        sapply(z$i.id.1, function(c) { 
            c
        })
    })
})

# mapply and by functions in R      
# tinyurl.com/vs7god7                                            https://tinyurl.com/vs7god7
mapply(function(x) {g[y[x,]][,c(9,11:13)]}, as.integer(rownames(y)), SIMPLIFY = FALSE)
mapply(function(x) {indicators(g[y[x,]][,c(9,11:13)])}, as.integer(rownames(y)), SIMPLIFY = FALSE)


  # sindicators(x[1], as.integer(x[2]), as.integer(x[3]), x[4]))


# Passing vector with multiple values into R function                           https://tinyurl.com/uy65emg 
mapply(function(x) {table(g[y[x,]][,c(9,11:13)])}, as.integer(rownames(y)), SIMPLIFY = FALSE)
dT.trend <- dT.strategy[
    dT.ind, allow.cartesian = T][,c(1:2,5,8)][, tname:= paste0(abbv,i.name)]

# Nesting Functions in R with the Piping Operator                               https://tinyurl.com/vhap722
mapply(function(x) {g[y[x,]][,c(9,11:13)]} %>% {x}, as.integer(rownames(y)), SIMPLIFY = FALSE)
mapply(function(x) {table(g[y[x,]][,c(9,11:13)])} %>% {g[y[x,]][,c(9,11:13)]}, as.integer(rownames(y)), SIMPLIFY = FALSE)

mapply(function(x) {g[y[x,]][,c(9,11:13)]} %>% {x}, as.integer(rownames(y)), SIMPLIFY = FALSE)

apply(crossEMA, 1, function(x)
  indicators(
    x[1], 
    as.integer(x[2]),
    as.integer(x[3]),
    x[4]))

mapply(function(x) {
  apply(table(g[y[x,]][,c(9,11:13)]), 1, function(x)
    indicators(x[1], as.integer(x[2]),as.integer(x[3]),x[4]))}, 
  as.integer(rownames(y)), SIMPLIFY = FALSE)


m <- mapply(function(x) {table(g[y[x,]][,c(9,11:13)])} %>% {g[y[x,]][,c(9,11:13)]}, as.integer(rownames(y)), SIMPLIFY = FALSE)


# function accept a dataframe as an argument?     https://tinyurl.com/vajvn48
dt_ind_ema <- data.table(crossEMA)

# add class to stock
class(dt_ind_ema) <- "ind"

# this is an abstract base method
get_Strategy <- function(dt_ind) {
  UseMethod("get_Strategy")
}

# this is the implementation for "indicator" objects,
# you could have more for other "class" objects
get_Strategy.ind <<- function(dt_ind){
  library("data.table")
  print("Plot  Indicators")
  x <<- data.table(dt_ind)
  dt_ind[,1]
  x[,1]
}





# =----
  
  get_setup <- function(trend) {
    UseMethod("get_setup")
  }
class(trend_name) < "name"
class(trend_name) < "trend"
get_setup.trend <<- function(trend_name){
  library("data.table")
  print("Plot strategy")
  x <- data.table(trend_name)
  trend_name[,5]
}
get_setup.trend <<- function(trend_name){
  library("data.table")
  print("Plot strategy")
  x <<- data.table(trend_name)
  trend_name[,5]
}
get_Strategy(dt_ind_ema)

mapply(function(x){setup(x)},trend_name)


# this is an abstract base method
get_Strategy <<- function(dt_ind) {
  UseMethod("get_Strategy")
}

# this is the implementation for "indicator" objects,
# you could have more for other "class" objects
get_Strategy.ind <<- function(dt_ind){
  
  print("Plot  Indicators")
  
  dt_ind <<- setDT(dt_ind, FALSE)
  
  # as.data.table(dt_indc)
  
  apply(dt_ind, 1, function(x)indicators(
    x[1],
    as.integer(x[2]),
    as.integer(x[3]),
    x[4]))
  
}

testListToDt <- function(ls_ind) {
  
  lapply(ls_ind, function(x) x)
}

for (i in 1:nrow(setupTrend)) {
  print (i)
  for (j in 1:nrow(trend_ind)) {
    print (j)
  }
}