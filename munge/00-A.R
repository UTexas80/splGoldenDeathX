# Example preprocessing script.
# How Do I in R?                                https://tinyurl.com/y9j67lfk ###
############################################### https://tinyurl.com/yddh54gn ###
## checkpoint ## or any date in YYYY-MM-DD format after 2014-09-17 
## checkpoint("2015-01-15") 
################################################################################
## Step 00.00 Processing Start Time - start the timer                        ###
################################################################################
start.time <- Sys.time()
cross(20,50, 100, 200)
################################################################################
## Step 00.01 set data.table keys                                            ###
################################################################################
setkey(dT.name, id)
setkey(dT.strategy,trend)
setkey(dT.ind,trend)
setkey(dT.indMetrics, fk)
setkey(dT.sig,id)
# ------------------------------------------------------------------------------
dT.test <-  dT.name[
            dT.strategy][
            dT.ind, allow.cartesian = T]
setkey(dT.test, i.id.1)
# ------------------------------------------------------------------------------
dT.test1 <- dT.test[
            dT.indMetrics, allow.cartesian = T]
dT.test2 <- dT.test[
            dT.sig, allow.cartesian = T]
dT.test3 <- dT.indMetrics[
            dT.ind, allow.cartesian = T][
            i.id==1,c(7,3:5)]                     
################################################################################
## Step 00.99: VERSION HISTORY                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-01-01")
# ------------------------------------------------------------------------------
# 2019.06.09 - v.1.0.0
# 1st release
