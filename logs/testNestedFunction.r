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
            sapply(dT.name,   function(d) {a})
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


unique(dT.test1[,c(1,3,8)])
mapply(function(x){x},c(unique(dT.test1[,c(1,3,8)])))

z<- unique(dT.test1[,c(1,3,8)])
g <- dT.test1
y<-unique(dT.test1[,c(1,3,8)])
setkeyv(g, keycols)
g[y[1,]]


#  set several columns as the key in data.table 
# https://tinyurl.com/w2ng9pj
setkeyv(z, c("id","i.id","i.id.1"))
