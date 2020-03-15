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


mapply(function(x) {g[y[x,]][,c(9,11:13)]}, as.integer(rownames(y)), SIMPLIFY = FALSE)
mapply(function(x) {indicators(g[y[x,]][,c(9,11:13)])}, as.integer(rownames(y)), SIMPLIFY = FALSE)


  indicators(x[1], as.integer(x[2]), as.integer(x[3]), x[4]))


# Passing vector with multiple values into R function                           https://tinyurl.com/uy65emg 
mapply(function(x) {table(g[y[x,]][,c(9,11:13)])}, as.integer(rownames(y)), SIMPLIFY = FALSE)


# Nesting Functions in R with the Piping Operator                               https://tinyurl.com/vhap722
mapply(function(x) {g[y[x,]][,c(9,11:13)]} %>% {x}   , as.integer(rownames(y)), SIMPLIFY = FALSE)
mapply(function(x) {g[y[x,]][,c(9,11:13)]} %>% {g[y[x,]][,c(9,11:13)]}, as.integer(rownames(y)), SIMPLIFY = FALSE)