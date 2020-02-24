helper.function <- function()
{
  return(1)
}

dummy <- function()
{
 
}

##-- Global assignment within a function:
myf <- function(x) {
    innerf <- function(x) assign("Global.res", x^2, envir = .GlobalEnv)
    innerf(x+1)
}

################################################################################
## How to lag date-index in a time-series in R?     ### https://is.gd/HbAJqH ###
## Where X is an xts object. I've converted the native POSIXct times into    ###
## dates, and added an NA to the head and taken off the final date with      ###
##  X[-nrow(X)]                                                              ### 
################################################################################       
dayDifff <- function(X)
{
    as.numeric(as.Date(index(X))) - c(NA, as.numeric(as.Date(index(X[-nrow(X)]))))
}

################################################################################
## Stock Symbols                                                             ###
## https://tinyurl.com/yxcttpsa                                              ###
################################################################################
basic_symbols <- function() {
    symbols <- c(
        "IWM", # iShares Russell 2000 Index ETF
        "QQQ", # PowerShares QQQ TRust, Series 1 ETF
        "SPY" # SPDR S&P 500 ETF Trust
    )
}
basic_symbols <- function() {
    symbols <- c(
        "SPL.AX" # Starpharma
    )
}
enhanced_symbols <- function() {
    symbols <- c(
        basic_symbols(), 
        "TLT", # iShares Barclays 20+ Yr Treas. Bond ETF
        "XLB", # Materials Select Sector SPDR ETF
        "XLE", # Energy Select Sector SPDR ETF
        "XLF", # Financial Select Sector SPDR ETF
        "XLI", # Industrials Select Sector SPDR ETF
        "XLK", # Technology  Select Sector SPDR ETF
        "XLP", # Consumer Staples  Select Sector SPDR ETF
        "XLU", # Utilities  Select Sector SPDR ETF
        "XLV", # Health Care  Select Sector SPDR ETF
        "XLY" # Consumer Discretionary  Select Sector SPDR ETF
    )
}
global_symbols <- function() {
    symbols <- c(
        enhanced_symbols(), 
        "EFA", # iShares EAFE
        "EPP", # iShares Pacific Ex Japan
        "EWA", # iShares Australia
        "EWC", # iShares Canada
        "EWG", # iShares Germany
        "EWH", # iShares Hong Kong
        "EWJ", # iShares Japan
        "EWS", # iShares Singapore
        "EWT", # iShares Taiwan
        "EWU", # iShares UK
        "EWY", # iShares South Korea
        "EWZ", # iShares Brazil
        "EZU", # iShares MSCI EMU ETF
        "IGE", # iShares North American Natural Resources
        "IYR", # iShares U.S. Real Estate
        "IYZ", # iShares U.S. Telecom
        "LQD", # iShares Investment Grade Corporate Bonds
        "SHY" # iShares 42372 year TBonds
    )
}

namedLag <- function(x, k = 1, na.pad = TRUE, ...) {
    out <- lag(x, k - k, na.pad = na.pad, ...)

    out[is.na(out)] <- x[is.na(out)]
    colnames(out) <- "namedLag"
    return(out)
}

