apply(z, 1, function(x)
    indicators(
        x[1], 
        as.integer(x[2]),
        as.integer(x[3]),
        x[4]))
str(getStrategy(nXema)$indicators)


t(sapply(dT.indMetrics, function(a) {
    sapply(dT.ind,        function(b) { 
        sapply(dT.strategy,   function(c) {c})})}))