# by(dt_strategy[, 1], dt_strategy[, 1:9], get_strategy.x0000_main, dt_strategy[,1:9])
# by(dt_strategy[, 1], dt_strategy[, 1:9], x0000_main, dt_strategy[, c(1, 8:9)])
# mapply(function(x,y) {x0000_main(id, dt_strategy)}, dt_strategy[, 1], dt_strategy[, 9])
# ------------------------------------------------------------------------------
# apply with multiple input functions
# An example of how to use mapply() to evaluate a function requiring more than
# one input over a matrix or array. 
# https://tinyurl.com/y5mkgrz4

# ------------------------------------------------------------------------------

#by(dt_strategy[, c(1, 10:7)], dt_strategy[, 1:10], x0000_main)

# ------------------------------------------------------------------------------
# apply(dt_strategy, 1, function(x) x0000_main(x))
# get_strategy.x0000_main()
# x0000_main()
# ------------------------------------------------------------------------------
# mapply(x0000_main, dt_strategy[,1], dt_strategy[,9])
# ------------------------------------------------------------------------------
# mapply(get_strategy.x0000_main, dt_strategy[,1], dt_strategy[,9])