################################################################################
# Strategy 1: A simple trend follower This first                               ###
################################################################################ 
# First function computes a lagged ATR.
"lagATR" <- function(HLC, n = 14, maType, lag = 1, ...) {
    ATR <- ATR(HLC, n = n, maType = maType, ...)
    ATR <- lag(ATR, lag)
    out <- ATR$atr
    colnames(out) <- "atr"
    return(out)
}
################################################################################
# The osDollarATR function finds the output of the first, and                  #
# sizes the order by rounding to the lowest(highest) amount                    #
# of integer shares when we go long(short), depending on ou                    r
# trade size and the amount risked.  So if we risk 2 percent                   #
# of a 10,000 trade size, we will get 200 ATRs worth of the                    #
# security long, or –200 short.                                                #
################################################################################
"osDollarATR" <- function(orderside, tradeSize, pctATR, maxPctATR = pctATR,
    data, timestamp, symbol, prefer = "Open", portfolio, integerQty = TRUE,
    strMod = "", rebal = FALSE, ...) {

    if (tradeSize > 0 & orderside == "short") {
        tradeSize <- tradeSize * -1
    }

    pos <- getPosQty(portfolio, symbol, timestamp)
    strString <- paste0("atr", strMod)
    strCol <- grep(strString, colnames(mktdata))

    if (length(strCol) == 0) {
        stop(paste("Term", strString, "not found in mktdata column names."))
    }

    strTimeStamp <- mktdata[timestamp, strCol]
    if (is.na(strTimeStamp) | strTimeStamp == 0) {
        stop(paste("ATR corrresponding to", strString, "is innvalid at this point in time. Add a logical
    operator to account for this."))
    }

    dollarATR <- pos * atrTimeStamp
    desiredDollarATR <- pctATR * tradeSize
    remainingRiskCapacity <- tradeSize * maxPctATR - dollarATR

    if (orderside == "long") {
        qty <- min(tradeSize * pctATR/strTimeStamp, remainingRiskCApacity/strTimeStamp)
    } else {
        qty <- max(tradeSize * pctATR/strTimeStamp, remainingRiskCapacity/strTimeStamp)
    }

    if (integerQty) {
        qty <- trunc(qty)
    }
    if (!rebal) {
        if (orderside == "long" & qty < 0) {
            qty <- 0
        }
        if (orderside == "short" & qty > 0) {
            qty <- 0
        }
    }
    if (rebal) {
        if (pos == 0) {
            qty <- 0
        }
    }
    return(qty)
}


# How to add multiple conditions to quantstrat?
# https://is.gd/tXXx8V
#'sigCOMP
#'@description signal comparison operators incl and, or, xor for quantstrat signals.
#'@param label name of the output signal
#'@param data the market data
#'@param columns the signal columns to intersect, if a second level comparison is used, the comparison result must reside in the first column only (compare one 2nd level with a True/False Column) or in both, marked by Keyword '2nd'
#'@param relationship operators gte, gt, lte, lt, eq, and, or, xor  TODO:NOT
#'@param secondComparison vector of columns to intersect, if yes, then also set the relationship comparison
#'@param relationshipSecondComparison operators gte, gt, lte, lt, eq
#'@param offset1 optional
#'@param offset2 optional
#'@return a new signal column that intersects the provided columns
#'@export


sigCOMP <- function (label, data = mktdata, columns, relationship = c("gte", "gt", "lte", "lt", "eq", "and", "or", "xor"),  relationshipSecondComparison = c("gte", "gt", "lte", "lt", "eq"), secondComparison, res_not, offset1 = 0, offset2 = 0) 
{
  ret_sig = NULL
  compcols <- NULL

  if(!missing(columns)){
    if (relationship == "op") {
      if (columns[1] %in% c("Close", "Cl", "close")) 
        stop("Close not supported with relationship=='op'")
      switch(columns[1], Low = , low = , bid = {
        relationship = "lt"
      }, Hi = , High = , high = , ask = {
        relationship = "gt"
      })
    } #whatever that is

    colNums <- NULL  
    for(sec in 1:length(columns)){
      if (columns[sec]=='2nd'){
        colNums <- c(colNums,0)
      }
      else{
        colNums <- c(colNums, match.names(columns[sec], colnames(data)))
      }
    }

    opr <- switch(relationship[1], 
                  gt = , `>` = ">",  
                  gte = , gteq = , ge = , `>=` = ">=",
                  lt = , `<` = "<", 
                  lte = , lteq = , le = , `<=` = "<=",
                  eq = , `==` = , `=` = "==",
                  and = "&",
                  or = "|",
                  xor = "xor"
                  # todo: NOT
    )

  } #perform preparation actions if 1|2 columns exist or else stop 
  else {

      stop("only works if two comparison columns are provided. for true/false evaluations you can add e.g. 2nd 2nd or <Signal>, 2nd ")  


  }

  if (!missing(secondComparison))
    {
      ret_sig2nd <- NULL
      opr2nd <- c(1:length(secondComparison))

        if (length(secondComparison) != length(relationshipSecondComparison)){
          stop("make sure to have a comparison operator for each second level comparison you would like to perform")
        } 
        else {

          for (j in 1:length(relationshipSecondComparison)) {
              # run through pairs of columns and relationship checks and return these in a dataframe ret_sig2nd
              # the return column of the appropriate pair will have the name col1 op col2 e.g. close gt nFast

              colNums2nd <- c(0,0)
              comp2ndPartners <- unlist(secondComparison[j])
              relationship2 <- unlist(relationshipSecondComparison)[j]
              colNums2nd[1] <- match.names(comp2ndPartners[1], colnames(data))
              colNums2nd[2] <- match.names(comp2ndPartners[2], colnames(data))
                opr2nd[j] <- switch(relationship2, 
                                  gt = , `>` = ">",  
                                  gte = , gteq = , ge = , `>=` = ">=",
                                  lt = , `<` = "<", 
                                  lte = , lteq = , le = , `<=` = "<=",
                                  eq = , `==` = , `=` = "==",
                                  and = "&",
                                  or = "|",
                                  xor = "xor"
                                  # todo: NOT
              )
               ret_append <- do.call(opr2nd[j], list(data[, colNums2nd[1]] + offset1, 
                                           data[, colNums2nd[2]] + offset2))  

               colnames(ret_append) <- paste0(comp2ndPartners[1]," ",relationship2[j]," ",comp2ndPartners[2])
               ret_sig2nd <- cbind(ret_sig2nd,ret_append)
               rm(ret_append)
            }

          compcols <- ret_sig2nd  
        } # end of 2nd Comp = 2nd Relationship validity block

      if(ncol(compcols)==1){ # check the case if only one second level comparison exists
        transfer2ndToFirst <- compcols  #assumption is, the second level comparison took place with the first column of the first level
        # if one second level comparison is provided, execute transfer object with second column of first level
        compcols <- transfer2ndToFirst[, 1] #offset already included in second level comparison
        compcols <- cbind(compcols, data[, colNums[2]] + offset2)

      } # provide the transfer object to be used in the first level comparison if only one second level comparison exists
    }
    else { # check the case if no second level comparison exists

      # if no second level comparison is provided, only execute first level
      compcols <- data[, colNums[1]] + offset1
      compcols <- cbind(compcols, data[, colNums[2]] + offset2)
    } # if no second level exists, execute comparison for first level only

    # for all cases, perform the first level comparison with the columns stored in compcols - offset has to be applied before storing to compcols 
    ret_sig <- do.call(opr, list(compcols[, 1] , 
                                 compcols[, 2] ))  

  colnames(ret_sig) <- label
  return(ret_sig)
}

# ### TESTS
# # To compare just two (first level) colums
# rm(testOnlyFirst)
# testOnlyFirst<- sigCOMP(
#   columns=c("nSlow","nFast"),
#   relationship=c("gt"),
#   label='GT'
# )
# 
# 
# #To compare a signal or another T/F value with a second level comparison
# rm(testOneSecond)
# testOneSecond<- sigCOMP(
#   columns=c("2nd","exitLong"),
#   relationship=c("and"),
#   secondComparison =list(c("Close", "nFast")),
#   relationshipSecondComparison = list(c("gt")),
#   label='andGT'
# )
# 
# 
# rm(test2Second)
# test2Second<- sigCOMP(
#   columns=c("2nd", "2nd"),
#   relationship=c("or"),
#   secondComparison =list(c("Close", "nFast"), c("Close", "nSlow")),
#   relationshipSecondComparison = list(c("gt"), c("gt")),
#   label='orGT'
# )
# 
# rm(test2SecondOr)
# test2SecondOr<- sigCOMP(
#   columns=c("2nd", "2nd"),
#   relationship=c("or"),
#   secondComparison =list(c("Close", "nFast"), c("Close", "nSlow")),
#   relationshipSecondComparison = list(c("gt"), c("gt")),
#   label='orGT'
# )
# 
# rm(test2SecondXor)
# test2SecondXor<- sigCOMP(
#   columns=c("2nd", "2nd"),
#   relationship=c("xor"),
#   secondComparison =list(c("Close", "nFast"), c("Close", "nSlow")),
#   relationshipSecondComparison = list(c("gt"), c("gt")),
#   label='orGT'
# )


################################################################################
## Tricks to manage the available memory in an R session                     ### https://tinyurl.com/yxcttpsa
################################################################################

# improved list of objects
.ls.objects <- function (pos = 1, pattern, order.by,
                        decreasing=FALSE, head=FALSE, n=5) {
    napply <- function(names, fn) sapply(names, function(x)
                                         fn(get(x, pos = pos)))
    names <- ls(pos = pos, pattern = pattern)
    obj.class <- napply(names, function(x) as.character(class(x))[1])
    obj.mode <- napply(names, mode)
    obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
    obj.prettysize <- napply(names, function(x) {
                           format(utils::object.size(x), units = "auto") })
    obj.size <- napply(names, object.size)
    obj.dim <- t(napply(names, function(x)
                        as.numeric(dim(x))[1:2]))
    vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
    obj.dim[vec, 1] <- napply(names, length)[vec]
    out <- data.frame(obj.type, obj.size, obj.prettysize, obj.dim)
    names(out) <- c("Type", "Size", "PrettySize", "Length_Rows", "Columns")
    if (!missing(order.by))
        out <- out[order(out[[order.by]], decreasing=decreasing), ]
    if (head)
        out <- head(out, n)
    out
}

# shorthand
lsos <- function(..., n=100) {
    .ls.objects(..., order.by="Size", decreasing=TRUE, head=TRUE, n=n)
}

################################################################################
## Repo Package: data management to build centralized metadata repository    ### https://github.com/franapoli/repo
## Check existence of directory and create if doesn't exist                  ### https://tinyurl.com/y3adrqwa
################################################################################
dirCheck <- function(mainDir, subDir) {
    if (!dir.exists(file.path(mainDir, subDir))) {
        dir.create(file.path(mainDir, subDir))
        rp <- repo_open(rp_path, T)
    }
}

f<- function (x) {
  x <- names(x)   
  return(x)
}

################################################################################
## function to compute simple returns                                        ### https://tinyurl.com/y2pmvtsg
################################################################################
simple.ret <- function(x, col.name){
  x[,col.name] / lag(x[,col.name]) - 1
}

################################################################################
## function to eliminate duplicates              https://tinyurl.com/twhxykb ###
################################################################################

dupsBetweenGroups <- function (df, idcol) {
    # df: the data frame
    # idcol: the column which identifies the group each row belongs to

    # Get the data columns to use for finding matches
    datacols <- setdiff(names(df), idcol)

    # Sort by idcol, then datacols. Save order so we can undo the sorting later.
    sortorder <- do.call(order, df)
    df <- df[sortorder,]

    # Find duplicates within each id group (first copy not marked)
    dupWithin <- duplicated(df)

    # With duplicates within each group filtered out, find duplicates between groups. 
    # Need to scan up and down with duplicated() because first copy is not marked.
    dupBetween = rep(NA, nrow(df))
    dupBetween[!dupWithin] <- duplicated(df[!dupWithin,datacols])
    dupBetween[!dupWithin] <- duplicated(df[!dupWithin,datacols], fromLast=TRUE) | dupBetween[!dupWithin]

    # ============= Replace NA's with previous non-NA value ==============
    # This is why we sorted earlier - it was necessary to do this part efficiently

    # Get indexes of non-NA's
    goodIdx <- !is.na(dupBetween)

    # These are the non-NA values from x only
    # Add a leading NA for later use when we index into this vector
    goodVals <- c(NA, dupBetween[goodIdx])

    # Fill the indices of the output vector with the indices pulled from
    # these offsets of goodVals. Add 1 to avoid indexing to zero.
    fillIdx <- cumsum(goodIdx)+1

    # The original vector, now with gaps filled
    dupBetween <- goodVals[fillIdx]

    # Undo the original sort
    dupBetween[sortorder] <- dupBetween

    # Return the vector of which entries are duplicated across groups
    return(dupBetween)
}
################################################################################
## Clean, Consistent Column Names               https://tinyurl.com/yy3wo8rq ###                         
################################################################################
clean_names <- function(.data, unique = FALSE) {
  n <- if (is.data.frame(.data)) colnames(.data) else .data

  n <- gsub("%+", "_pct_", n)
  n <- gsub("\\$+", "_dollars_", n)
  n <- gsub("\\++", "_plus_", n)
  n <- gsub("-+", "_minus_", n)
  n <- gsub("\\*+", "_star_", n)
  n <- gsub("#+", "_cnt_", n)
  n <- gsub("&+", "_and_", n)
  n <- gsub("@+", "_at_", n)

  n <- gsub("[^a-zA-Z0-9_]+", "_", n)
  n <- gsub("([A-Z][a-z])", "_\\1", n)
  n <- tolower(trimws(n))
  
  n <- gsub("(^_+|_+$)", "", n)
  
  n <- gsub("_+", "_", n)
  
  if (unique) n <- make.unique(n, sep = "_")
  
  if (is.data.frame(.data)) {
    colnames(.data) <- n
    .data
  } else {
    n
  }
}