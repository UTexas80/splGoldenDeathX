# VERSION HISTORY
z99.version <- "1.0.0"
z99.ModDate <- as.Date("2019-06-09")
################################################################################
## Step 99.00 create object table                                            ###
################################################################################
dtObj <- setDT(lsos(), keep.rownames = T)[]
names(dtObj)[1] <- "Name" ### rename data.table column
lsObj <- list(dtObj[Type == "data.table" & Length_Rows == 0][, 1])
# dtObj[Type=='data.table' & Length_Rows == 0]
################################################################################
df <- ls()[sapply(ls(), function(x) is.data.frame(get(x)) | is.xts(get(x)))]
l <- ls()[sapply(ls(), function(x) is.data.frame(get(x)))]
################################################################################
## Step 99.02 create data dictionary                                         ### https://tinyurl.com/yyrgxxxp
################################################################################
# dObj               <- dtObj[Type %like% 'xts|data.']                                      # get the .xts and data(frames/tables) from the list of objects
# mlinker            <- build_linker(dObj, names(dObj), c(0,0,0,0,0,0))                     # create link master of data objects
# mdict              <- build_dict(dObj, mlinker, option_description = NULL,
#                                        prompt_varopts = FALSE)                 # create master dictionary of data objects

# df                 <-dObj[!Type=='xts' & (Name %like% '^dt') & Length_Rows >21]                 # create a dataframe containing a list of applicatble data.tables
# for ( i in 1:nrow(df)) {                                                       # loop through dataframes and create an individual dataframe.
#     assign(paste0("new_frame", i), df[i])                                      # https://tinyurl.com/yyjcaswv
# }
# paste(rep(0, new_frame3[,6]), collapse=",")                                    # create a list of zeros based on the number of columns

# build_linker(my.data, variable_description, variable_type)                     # build_linker base formula
# lapply(df,                                                                     # lapply build_linker formula over multiple dataframes
#   function(i)
#     {
#       build_linker(i[,1], names(i), rep(0, ncol(i), collapse=","))
#     }
# )

#  sapply(df[,1], function(x) {x})
# mapply(names, df$Name)


# df %>%
#   imap(~data.frame(value = df[[.y]][cbind(seq_along(.x), .x)]
#                   , ColName = colnames(df[[.y]])[.x]
#                   , ColIndex = .x))


# for (i in 1:nrow(df)) {
#    p               <-df$Name
#      for(j in p)
#    x               <- {names(p)}
# }

# lapply(df, `[[`, 1)

################################################################################
##                                                                           ### https://statistics.berkeley.edu/node/4343
################################################################################
# df[["Name"]]
# df[,1]
# df[,"Name"]

################################################################################
# save RData image
# save.image("splRData.RData")
################################################################################
## Step 99.01: Processing                                                    ###
################################################################################
# rmarkdown::render(input="./reports/dashboard.Rmd")
# rmarkdown::render(input="./dashboard/Flexdashboard.Rmd")

################################################################################
## Call rmarkdown::run() instead of render() because it is a shiny document  ### https://tinyurl.com/y2y2azny
## (http://rmarkdown.rstudio.com/authoring_shiny.html).                      ###
################################################################################
# rmarkdown::run("./reports/Flexdashboard.Rmd")
# rmarkdown::run("./reports/_Flexdashboard.Rmd")

# The Real Deal
rmarkdown::run("./dashboard/Flexdashboard.Rmd")

# xaringan::infinite_moon_reader("./reports/dashboard.Rmd")

## DIAGNOSTIC PAGE
s.info <- sessionInfo()
diagnostic <- data.frame("Version", "Date")
diagnostic[, 1] <- as.character(diagnostic[, 1])
diagnostic[, 2] <- as.character(diagnostic[, 2])
diagnostic.names <- NULL

## MAGIC NUMBER ## Strings have not member names - Depends on sessionInfo()
ver <- strsplit(s.info[["R.version"]][["version.string"]][1], " ")[[1]][3]
dat <- as.character(substr(strsplit(s.info[["R.version"]][["version.string"]][1], " ")[[1]][4], 2, 11))
diagnostic <- rbind(diagnostic, c(ver, dat))

ver <- s.info[["platform"]][1]
dat <- ""
diagnostic <- rbind(diagnostic, c(ver, dat))
diagnostic.names <- c(diagnostic.names, "R Version", "platform")


if (length(s.info[["otherPkgs"]]) > 0) {
  for (i in 1:length(s.info[["otherPkgs"]])) {
    ver <- s.info[["otherPkgs"]][[i]]$Version
    dat <- as.character(s.info[["otherPkgs"]][[i]]$Date)
    if (length(dat) == 0) {
      dat <- " "
    }
    diagnostic <- rbind(diagnostic, c(ver, dat))

    diagnostic.names <- c(diagnostic.names, s.info[["otherPkgs"]][[i]]$Package)
  }
}

if (length(s.info[["loadedOnly"]]) > 0) {
  for (i in 1:length(s.info[["loadedOnly"]])) {
    ver <- s.info[["loadedOnly"]][[i]]$Version
    dat <- as.character(s.info[["loadedOnly"]][[i]]$Date)
    if (length(dat) == 0) {
      dat <- " "
    }
    diagnostic <- rbind(diagnostic, c(ver, dat))

    diagnostic.names <- c(diagnostic.names, s.info[["loadedOnly"]][[i]]$Package)
  }
}

# Add code diagnostic information
diagnostic <- rbind(diagnostic, c(a00.version, as.character(a00.ModDate)))
diagnostic <- rbind(diagnostic, c(a01.version, as.character(a01.ModDate)))
diagnostic <- rbind(diagnostic, c(z99.version, as.character(z99.ModDate)))
diagnostic.names <- c(diagnostic.names, "00-A", "01-A", "99-Z")

diagnostic <- diagnostic[-1, ]
colnames(diagnostic) <- c("Version", "Date")
rownames(diagnostic) <- diagnostic.names

last.diagnostic <- 1
diagnostic.rows <- 19 # MAGIC NUMBER - TRIAL & ERROR

while (last.diagnostic <= nrow(diagnostic)) {
  tmp.diagnostic <- diagnostic[last.diagnostic:min(nrow(diagnostic), last.diagnostic + diagnostic.rows), ]
  # layout(c(1,1))
  # textplot(cbind(tmp.diagnostic),valign="top")


  last.diagnostic <- last.diagnostic + diagnostic.rows + 1
}

finish.time <- Sys.time()
timeProcessing <- finish.time - start.time
################################################################################
## Step 99.99: VERSION HISTORY                                               ###
## http://tinyurl.com/y54k8gsw                                               ###
## http://tinyurl.com/yx9w8vje                                               ###
################################################################################
a00.version <- "1.0.0"
a00.ModDate <- as.Date("2019-06-19")
# 2019.06.09 - v.1.0.0
#  1st release
