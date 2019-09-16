# Example preprocessing script.
# How Do I in R?                                                                https://tinyurl.com/y9j67lfk

# checkpoint("2015-01-15") ## or any date in YYYY-MM-DD format after 2014-09-17 https://tinyurl.com/yddh54gn

# Processing Start Time
start.time <- Sys.time()

################################################################################
## Step 00.01 create object table                                            ###
## Check existence of directory and create if doesn't exist                  ### https://tinyurl.com/y3adrqwa
dirCheck(mainDir, subDir)
################################################################################

################################################################################
## Step 00.99 VERSION HISTORY
a00.version = "1.0.0"
a00.ModDate = as.Date("2019-06-09")
################################################################################
# 2019.06.09 - v.1.0.0
#  1st release