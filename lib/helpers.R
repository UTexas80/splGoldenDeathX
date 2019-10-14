helper.function <- function()
{
  return(1)
}

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

# http://www.cookbook-r.com/Manipulating_data/Comparing_data_frames/
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
## Clean, Consistent Column Names                                               https://tinyurl.com/yy3wo8rq                          
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